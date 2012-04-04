#import "FakeOperationQueue.h"

@interface FakeOperationQueue ()
@property (nonatomic, retain) NSMutableArray *mutableOperations;
@end

@implementation FakeOperationQueue
@synthesize mutableOperations = mutableOperations_;

- (id)init {
    if (self = [super init]) {
        self.suspended = YES;
        [self reset];
    }
    return self;
}

- (void)reset {
    self.mutableOperations = [NSMutableArray array];
}

- (void)addOperation:(NSOperation *)op {
    [self.mutableOperations addObject:op];
}

- (NSArray *)operations {
    return self.mutableOperations;
}

- (NSUInteger)operationCount {
    return self.mutableOperations.count;
}

@end
