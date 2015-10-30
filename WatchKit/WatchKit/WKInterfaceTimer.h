#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceTimer : WKInterfaceObject

- (void)setTextColor:(nullable UIColor *)color;

- (void)setDate:(NSDate *)date;
- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
