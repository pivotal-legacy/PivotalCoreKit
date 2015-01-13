#import "WKInterfaceSlider.h"


@interface WKInterfaceObject ()

- (void)setEnabled:(BOOL)enabled NS_REQUIRES_SUPER;
- (void)setValue:(float)value NS_REQUIRES_SUPER;
- (void)setColor:(UIColor *)color NS_REQUIRES_SUPER;
- (void)setNumberOfSteps:(NSInteger)numberOfSteps NS_REQUIRES_SUPER;

@end


@interface WKInterfaceSlider ()

@property (nonatomic) BOOL enabled;
@property (nonatomic) float value;
@property (nonatomic) float minimum;
@property (nonatomic) float maximum;
@property (nonatomic) UIImage *minimumImage;
@property (nonatomic) UIImage *maximumImage;
@property (nonatomic) NSInteger steps;
@property (nonatomic) BOOL continuous;

@end


@implementation WKInterfaceSlider

- (instancetype)init
{
    self = [super init];
    if (self) {
        // The `enabled` property of a slider in storyboard plist representation
        // only appears if the slider has been disabled.  Otherwise any slider
        // on an interface controller will be enabled.
        //
        self.enabled = YES;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [super setEnabled:enabled];
}

- (void)setValue:(float)value
{
    _value = value;
    [super setValue:value];
}

- (void)setNumberOfSteps:(NSInteger)numberOfSteps
{
    _steps = numberOfSteps;
    [super setNumberOfSteps:_steps];
}

- (NSInteger)numberOfSteps
{
    return _steps;
}

- (void)setMinimumImage:(NSString *)minimumImage
{
    _minimumImage = [UIImage imageNamed:minimumImage];
}

- (void)setMaximumImage:(NSString *)maximumImage
{
    _maximumImage = [UIImage imageNamed:maximumImage];
}

- (void)setColor:(UIColor *)color
{
    [super setColor:color];
}

@end
