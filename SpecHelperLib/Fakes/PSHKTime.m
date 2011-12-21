#import "PSHKTime.h"

static NSTimeInterval timeSinceZero__;

@implementation PSHKTime

+ (void)initialize {
    [[self class] reset];
}

+ (NSString *)notificationName {
    return @"PSHKTimeHasElapsed";
}

+ (void)reset {
    timeSinceZero__ = 0;
}

+ (void)advanceBy:(NSTimeInterval)timeInterval {
    timeSinceZero__ += timeInterval;
    [(NSNotificationCenter *)[NSNotificationCenter defaultCenter] postNotificationName:[self notificationName] object:self];



}


+ (NSTimeInterval)now{

    return timeSinceZero__;
}


@end
