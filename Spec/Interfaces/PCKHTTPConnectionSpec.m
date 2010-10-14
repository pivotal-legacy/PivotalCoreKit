#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "PivotalSpecHelperKit.h"
#import "PCKHTTPConnection.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"

SPEC_BEGIN(PCKHTTPConnectionSpec)

describe(@"PCKHTTPConnection", ^{
    __block PCKHTTPConnection *connection;
    __block id mockInterface;
    __block id mockRequest;
    __block FakeConnectionDelegate *delegate;

    beforeEach(^{
        mockInterface = [OCMockObject niceMockForClass:[PCKHTTPInterface class]];
        mockRequest = [OCMockObject niceMockForClass:[NSURLRequest class]];
        delegate = [[FakeConnectionDelegate alloc] init];
        connection = [[PCKHTTPConnection alloc] initWithHTTPInterface:mockInterface forRequest:mockRequest andDelegate:delegate];

        // We're testing the retainCounts for connection objects here, so remove
        // the connection we create from the containers that we've created for
        // testing.
        [NSURLConnection resetAll];
    });

    afterEach(^{
        [connection release];
        [delegate release];
    });

    describe(@"initialization", ^{
        it(@"should not have an unexpectedly high retainCount", ^{
            assertThatInt([connection retainCount], equalToInt(1));
        });

        it(@"should retain its delegate", ^{
            assertThatInt([delegate retainCount], equalToInt(2));
        });
    });

    describe(@"deallocation", ^{
        it(@"should release its delegate", ^{
            [connection release]; connection = nil;
            assertThatInt([delegate retainCount], equalToInt(1));
        });
    });

    describe(@"respondsToSelector:", ^{
        it(@"should return true for selectors the delegate responds to", ^{
            SEL selector = @selector(connection:needNewBodyStream:);

            assertThatBool([delegate respondsToSelector:selector], equalToBool(true));
            assertThatBool([connection respondsToSelector:selector], equalToBool(true));
        });

        it(@"should return false for selectors the delegate does not respond to", ^{
            SEL selector = @selector(connection:canAuthenticateAgainstProtectionSpace:);

            assertThatBool([delegate respondsToSelector:selector], equalToBool(false));
            assertThatBool([connection respondsToSelector:selector], equalToBool(false));
        });
    });

    describe(@"forwardInvocation:", ^{
        it(@"should forward any selector the delegate responds to to the delegate", ^{
            SEL selector = @selector(connection:needNewBodyStream:);

            assertThatBool([delegate respondsToSelector:selector], equalToBool(true));
            id mockDelegate = [OCMockObject partialMockForObject:delegate];
            [[mockDelegate expect] connection:connection needNewBodyStream:nil];
            [connection connection:connection needNewBodyStream:nil];
            [mockDelegate verify];
        });
    });
});

SPEC_END
