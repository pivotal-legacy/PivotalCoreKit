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

- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait {
    for (id op in ops) {
        if ([op isKindOfClass:[NSOperation class]]) {
            [self.mutableOperations addObject:op];
        } else {
            [self.mutableOperations addObject:[NSBlockOperation blockOperationWithBlock:op]];
        }
    }
    if (wait) {
        for (NSOperation *op in self.mutableOperations) {
            [self executeOperationAndWait:op];
        }
        [self.mutableOperations removeAllObjects];
    }
}

- (void)addOperationWithBlock:(void (^)(void))block {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:[[block copy] autorelease]];
    [self.mutableOperations addObject:blockOperation];
}

- (NSArray *)operations {
    return self.mutableOperations;
}

- (NSUInteger)operationCount {
    return self.mutableOperations.count;
}

- (void)executeOperationAndWait:(NSOperation *)op {
    [op start];
    [op waitUntilFinished];
}

- (void)runOperationAtIndex:(NSUInteger)index {
    id op = [self.mutableOperations objectAtIndex:index];
    if ([op isKindOfClass:[NSOperation class]]) {
        [self executeOperationAndWait:op];
    } else {
        ((void (^)())op)();
    }
}

@end
