#import "Cedar.h"
#import "UIApplication+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIApplicationSpecSpec)

describe(@"UIApplication (spec extensions)", ^{
    __block NSURL *url;

    beforeEach(^{
        url = [NSURL URLWithString:@"http://example.com/xyzzy"];
    });

    describe(@"- openURL:", ^{
        beforeEach(^{
            [[UIApplication sharedApplication] openURL:url];
        });

        it(@"should record the last URL", ^{
            [UIApplication lastOpenedURL] should equal(url);
        });

        describe(@"when -reset is called", ^{
            beforeEach(^{
                [UIApplication reset];
            });
            it(@"should no longer keeps track of opened URLs", ^{
                [UIApplication lastOpenedURL] should be_nil;
            });
        });
    });
});

SPEC_END
