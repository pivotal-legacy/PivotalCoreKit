#import <Foundation/Foundation.h>

@interface PSHKRunQueue : NSObject

- (void)addJobForObject:(id)object selector:(SEL)selector delay:(NSTimeInterval)delay;
- (void)cancelJobForObject:(id)aTarget selector:(SEL)aSelector;

@end
