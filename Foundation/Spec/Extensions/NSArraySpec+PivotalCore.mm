#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSArray+PivotalCore.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSArray_PivotalCore)

describe(@"NSArray", ^{
    describe(@"-collect:", ^{
        it(@"should return an array containing the result of doing the block against each element in the array", ^{
            NSArray *anArray = @[@"foo", @"bar", @"baz"];
            id(^uppercase)(id) = ^id(NSString *string) {
                return [string uppercaseString];
            };
            [anArray collect:uppercase] should equal(@[@"FOO", @"BAR", @"BAZ"]);
        });

        it(@"should omit elements which are nil when collected", ^{
            NSObject *obj1 = @{@"foo": @NO, @"bar": @YES };
            NSObject *obj2 = @{@"bar": @NO, @"baz": @YES };

            NSArray *anArray = @[obj1, obj2];

            id(^getValueForKeyFoo)(id) = ^id(NSObject *object) {
                return [object valueForKey:@"foo"];
            };
            [anArray collect:getValueForKeyFoo] should equal(@[@NO]);
        });

    });

    describe(@"-collect:boxNils:", ^{
        it(@"should box nils when told to do so", ^{
            NSObject *obj1 = @{@"foo": @NO, @"bar": @YES };
            NSObject *obj2 = @{@"bar": @NO, @"baz": @YES };

            NSArray *anArray = @[obj1, obj2];

            id(^getValueForKeyFoo)(id) = ^id(NSObject *object) {
                return [object valueForKey:@"foo"];
            };
            [anArray collect:getValueForKeyFoo boxNils:YES] should equal(@[@NO, [NSNull null]]);
        });
    });

    describe(@"-collectWithKeyPath:", ^{
        it(@"should return the value of the given keypath of each object in the array, dropping nils", ^{
            NSObject *obj1 = @{@"foo": @1, @"bar": @2 };
            NSObject *obj2 = @{@"bar": @3, @"baz": @4 };

            NSArray *anArray = @[obj1, obj2];

            [anArray collectWithKeyPath:@"foo"] should equal(@[@1]);
        });
    });
});

SPEC_END
