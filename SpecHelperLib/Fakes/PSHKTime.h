#import <Foundation/Foundation.h>

@interface PSHKTime : NSObject

+ (NSString *)notificationName;

+ (void)reset;
+ (void)advanceBy:(NSTimeInterval)timeInterval;
+ (NSTimeInterval)now;

@end
