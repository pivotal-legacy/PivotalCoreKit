#import "WKInterfaceButton.h"
#import "WKInterfaceController.h"
#import "UIColor+PCK_StringToColor.h"


@interface WKInterfaceButton ()

@property (nonatomic, copy) NSString *action;

@end


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

- (void)setTitleColor:(id)color
{
    _color = [color isKindOfClass:[UIColor class]] ? color : [UIColor colorWithNameOrHexValue:color];
}

- (void)tap
{
#       pragma clang diagnostic push
#       pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.parentController performSelector:NSSelectorFromString(self.action)];
#       pragma clang diagnostic pop
}

@end
