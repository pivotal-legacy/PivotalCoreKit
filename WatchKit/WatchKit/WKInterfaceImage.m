#import "WKInterfaceImage.h"


@interface WKInterfaceObject ()

- (void)setImage:(UIImage *)image NS_REQUIRES_SUPER;
- (void)setImageData:(NSData *)imageData NS_REQUIRES_SUPER;
- (void)setImageNamed:(NSString *)imageName NS_REQUIRES_SUPER;

- (void)setTintColor:(UIColor *)tintColor NS_REQUIRES_SUPER;

- (void)startAnimating NS_REQUIRES_SUPER;
- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount NS_REQUIRES_SUPER;
- (void)stopAnimating NS_REQUIRES_SUPER;

@end

@interface WKInterfaceImage ()

@property (nonatomic) UIImage *image;

@end


@implementation WKInterfaceImage

-(void)setImage:(id)image
{
    _image = [image isKindOfClass:[UIImage class]] ? image : [UIImage imageNamed:image];
    [super setImage:image];
}


- (void)setImageData:(NSData *)imageData
{
    [super setImageData:imageData];
}

- (void)setImageNamed:(NSString *)imageName
{
    [super setImageNamed:imageName];
}

- (void)startAnimating
{
    [super startAnimating];
}

- (void)startAnimatingWithImagesInRange:(NSRange)imageRange duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount
{
    [super startAnimatingWithImagesInRange:imageRange duration:duration repeatCount:repeatCount];
}

- (void)stopAnimating
{
    [super stopAnimating];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
}

@end
