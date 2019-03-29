FINALPACKAGE = 1
ARCHS = arm64
SDKVERSION = 10.3
THEOS_PACKAGE_DIR_NAME = debs
TARGET = iphone:10.3:10

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DictionaryExample
DictionaryExample_FILES = $(wildcard *.xm) $(wildcard *.m)
DictionaryExample_FRAMEWORKS = UIKit CoreGraphics
DictionaryExample_CFlags = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += DictionaryExamplePrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard; killall -9 Preferences"

after-stage::
	find . -name ".DS_Store" -delete
