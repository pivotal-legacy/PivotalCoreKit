#import "MessageCapturer.h"


@interface WKInterfaceObject : MessageCapturer

- (void)setHidden:(BOOL)hidden;
- (void)setAlpha:(CGFloat)alpha;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@end
