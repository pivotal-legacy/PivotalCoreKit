#import "WKInterfaceSlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceSlider (Spec)

- (BOOL)enabled;
- (float)value;
- (float)minimum;
- (float)maximum;
- (NSInteger)numberOfSteps;
- (nullable UIImage *)minimumImage;
- (nullable UIImage *)maximumImage;
- (BOOL)continuous;

@end

NS_ASSUME_NONNULL_END
