#import "WKInterfaceSlider.h"


@interface WKInterfaceSlider (Spec)

@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) float value;
@property (nonatomic, readonly) float minimum;
@property (nonatomic, readonly) float maximum;
@property (nonatomic, readonly) NSInteger numberOfSteps;
@property (nonatomic, readonly) UIImage *minimumImage;
@property (nonatomic, readonly) UIImage *maximumImage;
@property (nonatomic, readonly) BOOL continuous;

@end
