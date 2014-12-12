#import "WKInterfaceSwitch.h"

@implementation WKInterfaceSwitch

- (instancetype)init
{
    self = [super init];
    if (self) {
        // The `enabled` property of a button in storyboard plist representation
        // only appears if the button has been disabled.  Otherwise any button
        // on an interface controller will be enabled.
        //
        self.enabled = YES;
        self.on = YES;
    }
    return self;
}

- (void)tap {
    self.on = !self.on;
}

@end
