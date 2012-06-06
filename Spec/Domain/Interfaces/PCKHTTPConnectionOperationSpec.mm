#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#import "PivotalSpecHelperKit.h"
#import "PCKHTTPConnectionOperation.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"

SPEC_BEGIN(PCKHTTPConnectionOperationSpec)

using namespace Cedar::Matchers;

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
            expect(operation.retainCount).to(equal(1));
        });

        it(@"should retain its delegate", ^{
            expect([delegate retainCount]).to(equal(2));
        });

        it(@"should not create a connection", ^{
            expect([NSURLConnection connections]).to(be_empty());
        });

        it(@"should not be executing", ^{
            expect(operation.isExecuting).to_not(be_truthy());
        });

        it(@"should not be finished", ^{
            expect(operation.isFinished).to_not(be_truthy());
        });
    });

    describe(@"deallocation", ^{
        it(@"should release its delegate", ^{
            [operation release]; operation = nil;
            expect([delegate retainCount]).to(equal(1));
        });
    });

    describe(@"respondsToSelector:", ^{
        it(@"should return true for selectors NSOperation responds to", ^{
            expect([operation respondsToSelector:@selector(start)]).to(be_truthy());
        });

        it(@"should return true for selectors the delegate responds to", ^{
            SEL selector = @selector(connection:needNewBodyStream:);

            expect([delegate respondsToSelector:selector]).to(be_truthy());
            expect([operation respondsToSelector:selector]).to(be_truthy());
        });

        it(@"should return false for selectors the delegate does not respond to", ^{
            SEL selector = @selector(connection:canAuthenticateAgainstProtectionSpace:);

            expect([delegate respondsToSelector:selector]).to_not(be_truthy());
            expect([operation respondsToSelector:selector]).to_not(be_truthy());
        });
    });

    describe(@"forwardInvocation:", ^{
        it(@"should forward any selector the delegate responds to to the delegate", ^{
            SEL selector = @selector(connection:needNewBodyStream:);
            expect([delegate respondsToSelector:selector]).to(be_truthy());
            
            id mockDelegate = [OCMockObject partialMockForObject:delegate];
            [[mockDelegate expect] connection:nil needNewBodyStream:nil];
            [operation connection:nil needNewBodyStream:nil];
            [mockDelegate verify];
        });
    });

    describe(@"start", ^{
        __block NSURLConnection *connection;

        beforeEach(^{
            expect([NSURLConnection connections]).to(be_empty());
            
            [operation start];
            connection = [[NSURLConnection connections] lastObject];
        });

        it(@"should create a connection", ^{
            expect(connection).to_not(be_nil());
        });

        it(@"should be executing", ^{
            expect(operation.isExecuting).to(be_truthy());
        });

        it(@"should not be finished", ^{
            expect(operation.isFinished).to_not(be_truthy());
        });

        describe(@"on connection success", ^{
            __block PSHKFakeHTTPURLResponse *response;

            beforeEach(^{
                response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] success];
            });

            it(@"should forward connection events to the delegate", ^{
                id mockDelegate = [OCMockObject partialMockForObject:delegate];
                [[mockDelegate expect] connection:connection didReceiveResponse:[OCMArg any]];
                [[mockDelegate expect] connection:connection didReceiveData:[response bodyData]];

                expect([delegate respondsToSelector:@selector(connection:didReceiveResponse:)]).to(be_truthy());

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
                expect(operation.isExecuting).to_not(be_truthy());
            });

            it(@"should be finished", ^{
                [connection receiveResponse:response];
                expect(operation.isFinished).to(be_truthy());
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
                expect(operation.isExecuting).to_not(be_truthy());
            });

            it(@"should be finished", ^{
                [connection failWithError:error];
                expect(operation.isFinished).to(be_truthy());
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
                expect([NSURLConnection connections]).to(be_empty());
            });

            it(@"should not be executing", ^{
                expect(operation.isExecuting).to_not(be_truthy());
            });

            it(@"should be finished", ^{
                expect(operation.isFinished).to(be_truthy());
            });
        });

        describe(@"when it has not started", ^{
            beforeEach(^{
                [operation cancel];
            });

            it(@"should not be executing", ^{
                expect(operation.isExecuting).to_not(be_truthy());
            });

            it(@"should be finished", ^{
                expect(operation.isFinished).to(be_truthy());
            });
        });
    });
});

SPEC_END
