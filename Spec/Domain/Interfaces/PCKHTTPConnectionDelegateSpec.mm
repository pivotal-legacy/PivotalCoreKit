#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#import "PCKHTTPConnectionDelegate.h"
#import "FakeConnectionDelegate.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(PCKHTTPConnectionDelegateSpec)

describe(@"PCKHTTPConnectionDelegate", ^{
    __block id originalDelegate;
    __block PCKHTTPConnectionDelegate *delegate;

    beforeEach(^{
        originalDelegate = [[[FakeConnectionDelegate alloc] init] autorelease];
        delegate = [[[PCKHTTPConnectionDelegate alloc] initWithInterface:nil delegate:originalDelegate] autorelease];
    });

    describe(@"respondsToSelector:", ^{
        it(@"should return true for selectors the original delegate responds to", ^{
            SEL selector = @selector(connection:needNewBodyStream:);

            expect([originalDelegate respondsToSelector:selector]).to(be_truthy());
            expect([delegate respondsToSelector:selector]).to(be_truthy());
        });

        it(@"should return false for selectors the delegate does not respond to", ^{
            SEL selector = @selector(connection:canAuthenticateAgainstProtectionSpace:);

            expect([originalDelegate respondsToSelector:selector]).to_not(be_truthy());
            expect([delegate respondsToSelector:selector]).to_not(be_truthy());
        });
    });

    describe(@"forwardInvocation:", ^{
        it(@"should forward any selector the original delegate responds to to the original delegate", ^{
            SEL selector = @selector(connection:needNewBodyStream:);
            id connection = [OCMockObject mockForClass:[NSURLConnection class]];

            expect([originalDelegate respondsToSelector:selector]).to(be_truthy());
            id mockDelegate = [OCMockObject partialMockForObject:originalDelegate];
            [[mockDelegate expect] connection:connection needNewBodyStream:nil];

            [delegate connection:connection needNewBodyStream:nil];

            [mockDelegate verify];
        });
    });
});

SPEC_END
