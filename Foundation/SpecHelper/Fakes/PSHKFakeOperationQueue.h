#import <Foundation/Foundation.h>

@interface PSHKFakeOperationQueue : NSOperationQueue

@property (nonatomic) BOOL runSynchronously;

- (void)reset;
- (void)runNextOperation;

@end
