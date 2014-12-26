#import "WKInterfaceObject.h"

@interface WKInterfaceDate : WKInterfaceObject

- (void)setTextColor:(UIColor *)color;

- (void)setTimeZone:(NSTimeZone *)timeZone;
- (void)setCalendar:(NSCalendar *)calendar;

@end
