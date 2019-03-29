/* What all you import for your tweak */
#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>

/* This is needed but never changes after you first put it in */
/* Change "kdictionaryexampleSettings" to "k[tweakname]Settings" */
/* Change "com.ducksrepo.dictionaryexample.plist" to your tweaks .plist file name*/
static NSString* const kdictionaryexampleSettings = @"/var/mobile/Library/Preferences/com.ducksrepo.dictionaryexample.plist";

static NSMutableDictionary *settings;

/* This pulls from plist */
/* [THIS IS NEEDED] each time you make a new plist part you need to static bool key */
static BOOL Enablepopup = NO;
static BOOL Enablenoold = NO;
//static BOOL keyname = NO;

void refreshPrefs()
{
    [settings release];
    /* Change "com.ducksrepo.dictionaryexample.plist" to your tweaks .plist file name*/
    settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ducksrepo.dictionaryexample.plist"]; //Load settings the old way.
    /* Change your static bool name to your plist key name */
    Enablepopup = [settings objectForKey:@"popup"] ? [[settings objectForKey:@"popup"] boolValue] : YES;
		Enablenoold = [settings objectForKey:@"noold"] ? [[settings objectForKey:@"noold"] boolValue] : YES;


}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    refreshPrefs();
}

/*

	Explanation -
	: hook what you want to tweak
	: "-" indicates that the method is an instance method, as opposed to a class method "(void)" indicates the return type {This can be found with FLEXible or in headers}
	: if() basically says "if popup is enabled then ..."
	: %orig; overrides what the original code does
	: Then we make a UIAlert
	: Then the title of the alert
	: Put text in the body
	: delegate is an object that acts on behalf of, or in coordination with, another object when that object encounters an event in a program
	: Then put what the button says
	: We have the other buttons hidden
	: Show the alert
	: else{} says if the key isnt enabled then use original

*/

//Respring popup

//A new iOS update is now available. Please update from the iOS 12 beta.
/* Must group your key name */
%group popup
%hook SBHomeScreenViewController
-(void) viewDidAppear:(BOOL)arg1 {
/* if statement needs to have if([[{NSMutableDictionary name} objectForKey:@"[keyname]"] boolValue] == YES) */
if([[settings objectForKey:@"popup"] boolValue] == YES ){
    %orig;

		UIAlertController * alert = [UIAlertController
		alertControllerWithTitle:@"A new iOS update is now available. Please update from the iOS 12 beta."
    message:nil
    preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction * close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];

		[alert addAction:close];
		[self presentViewController:alert animated:YES completion:nil];

}
else {%orig;}
}
%end
%end
/* end your group for your key once you complete your tweak completely. if your tweak still needs to check if the toggle is
enabled then do not end your group (Example below) */
//End respring popup

//Hide "No Older Notifications" text from LS and NC
/* Group key name */
%group noold
%hook NCNotificationListSectionRevealHintView
-(void)layoutRevealHintTitle {//stops reveal hint from loading
/* have if([[{NSMutableDictionary name} objectForKey:@"[keyname]"] boolValue] == YES) */
if([[settings objectForKey:@"noold"] boolValue] == YES ){

} else {%orig;}
		}

-(void)layoutSubviews {//this one will fix some compatibility errors with the first one
/* have if([[{NSMutableDictionary name} objectForKey:@"[keyname]"] boolValue] == YES) for another void statement that checks
to see if toggle is enabled */
if([[settings objectForKey:@"noold"] boolValue] == YES ){
		[self setHidden:YES];
	}
	else {%orig;}
}

%end
%end
/* End group of your key name when done */
//End Hidding No Older Notifications

%ctor {
    @autoreleasepool {
      /* change kdictionaryexampleSettings to k[tweakname]Settings */
        settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[kdictionaryexampleSettings stringByExpandingTildeInPath]];

		if(settings == NULL)
		{
			//If preferences plist does not exist, create it with default settings
			settings = [@{
                /* each key name needs to be added here */
                /* @"[keyname]" : FALSE */
                @"popup" : @FALSE,
								@"noold" : @FALSE
                /* if you have multiple toggles add a comma after FALSE but on the last one do not add one */
			} mutableCopy];
		}

    /* Add this for each key you have */
		if([[settings objectForKey:@"popup"] boolValue])
    {
	  // Only init hooks if the tweak has actually been set to enabled.
    /* Change "com.ducksrepo.dictionaryexample.settingschanged" to your tweaks plist file name and add .settingschanged to the end */
    /* CFSTR("[plist file name].settingschanged") */
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.ducksrepo.dictionaryexample.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		 refreshPrefs();
			%init(popup);
    }

    /* Do the same with all of the other keys you have */
    if([[settings objectForKey:@"noold"] boolValue])
    {
   // Only init hooks if the tweak has actually been set to enabled.
	 CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.ducksrepo.dictionaryexample.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	  refreshPrefs();
	   %init(noold);
    }
    /*
    if([[settings objectForKey:@"[keyname]"] boolValue])
    {
    // Only init hooks if the tweak has actually been set to enabled.
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("[plist file name].settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
     refreshPrefs();
      %init([keyname]);
    }
    */
  }
}
