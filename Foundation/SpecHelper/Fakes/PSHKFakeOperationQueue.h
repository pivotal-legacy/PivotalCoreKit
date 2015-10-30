#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSHKFakeOperationQueue : NSOperationQueue

@property (nonatomic) BOOL runSynchronously;

- (void)reset;
- (void)runNextOperation;

@end

NS_ASSUME_NONNULL_END
