#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
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

    describe(@"-reduce:initialValue:", ^{
        it(@"applies the function to the first element and the initial value, to that result and the second,...", ^{
            NSArray *anArray = @[@1, @2, @3];
            [anArray reduce:^id(id accumulator, id input) {
                return @([accumulator integerValue] + [input integerValue]);
            } initialValue:@0] should equal(@6);
        });
    });

    describe(@"-reduce:", ^{
        it(@"applies the function to the first element and the second element, to that result and the third,...", ^{
            NSArray *anArray = @[@1, @2, @3];
            [anArray reduce:^id(id accumulator, id input) {
                return @([accumulator integerValue] + [input integerValue]);
            }] should equal(@6);
        });
    });

    describe(@"-map:", ^{
        it(@"it returns a new array by applying f to each element in the array", ^{
            NSArray *anArray = @[@"one", @"two", @"three"];
            [anArray map:^id(id o) {
                return [(NSString *)o uppercaseString];
            }] should equal(@[@"ONE", @"TWO", @"THREE"]);
        });
    });

    describe(@"-filter:", ^{
        it(@"it returns a new array containing the elements for which f is true", ^{
            NSArray *anArray = @[@"one", @"two", @"three"];
            [anArray filter:^BOOL(id o) {
                return [(NSString *) o hasPrefix:@"t"];
            }] should equal(@[@"two", @"three"]);
        });
    });
});

SPEC_END
