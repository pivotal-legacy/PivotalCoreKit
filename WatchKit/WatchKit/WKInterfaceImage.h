#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceImage : WKInterfaceObject

- (void)setImage:(nullable UIImage *)image;
- (void)setImageData:(nullable NSData *)imageData;
- (void)setImageNamed:(nullable NSString *)imageName;

- (void)setTintColor:(nullable UIColor *)tintColor;

- (void)startAnimating;

- (void)startAnimatingWithImagesInRange:(NSRange)imageRange
                               duration:(NSTimeInterval)duration
                            repeatCount:(NSInteger)repeatCount;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
