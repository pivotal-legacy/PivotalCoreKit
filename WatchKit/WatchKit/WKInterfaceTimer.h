#import "WKInterfaceObject.h"


@interface WKInterfaceTimer : WKInterfaceObject

- (void)setTextColor:(UIColor *)color;

- (void)setDate:(NSDate *)date;
- (void)start;
- (void)stop;

@end
