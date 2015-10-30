#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKHTTPConnectionDelegate.h"
#import "FakeConnectionDelegate.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKHTTPConnectionDelegateSpec)

describe(@"PCKHTTPConnectionDelegate", ^{
    __block id originalDelegate;
    __block PCKHTTPConnectionDelegate *delegate;

    beforeEach(^{
        originalDelegate = [[FakeConnectionDelegate alloc] init];
        delegate = [[PCKHTTPConnectionDelegate alloc] initWithInterface:nil delegate:originalDelegate];
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
            expect([originalDelegate respondsToSelector:@selector(connection:needNewBodyStream:)]).to(be_truthy());

            spy_on(originalDelegate);
            NSURLConnection<CedarDouble> *connection = fake_for([NSURLConnection class]);
            NSURLRequest<CedarDouble> *request = fake_for([NSURLRequest class]);
            [delegate connection:connection needNewBodyStream:request];

            originalDelegate should have_received("connection:needNewBodyStream:");
        });
    });
});

SPEC_END
