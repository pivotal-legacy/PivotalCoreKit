#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#import "Foundation+PivotalSpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#import <Foundation+PivotalSpecHelper/Foundation+PivotalSpecHelper.h>
#endif

#import "PCKHTTPConnection.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKHTTPConnectionSpec)

describe(@"PCKHTTPConnection", ^{
    __block PCKHTTPConnection *connection;
    __block PCKHTTPInterface<CedarDouble> *fakeInterface;
    __block NSURLRequest<CedarDouble> *fakeRequest;
    __block FakeConnectionDelegate *delegate;

    __block NSAutoreleasePool *pool;

    beforeEach(^{
        pool = [[NSAutoreleasePool alloc] init];

        fakeInterface = fake_for([PCKHTTPInterface class]);
        fakeRequest = fake_for([NSURLRequest class]);
        delegate = [[FakeConnectionDelegate alloc] init];
        connection = [[PCKHTTPConnection alloc] initWithHTTPInterface:fakeInterface forRequest:fakeRequest andDelegate:delegate];

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
