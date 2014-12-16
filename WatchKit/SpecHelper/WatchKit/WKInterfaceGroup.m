#import "WKInterfaceGroup.h"


@interface WKInterfaceObject ()

- (void)setCornerRadius:(CGFloat)cornerRadius NS_REQUIRES_SUPER;

- (void)setBackgroundColor:(UIColor *)backgroundColor NS_REQUIRES_SUPER;
- (void)setBackgroundImage:(UIImage *)image NS_REQUIRES_SUPER;
- (void)setBackgroundImageData:(NSData *)imageData NS_REQUIRES_SUPER;
- (void)setBackgroundImageNamed:(NSString *)imageName NS_REQUIRES_SUPER;

- (void)startAnimating NS_REQUIRES_SUPER;
- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount NS_REQUIRES_SUPER;
- (void)stopAnimating NS_REQUIRES_SUPER;

@end

@interface WKInterfaceGroup ()

@property (nonatomic) NSArray *items;

@end


@implementation WKInterfaceGroup

#pragma mark - NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [super setCornerRadius:cornerRadius];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [super setBackgroundImage:image];
}

- (void)setBackgroundImageData:(NSData *)imageData
{
    [super setBackgroundImageData:imageData];
}

- (void)setBackgroundImageNamed:(NSString *)imageName
{
    [super setBackgroundImageNamed:imageName];
}

- (void)startAnimating
{
    [super startAnimating];
}

- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount
{
    [super startAnimatingWithImagesInRange:imageRange duration:duration repeatCount:repeatCount];
}

- (void)stopAnimating
{
    [super stopAnimating];
}

@end
