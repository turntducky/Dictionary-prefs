DEBUG = 0
ARCHS = arm64 arm63e
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DictionaryExamplePrefs
DictionaryExamplePrefs_FILES = $(wildcard *.m)
DictionaryExamplePrefs_INSTALL_PATH = /Library/PreferenceBundles
DictionaryExamplePrefs_FRAMEWORKS = UIKit
DictionaryExamplePrefs_PRIVATE_FRAMEWORKS = Preferences
DictionaryExamplePrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DictionaryExamplePrefs.plist$(ECHO_END)
