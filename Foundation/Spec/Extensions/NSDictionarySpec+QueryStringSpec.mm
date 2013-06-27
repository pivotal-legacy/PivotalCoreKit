#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSDictionary+QueryString.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSDictionarySpec_QueryStringSpec)

describe(@"NSDictionary (QueryString Extensions)", ^{
    describe(@"-queryString", ^{
        __block NSDictionary *dictionary;
        __block NSString *query;
        __block NSArray *queryEntries;

        it(@"creates a basic query string from dictionary contents", ^{
            dictionary = @{@"a" : @"1", @"2" : @"c"};

            query = dictionary.queryString;

            queryEntries = [query componentsSeparatedByString:@"&"];

            queryEntries.count should equal(2);

            queryEntries should contain(@"a=1");
            queryEntries should contain(@"2=c");
        });

        it(@"url encodes keys and values", ^{
            dictionary = @{@"hat[cat][fat]" : @"foo + bar & baz "};

            query = dictionary.queryString;
            
            query should equal(@"hat%5Bcat%5D%5Bfat%5D=foo%20%2B%20bar%20%26%20baz%20");
        });
    });
});

SPEC_END
