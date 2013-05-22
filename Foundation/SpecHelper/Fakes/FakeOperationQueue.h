#import <Foundation/Foundation.h>

@interface FakeOperationQueue : NSOperationQueue

@property (nonatomic) BOOL runSynchronously;

- (void)reset;
- (void)runNextOperation;

@end

