#import "WKInterfaceButton.h"
#import "UIColor+PCK_StringToColor.h"

@implementation WKInterfaceButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        // The `enabled` property of a button in storyboard plist representation
        // only appears if the button has been disabled.  Otherwise any button
        // on an interface controller will be enabled.
        //
        self.enabled = YES;
    }
    return self;
}

- (void)setTitleColor:(NSString *)color
{
    _color = [UIColor colorWithNameOrHexValue:color];
}

@end
