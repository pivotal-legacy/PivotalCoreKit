#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceSlider : WKInterfaceObject

- (void)setEnabled:(BOOL)enabled;
- (void)setValue:(float)value;
- (void)setColor:(nullable UIColor *)color;
- (void)setNumberOfSteps:(NSInteger)numberOfSteps;

@end

NS_ASSUME_NONNULL_END
