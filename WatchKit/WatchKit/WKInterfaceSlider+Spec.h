#import "WKInterfaceSlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceSlider (Spec)

@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) float value;
@property (nonatomic, readonly) float minimum;
@property (nonatomic, readonly) float maximum;
@property (nonatomic, readonly) NSInteger numberOfSteps;
@property (nonatomic, readonly, nullable) UIImage *minimumImage;
@property (nonatomic, readonly, nullable) UIImage *maximumImage;
@property (nonatomic, readonly) BOOL continuous;

@end

NS_ASSUME_NONNULL_END
