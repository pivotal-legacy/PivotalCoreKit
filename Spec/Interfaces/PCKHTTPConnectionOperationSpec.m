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
        beforeEach(^{
            [operation start];
        });

        it(@"should create a connection", ^{
            NSURLConnection *connection = [[NSURLConnection connections] lastObject];
            assertThat(connection, notNilValue());
        });

        it(@"should be executing", PENDING);
        it(@"should not be finished", PENDING);

        describe(@"on connection response", ^{
            it(@"should forward connection events to the delegate", PENDING);
            it(@"should complete the connection", PENDING);
            it(@"should not be executing", PENDING);
            it(@"should be finished", PENDING);
        });

        describe(@"on connection failure", ^{
            it(@"should forward the failure event to the delegate", PENDING);
            it(@"should complete the connection", PENDING);
            it(@"should not be executing", PENDING);
            it(@"should be finished", PENDING);
        });
    });

    describe(@"cancel", ^{
        it(@"should cancel the connection", PENDING);
        it(@"should not be executing", PENDING);
        it(@"should be finished", PENDING);
    });
});

SPEC_END
