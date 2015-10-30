#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceButton : WKInterfaceObject

- (void)setTitle:(nullable NSString *)title;
- (void)setAttributedTitle:(nullable NSAttributedString *)attributedTitle;

- (void)setColor:(nullable UIColor *)color;
- (void)setBackgroundImage:(nullable UIImage *)image;
- (void)setBackgroundImageData:(nullable NSData *)imageData;
- (void)setBackgroundImageNamed:(nullable NSString *)imageName;

- (void)setEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
