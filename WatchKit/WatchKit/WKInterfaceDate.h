#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceDate : WKInterfaceObject

- (void)setTextColor:(nullable UIColor *)color;

- (void)setTimeZone:(nullable NSTimeZone *)timeZone;
- (void)setCalendar:(nullable NSCalendar *)calendar;

@end

NS_ASSUME_NONNULL_END
