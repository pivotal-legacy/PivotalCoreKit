#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKMaybe.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKMaybeSpec)

describe(@"PCKMaybe", ^{
    __block PCKMaybe *subject;
    __block BOOL subjectBlockWasCalled;

    describe(@"a single function", ^{
        beforeEach(^{
            subjectBlockWasCalled = NO;
            subject = [PCKMaybe maybeWithBlock:^id(id o) {
                subjectBlockWasCalled = YES;
                int i = [o intValue];
                if (i > 0) {
                    return @(i);
                }
                return nil;
            }];
        });

        it(@"can be called with just", ^{
            [subject callWithJust:@"5" andOnNone:^{
                fail(@"should not call this block");
            }];
        });

        it(@"can be called with nothing", ^{
            __block BOOL didCallNothingHandler = NO;
            [subject callWithNoneAndOnNone:^{
                didCallNothingHandler = YES;
            }];
            didCallNothingHandler should equal(YES);
        });

        it(@"can be called with maybe", ^{
            [subject callWith:@"4"
                    andOnNone:^{
                        fail(@"should not call this block");
                    }];

            __block BOOL didCallNothingHandler = NO;
            [subject callWith:nil andOnNone:^{
                didCallNothingHandler = YES;
            }];
            didCallNothingHandler should equal(YES);
        });

        describe(@"composing and invoking functions", ^{
            __block PCKMaybe *composed;
            beforeEach(^{
                PCKMaybe *other = [PCKMaybe maybeWithBlock:^id(id o) {
                    return [o stringValue];
                }];

                composed = [subject compose:other];
            });

            it(@"chains the calls, shortcutting on nothing", ^{
                [composed callWithJust:@1 andOnNone:^{
                    fail(@"should not call this block");
                }];

                __block BOOL didCallNothingHandler = NO;
                [composed callWithJust:@0 andOnNone:^{
                    didCallNothingHandler = YES;
                }];
                didCallNothingHandler should equal(YES);
                subjectBlockWasCalled should equal(NO);
            });
        });
    });
});

SPEC_END
