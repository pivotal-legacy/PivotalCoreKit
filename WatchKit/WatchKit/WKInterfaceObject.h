#import "PCKMessageCapturer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceObject : PCKMessageCapturer

- (void)setHidden:(BOOL)hidden;
- (void)setAlpha:(CGFloat)alpha;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
