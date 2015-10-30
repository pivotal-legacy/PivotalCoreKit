#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PSHKFakeOperationQueue.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PSHKFakeOperationQueueSpec)

describe(@"PSHKFakeOperationQueue", ^{
    __block PSHKFakeOperationQueue *fakeQueue;

    beforeEach(^{
        fakeQueue = [[PSHKFakeOperationQueue alloc] init];
    });

    describe(@"when an operation is added", ^{
        __block NSOperation *operation;
        beforeEach(^{
            operation = [[NSOperation alloc] init];
            [fakeQueue addOperation:operation];
        });

        it(@"should have the operation", ^{
            fakeQueue.operationCount should equal(1);
            [fakeQueue.operations lastObject] should be_same_instance_as(operation);
        });
    });

    describe(@"when an operation is added using the block literal helper", ^{
        beforeEach(^{
            [fakeQueue addOperationWithBlock:^{
                NSLog(@"================> %@", @"Hi Mom!");
            }];
        });

        it(@"should have a block operation", ^{
            [fakeQueue.operations lastObject] should be_instance_of([NSBlockOperation class]);
        });
    });

    describe(@"when set to run synchronously", ^{
        __block BOOL blockInvoked;
        __block dispatch_semaphore_t semaphore;
        __block NSBlockOperation *blockOperation;

        beforeEach(^{
            fakeQueue.runSynchronously = YES;

            semaphore = dispatch_semaphore_create(0);
            blockInvoked = NO;

            blockOperation = [NSBlockOperation blockOperationWithBlock:^{
                blockInvoked = YES;
                dispatch_semaphore_signal(semaphore);
            }];
        });

        it(@"should run an operation immediately when added", ^{
            [fakeQueue addOperation:blockOperation];
            dispatch_semaphore_wait(semaphore, 0.0001);

            blockInvoked should be_truthy;
        });

        it(@"should run all operations immediately when several are added", ^{
            [fakeQueue addOperations:@[blockOperation] waitUntilFinished:NO];
            dispatch_semaphore_wait(semaphore, 0.0001);

            blockInvoked should be_truthy;
        });
    });

    describe(@"when an array of operations are added", ^{
        __block NSArray *operations;
        __block NSString *message;
        beforeEach(^{
            operations = @[[[NSOperation alloc] init],[^{ message = @"Hi Mom"; } copy]];
        });

        context(@"when told not to waitUntilFinished", ^{
            beforeEach(^{
                [fakeQueue addOperations:operations waitUntilFinished:NO];
            });

            it(@"should have the operations and not raise an exception", ^{
                fakeQueue.operations.count should equal(2);
            });
        });

        context(@"when told to waitUntilFinished", ^{
            beforeEach(^{
                [fakeQueue addOperations:operations waitUntilFinished:YES];
            });

            it(@"should run the operations synchronously", ^{
                message should equal(@"Hi Mom");
            });

            it(@"should not have any operations when finished", ^{
                fakeQueue.operations should be_empty;
            });
        });
    });

    describe(@"-runNextOperation", ^{
        context(@"when there are operations to be run", ^{
            __block NSString *message = nil;
            beforeEach(^{
                [fakeQueue addOperationWithBlock:^{
                    message = @"Hi Mom";
                }];

                [fakeQueue addOperationWithBlock:^{
                    message = @"Hi Dad";
                }];
            });

            it(@"should run the next operation and remove it from the queue", ^{
                [fakeQueue runNextOperation];
                message should equal(@"Hi Mom");
                fakeQueue.operationCount should equal(1);

                [fakeQueue runNextOperation];
                message should equal(@"Hi Dad");
                fakeQueue.operationCount should equal(0);
            });
        });

        context(@"when the queue is empty", ^{
            beforeEach(^{
                fakeQueue.operationCount should equal(0);
            });

            it(@"should raise an exception", ^{
                ^{ [fakeQueue runNextOperation]; } should raise_exception;
            });
        });
    });

    describe(@"-cancelAllOperations", ^{
        __block NSOperation *operation;

        beforeEach(^{
            operation = [[NSOperation alloc] init];
            [fakeQueue addOperation:operation];

            [fakeQueue cancelAllOperations];
        });

        it(@"should cancel each operation", ^{
            operation.cancelled should be_truthy;
        });

        it(@"should no longer have any queued operations", ^{
            fakeQueue.operationCount should equal(0);
        });
    });
});

SPEC_END
