#import "WKInterfaceObject.h"


@interface WKInterfaceSlider : WKInterfaceObject

- (void)setEnabled:(BOOL)enabled;
- (void)setValue:(float)value;
- (void)setColor:(UIColor *)color;
- (void)setNumberOfSteps:(NSInteger)numberOfSteps;

@end
