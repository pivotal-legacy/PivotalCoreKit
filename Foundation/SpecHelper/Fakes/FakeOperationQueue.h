#import <Foundation/Foundation.h>

@interface FakeOperationQueue : NSOperationQueue

- (void)reset;
- (void)runNextOperation;

@end

