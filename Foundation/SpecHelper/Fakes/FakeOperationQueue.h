#import <Foundation/Foundation.h>

@interface FakeOperationQueue : NSOperationQueue
- (void)reset;
- (void)runOperationAtIndex:(NSUInteger)index;
@end

