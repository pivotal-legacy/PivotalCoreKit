#import <Foundation/Foundation.h>


@protocol TestableWKInterfaceSlider <NSObject>

@optional

- (void)setEnabled:(BOOL)enabled;
- (void)setValue:(float)value;
- (void)setColor:(UIColor *)color;
- (void)setNumberOfSteps:(NSInteger)numberOfSteps;

- (BOOL)enabled;
- (float)value;
- (float)minimum;
- (float)maximum;
- (NSInteger)numberOfSteps;
- (UIImage *)minimumImage;
- (UIImage *)maximumImage;
- (BOOL)continuous;
@end
