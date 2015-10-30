#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#import "Foundation+PivotalSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#import <Foundation+PivotalSpecHelper/Foundation+PivotalSpecHelper.h>
#endif

#import "PCKHTTPConnectionOperation.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"
#import "PSHKObserver.h"
#import "PSHKWeakObjectWrapper.h"

SPEC_BEGIN(PCKHTTPConnectionOperationSpec)

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

describe(@"PCKHTTPConnectionOperation", ^{
    __block PCKHTTPConnectionOperation *operation;
    __block FakeConnectionDelegate *delegate;

    beforeEach(^{
        PCKHTTPInterface<CedarDouble> *interface = nice_fake_for([PCKHTTPInterface class]);
        NSURLRequest<CedarDouble> *request = fake_for([NSURLRequest class]);
        delegate = [[FakeConnectionDelegate alloc] init];
        operation = [[PCKHTTPConnectionOperation alloc] initWithHTTPInterface:interface forRequest:request andDelegate:delegate];
    });

    afterEach(^{
        operation = nil;
    });

    describe(@"initialization", ^{
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
            PSHKWeakObjectWrapper *wrapper = [[PSHKWeakObjectWrapper alloc] init];
            @autoreleasepool {
                PCKHTTPInterface<CedarDouble> *interface = nice_fake_for([PCKHTTPInterface class]);
                NSURLRequest<CedarDouble> *request = fake_for([NSURLRequest class]);
                FakeConnectionDelegate *aDelegate = [[FakeConnectionDelegate alloc] init];;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
                PCKHTTPConnectionOperation *anOperation = [[PCKHTTPConnectionOperation alloc] initWithHTTPInterface:interface forRequest:request andDelegate:delegate];
#pragma clang diagnostic pop
                wrapper.target = aDelegate;
            }
            wrapper.target should be_nil;
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
            NSURLConnection *connection = fake_for([NSURLConnection class]);
            NSURLRequest *request = fake_for([NSURLRequest class]);

            expect([delegate respondsToSelector:@selector(connection:needNewBodyStream:)]).to(be_truthy());

            spy_on(delegate);
            [operation connection:connection needNewBodyStream:request];

            delegate should have_received("connection:needNewBodyStream:").with(connection).and_with(request);
        });
    });

    describe(@"start", ^{
        __block NSURLConnection *connection;
        __block PSHKObserver *isExecutingObserver;

        beforeEach(^{
            isExecutingObserver = [PSHKObserver observerForObject:operation keyPath:@"isExecuting"];

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

        it(@"should notify a key value observer that it is executing", ^{
            expect(isExecutingObserver.mostRecentValue).to(equal(@YES));
        });

        it(@"should not be finished", ^{
            expect(operation.isFinished).to_not(be_truthy());
        });

        describe(@"on connection success", ^{
            __block PSHKFakeHTTPURLResponse *response;
            __block PSHKObserver *isFinishedObserver;

            beforeEach(^{
                isFinishedObserver = [PSHKObserver observerForObject:operation keyPath:@"isFinished"];
                spy_on(delegate);

                response = [[PSHKFakeResponses responsesForRequest:@"HelloWorld"] success];
                [connection receiveResponse:response];
            });

            it(@"should forward connection events to the delegate", ^{
                delegate should have_received("connection:didReceiveResponse:").with(connection).and_with(response);
                delegate should have_received("connection:didReceiveData:").with(connection).and_with(response.bodyData);
            });

            it(@"should complete the connection", ^{
                delegate should have_received("connectionDidFinishLoading:").with(connection);
            });

            it(@"should not be executing", ^{
                expect(operation.isExecuting).to_not(be_truthy());
            });

            it(@"should notify observers that it is no longer executing", ^{
                expect(isExecutingObserver.mostRecentValue).to(equal(@NO));
            });

            it(@"should be finished", ^{
                expect(operation.isFinished).to(be_truthy());
            });

            it(@"should notify observers when finished", ^{
                expect(isFinishedObserver.mostRecentValue).to(equal(@YES));
            });
        });

        describe(@"on connection failure", ^{
            __block NSError *error;

            beforeEach(^{
                spy_on(delegate);

                error = [NSError errorWithDomain:@"domain" code:7 userInfo:nil];
                [connection failWithError:error];
            });

            it(@"should forward the failure event to the delegate", ^{
                delegate should have_received("connection:didFailWithError:").with(connection).and_with(error);
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
