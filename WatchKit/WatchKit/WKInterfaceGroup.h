#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceGroup : WKInterfaceObject

- (void)setCornerRadius:(CGFloat)cornerRadius;

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor;
- (void)setBackgroundImage:(nullable UIImage *)image;
- (void)setBackgroundImageData:(nullable NSData *)imageData;
- (void)setBackgroundImageNamed:(nullable NSString *)imageName;

- (void)startAnimating;
- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
