#import "PSHKFakeOperationQueue.h"

@interface PSHKFakeOperationQueue ()
@property (nonatomic, retain) NSMutableArray *mutableOperations;
@end

@implementation PSHKFakeOperationQueue

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
    if (self.runSynchronously) {
        [self performOperationAndWait:op];
    } else {
        [self.mutableOperations addObject:op];
    }
}

- (void)addOperations:(NSArray *)operations waitUntilFinished:(BOOL)wait {
    for (id operation in operations) {
        if (![operation isKindOfClass:[NSOperation class]]) {
            operation = [NSBlockOperation blockOperationWithBlock:[[operation copy] autorelease]];
        }
        
        if (wait || self.runSynchronously) {
            [self performOperationAndWait:operation];
        } else {
            [self.mutableOperations addObject:operation];
        }
    }
}

- (void)addOperationWithBlock:(void (^)(void))block {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:[[block copy] autorelease]];
    if (self.runSynchronously) {
        [self performOperationAndWait:blockOperation];
    } else {
        [self.mutableOperations addObject:blockOperation];
    }
}

- (NSArray *)operations {
    return self.mutableOperations;
}

- (NSUInteger)operationCount {
    return self.mutableOperations.count;
}

- (void)performOperationAndWait:(NSOperation *)op {
    [op start];
    [op waitUntilFinished];
}

- (void)runNextOperation {
    if (self.mutableOperations.count == 0) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Can't run an operation that doesn't exist" userInfo:nil] raise];
    }
    id operation = [self.mutableOperations objectAtIndex:0];
    if ([operation isKindOfClass:[NSOperation class]]) {
        [self performOperationAndWait:operation];
    } else {
        ((void (^)())operation)();
    }
    [self.mutableOperations removeObject:operation];
}

- (void)cancelAllOperations {
    for (NSOperation *op in self.mutableOperations) {
        [op cancel];
    }

    [self.mutableOperations removeAllObjects];
}

@end
