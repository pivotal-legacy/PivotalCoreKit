#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSURL+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(NSURLSpec_Spec)

describe(@"NSURL (spec extensions)", ^{
    __block NSURL *URL;

    describe(@"-queryComponents", ^{
        __block NSDictionary *queryComponents;

        it(@"creats a Dictionary of all query components", ^{
            URL = [NSURL URLWithString:@"http://example.com/a?foo=bar&bar=baz&foo=bat&foo=cat"];
            queryComponents = URL.queryComponents;
            queryComponents.allKeys.count should equal(2);
            queryComponents[@"bar"] should equal(@"baz");
            queryComponents[@"foo"] should equal([@[@"bar", @"bat", @"cat"] mutableCopy]);
        });
    });
});

SPEC_END
