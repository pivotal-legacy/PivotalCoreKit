#import "FakeOperationQueue.h"

@interface FakeOperationQueue ()
@property (nonatomic, retain) NSMutableArray *mutableOperations;
@end

@implementation FakeOperationQueue

- (id)init {
    if (self = [super init]) {
        self.suspended = YES;
        [self reset];
    }
    return self;
}

- (void)dealloc {
    self.mutableOperations = nil;
    [super dealloc];
}

- (void)reset {
    self.mutableOperations = [NSMutableArray array];
}

- (void)addOperation:(NSOperation *)op {
    [self.mutableOperations addObject:op];
}

- (void)addOperationWithBlock:(void (^)(void))block {
    [self.mutableOperations addObject:[[block copy] autorelease]];
}

- (NSArray *)operations {
    return self.mutableOperations;
}

- (NSUInteger)operationCount {
    return self.mutableOperations.count;
}

@end
