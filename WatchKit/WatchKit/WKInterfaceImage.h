#import "WKInterfaceObject.h"


@interface WKInterfaceImage : WKInterfaceObject

- (void)setImage:(UIImage *)image;
- (void)setImageData:(NSData *)imageData;
- (void)setImageNamed:(NSString *)imageName;

- (void)setTintColor:(UIColor *)tintColor;

- (void)startAnimating;

- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount;
- (void)stopAnimating;

@end
