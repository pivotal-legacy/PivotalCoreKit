#import "WKInterfaceSwitch.h"


@interface WKInterfaceObject ()

- (void)setEnabled:(BOOL)enabled NS_REQUIRES_SUPER;
- (void)setOn:(BOOL)on NS_REQUIRES_SUPER;

@end


@interface WKInterfaceSwitch ()

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL on;

@end


@implementation WKInterfaceSwitch



- (instancetype)init
{
    self = [super init];
    if (self) {
        // The `enabled` property of a switch in storyboard plist representation
        // only appears if the switch has been disabled.  Otherwise any switch
        // on an interface controller will be enabled.
        //
        self.enabled = YES;
        self.on = YES;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [super setEnabled:enabled];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    [super setOn:on];
}

@end
