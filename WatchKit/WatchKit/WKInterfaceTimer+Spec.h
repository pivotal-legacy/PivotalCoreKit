#import "WKInterfaceTimer.h"


typedef NS_OPTIONS(NSUInteger, PCKTimerFormatOptions) {
    PCKTimerFormatOptionsYears = 1 << 2,
    PCKTimerFormatOptionsMonths = 1 << 3,
    PCKTimerFormatOptionsWeeks = 1 << 12,
    PCKTimerFormatOptionsDays = 1 << 4,
    PCKTimerFormatOptionsHours = 1 << 5,
    PCKTimerFormatOptionsMinutes = 1 << 6,
    PCKTimerFormatOptionsSeconds = 1 << 7,
};


@interface WKInterfaceTimer (Spec)

- (BOOL)enabled;

- (NSUInteger)units;

@end
