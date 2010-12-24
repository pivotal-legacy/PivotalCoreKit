#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <OCMock/OCMock.h>

#import "PivotalSpecHelperKit.h"
#import "PCKHTTPConnectionOperation.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"

SPEC_BEGIN(PCKHTTPConnectionOperationSpec)

describe(@"PCKHTTPConnectionOperation", ^{
    __block PCKHTTPConnectionOperation *operation;
    __block id mockInterface;
    __block id mockRequest;
    __block id delegate;

    beforeEach(^{
        mockInterface = [OCMockObject niceMockForClass:[PCKHTTPInterface class]];
        mockRequest = [OCMockObject niceMockForClass:[NSURLRequest class]];
        delegate = [[[FakeConnectionDelegate alloc] init] autorelease];
        operation = [[PCKHTTPConnectionOperation alloc] initWithHTTPInterface:mockInterface forRequest:mockRequest andDelegate:delegate];
    });

    afterEach(^{
        [operation release];
    });

    describe(@"initialization", ^{
        it(@"should not have an unexpectedly high retainCount", ^{
            assertThatInt([operation retainCount], equalToInt(1));
        });

        it(@"should retain its delegate", ^{
            assertThatInt([delegate retainCount], equalToInt(2));
        });

        it(@"should not create a connection", ^{
            assertThat([[NSURLConnection connections] lastObject], nilValue());
        });

        it(@"should not be executing", ^{
            assertThatBool(operation.isExecuting, equalToBool(NO));
        });

        it(@"should not be finished", ^{
            assertThatBool(operation.isFinished, equalToBool(NO));
        });
    });

    describe(@"deallocation", ^{
        it(@"should release its delegate", ^{
            [operation release]; operation = nil;
            assertThatInt([delegate retainCount], equalToInt(1));
        });
    });

    describe(@"respondsToSelector:", ^{
        it(@"should return true for selectors NSOperation responds to", ^{
            assertThatBool([operation respondsToSelector:@selector(start)], equalToBool(YES));
        });

        it(@"should return true for selectors the delegate responds to", ^{
            SEL selector = @selector(connection:needNewBodyStream:);

            assertThatBool([delegate respondsToSelector:selector], equalToBool(true));
            assertThatBool([operation respondsToSelector:selector], equalToBool(true));
        });

        it(@"should return false for selectors the delegate does not respond to", ^{
            SEL selector = @selector(connection:canAuthenticateAgainstProtectionSpace:);

            assertThatBool([delegate respondsToSelector:selector], equalToBool(false));
            assertThatBool([operation respondsToSelector:selector], equalToBool(false));
        });
    });

    describe(@"forwardInvocation:", ^{
        it(@"should forward any selector the delegate responds to to the delegate", ^{
            SEL selector = @selector(connection:needNewBodyStream:);

            assertThatBool([delegate respondsToSelector:selector], equalToBool(true));
            id mockDelegate = [OCMockObject partialMockForObject:delegate];
            [[mockDelegate expect] connection:nil needNewBodyStream:nil];
            [operation connection:nil needNewBodyStream:nil];
            [mockDelegate verify];
        });
    });

    describe(@"start", ^{
        __block NSURLConnection *connection;

        beforeEach(^{
            assertThatInt([NSURLConnection connections].count, equalToInt(0));
            [operation start];
            connection = [[NSURLConnection connections] lastObject];
        });

        it(@"should create a connection", ^{
            assertThat(connection, notNilValue());
        });

        it(@"should be executing", ^{
            assertThatBool(operation.isExecuting, equalToBool(YES));
        });

        it(@"should not be finished", ^{
            assertThatBool(operation.isFinished, equalToBool(NO));
        });

        describe(@"on connection success", ^{
            __block PSHKFakeHTTPURLResponse *response;

            beforeEach(^{
                response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] success];
            });

            it(@"should forward connection events to the delegate", ^{
                id mockDelegate = [OCMockObject partialMockForObject:delegate];
                [[mockDelegate expect] connection:connection didReceiveResponse:[OCMArg any]];
                [[mockDelegate expect] connection:connection didReceiveData:[[response body] dataUsingEncoding:NSUTF8StringEncoding]];

                assertThatBool([delegate respondsToSelector:@selector(connection:didReceiveResponse:)], equalToBool(YES));

                [connection receiveResponse:response];

                [mockDelegate verify];
            });

            it(@"should complete the connection", ^{
                id mockDelegate = [OCMockObject partialMockForObject:delegate];
                [[mockDelegate expect] connectionDidFinishLoading:connection];

                [connection receiveResponse:response];

                [mockDelegate verify];
            });

            it(@"should not be executing", ^{
                [connection receiveResponse:response];
                assertThatBool(operation.isExecuting, equalToBool(NO));
            });

            it(@"should be finished", ^{
                [connection receiveResponse:response];
                assertThatBool(operation.isFinished, equalToBool(YES));
            });
        });

        describe(@"on connection failure", ^{
            __block NSError *error;

            beforeEach(^{
                error = [NSError errorWithDomain:@"domain" code:7 userInfo:nil];
            });

            it(@"should forward the failure event to the delegate", ^{
                id mockDelegate = [OCMockObject partialMockForObject:delegate];
                [[mockDelegate expect] connection:connection didFailWithError:error];

                [connection failWithError:error];

                [mockDelegate verify];
            });

            it(@"should not be executing", ^{
                [connection failWithError:error];
                assertThatBool(operation.isExecuting, equalToBool(NO));
            });

            it(@"should be finished", ^{
                [connection failWithError:error];
                assertThatBool(operation.isFinished, equalToBool(YES));
            });
        });
    });

    describe(@"cancel", ^{
        describe(@"when it has started", ^{
            beforeEach(^{
                [operation start];
                [operation cancel];
            });

            it(@"should cancel the connection", ^{
                assertThatInt([NSURLConnection connections].count, equalToInt(0));
            });

            it(@"should not be executing", ^{
                assertThatBool(operation.isExecuting, equalToBool(NO));
            });

            it(@"should be finished", ^{
                assertThatBool(operation.isFinished, equalToBool(YES));
            });
        });

        describe(@"when it has not started", ^{
            beforeEach(^{
                [operation cancel];
            });

            it(@"should not be executing", ^{
                assertThatBool(operation.isExecuting, equalToBool(NO));
            });

            it(@"should be finished", ^{
                assertThatBool(operation.isFinished, equalToBool(YES));
            });
        });
    });
});

SPEC_END
