#import "WKInterfaceObject.h"


@interface WKInterfaceButton : WKInterfaceObject

- (void)setTitle:(NSString *)title;
- (void)setColor:(UIColor *)color;
- (void)setEnabled:(BOOL)enabled;

@end
