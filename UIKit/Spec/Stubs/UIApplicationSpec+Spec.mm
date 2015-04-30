#import "CDRSpecHelper.h"
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
        it(@"should record the last URL", ^{
            [[UIApplication sharedApplication] openURL:url];
            [UIApplication lastOpenedURL] should equal(url);
        });
    });
});

SPEC_END
