#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "FakeOperationQueue.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FakeOperationQueueSpec)

describe(@"FakeOperationQueue", ^{
    __block FakeOperationQueue *fakeQueue;

    beforeEach(^{
        fakeQueue = [[[FakeOperationQueue alloc] init] autorelease];
    });

    describe(@"when an operation is added", ^{
        __block NSOperation *operation;
        beforeEach(^{
            operation = [[[NSOperation alloc] init] autorelease];
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

    describe(@"when an array of operations are added", ^{
        __block NSArray *operations;
        __block NSString *message;
        beforeEach(^{
            operations = @[[[[NSOperation alloc] init] autorelease],[[^{ message = @"Hi Mom"; } copy] autorelease]];
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
});

SPEC_END
