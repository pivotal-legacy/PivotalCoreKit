 #import "WKInterfaceTimer.h"


@interface WKInterfaceObject ()

- (void)setTextColor:(UIColor *)color NS_REQUIRES_SUPER;

- (void)setDate:(NSDate *)date NS_REQUIRES_SUPER;;
- (void)start NS_REQUIRES_SUPER;
- (void)stop NS_REQUIRES_SUPER;

@end


@interface WKInterfaceTimer ()

@property (nonatomic) NSUInteger formatUnits;
@property (nonatomic) BOOL enabled;

@end


@implementation WKInterfaceTimer

- (void)setUnits:(NSNumber *)units
{
    _formatUnits = [units unsignedIntegerValue];
}

- (NSUInteger)units
{
    return _formatUnits;
}

- (void)setTextColor:(UIColor *)color
{
    [super setTextColor:color];
}

- (void)setDate:(NSDate *)date
{
    [super setDate:date];
}

- (void)start
{
    [super start];
}

- (void)stop
{
    [super stop];
}

@end
