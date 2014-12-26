#import "WKInterfaceObject.h"


@interface WKInterfaceGroup : WKInterfaceObject

- (void)setCornerRadius:(CGFloat)cornerRadius;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)setBackgroundImage:(UIImage *)image;
- (void)setBackgroundImageData:(NSData *)imageData;
- (void)setBackgroundImageNamed:(NSString *)imageName;

- (void)startAnimating;
- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount;
- (void)stopAnimating;

@end
