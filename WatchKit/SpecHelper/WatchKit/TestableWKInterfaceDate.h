#import <Foundation/Foundation.h>

@protocol TestableWKInterfaceDate <NSObject>

- (void)setTextColor:(UIColor *)color;

- (void)setTimeZone:(NSTimeZone *)timeZone;
- (void)setCalendar:(NSCalendar *)calendar;

- (void)setFormat:(NSString *)format;

@optional

- (NSString *)textColor;
- (NSString *)format;

@end
