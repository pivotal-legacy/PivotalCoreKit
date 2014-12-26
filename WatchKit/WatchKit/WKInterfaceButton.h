#import "WKInterfaceObject.h"


@interface WKInterfaceButton : WKInterfaceObject

- (void)setTitle:(NSString *)title;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;

- (void)setColor:(UIColor *)color;
- (void)setBackgroundImage:(UIImage *)image;
- (void)setBackgroundImageData:(NSData *)imageData;
- (void)setBackgroundImageNamed:(NSString *)imageName;

- (void)setEnabled:(BOOL)enabled;

@end
