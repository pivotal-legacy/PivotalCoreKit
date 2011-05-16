#import <Foundation/Foundation.h>

@interface NSObject (Mocking)

+ (void)stub:(SEL)selector andReturn:(id)returnValue;
//TODO
//+ (void)stub:(SEL)selector andDo:(id (^)(NSInvocation * invocation))executionBlock;
+ (void)resetAllStubbedMethods;

@end
