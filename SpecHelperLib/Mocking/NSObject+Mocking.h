#import <Foundation/Foundation.h>

@interface NSObject (Mocking)

+ (void)stub:(SEL)selector andReturn:(id)returnValue;
+ (void)stub:(SEL)selector andDo:(id (^)(NSInvocation * invocation))substituteBlock;
+ (void)resetAllStubbedMethods;

@end
