#import "WKInterfaceTimer.h"


typedef NS_OPTIONS(NSUInteger, TimerFormatOptions) {
    TimerFormatOptionsYears = 1 << 2,
    TimerFormatOptionsMonths = 1 << 3,
    TimerFormatOptionsWeeks = 1 << 12,
    TimerFormatOptionsDays = 1 << 4,
    TimerFormatOptionsHours = 1 << 5,
    TimerFormatOptionsMinutes = 1 << 6,
    TimerFormatOptionsSeconds = 1 << 7,
};


@interface WKInterfaceTimer (Spec)

- (BOOL)enabled;

- (NSUInteger)units;

@end
