#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#import "PivotalSpecHelperKit.h"
#import "PCKHTTPConnection.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(PCKHTTPConnectionSpec)

describe(@"PCKHTTPConnection", ^{
    __block PCKHTTPConnection *connection;
    __block id mockInterface;
    __block id mockRequest;
    __block FakeConnectionDelegate *delegate;

    __block NSAutoreleasePool *pool;

    beforeEach(^{
        pool = [[NSAutoreleasePool alloc] init];

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

        [pool drain];
    });

    describe(@"initialization", ^{
        it(@"should not have an unexpectedly high retainCount", ^{
            expect(connection.retainCount).to(equal(1));
        });

        it(@"should retain its delegate", ^{
            expect([delegate retainCount]).to(equal(2));
        });
    });

    describe(@"deallocation", ^{
        it(@"should release its delegate", ^{
            [connection release]; connection = nil;

            [pool drain]; pool = nil;
            expect([delegate retainCount]).to(equal(1));
        });
    });
});

SPEC_END
