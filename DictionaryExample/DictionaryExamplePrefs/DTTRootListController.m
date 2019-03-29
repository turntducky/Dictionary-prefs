#include "DTTRootListController.h"
#include "notify.h"
#include <spawn.h>

@implementation DTTRootListController

/* Change "com.ducksrepo.dictionaryexample.plist" to your tweaks .plist file name */
NSString *const nsPreferenceFile = @"/var/mobile/Library/Preferences/com.ducksrepo.dictionaryexample.plist";

- (NSArray *)specifiers {
	if (shouldReload)
	{
		shouldReload = NO;
		[_specifiers release];
		_specifiers = nil;
	}

	if (!_specifiers)
	 {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	 }

	return _specifiers;
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
  id result;
  NSDictionary *exchangentSettings = [NSDictionary dictionaryWithContentsOfFile:nsPreferenceFile];
  NSString *key = specifier.properties[@"key"];
  if ([key isEqualToString:@"presetUserAgent"]) {
    // Dynamically construct the User Agent by appending the Device and iOS Version together.
    result = [NSString stringWithFormat:@"%@/%@", exchangentSettings[@"device"], exchangentSettings[@"iosVersion"]];
  } else if (!exchangentSettings[specifier.properties[@"key"]]) {
    // Preference doesn't have a value (unset), so fetch the default.
    result = specifier.properties[@"default"];
  } else {
    // Fetch the preference value
    result = exchangentSettings[specifier.properties[@"key"]];
  }

  // If Device or iOS Version changed, reload the User-Agent specifier to match the device/version.
  if ([key isEqualToString:@"device"] || [key isEqualToString:@"iosVersion"]) {
    [self reloadSpecifierID:@"User-Agent"];
  }

  return result;
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
  [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:nsPreferenceFile]];
  [defaults setObject:value forKey:specifier.properties[@"key"]];
  [defaults writeToFile:nsPreferenceFile atomically:YES];

  // Send Notification (via Darwin) if one is specified for the preference value.
  // This will notify the Tweak (.xm) that the preference value changed.
  CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
  if (toPost) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
  }
  // If "Use Custom User-Agent" is enabled/disabled, or if thw Tweak is enabled/disabled, then reload all specifiers.
  // This allows the filtering logic inside "specifiers()" to run and re-construct the preference page.
  if ([specifier.properties[@"key"] isEqualToString:@"useCustom"] || [specifier.properties[@"key"] isEqualToString:@"enabled"]) {
    shouldReload = YES;

    [self reloadSpecifiers];
  }
}

- (void)respring:(id)sender {
	pid_t pid;
  int status;
  const char* args[] = {"killall", "-9", "SpringBoard", NULL};
  posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
  waitpid(pid, &status, WEXITED);
}
@end
