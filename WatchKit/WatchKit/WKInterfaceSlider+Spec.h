#import "WKInterfaceSlider.h"


@interface WKInterfaceSlider (Spec)

- (BOOL)enabled;
- (float)value;
- (float)minimum;
- (float)maximum;
- (NSInteger)numberOfSteps;
- (UIImage *)minimumImage;
- (UIImage *)maximumImage;
- (BOOL)continuous;

@end
