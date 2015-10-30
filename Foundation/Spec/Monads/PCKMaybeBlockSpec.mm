#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKMaybeBlock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKMaybeBlockSpec)

describe(@"PCKMaybeBlock", ^{
    __block PCKMaybeBlock *subject;
    __block BOOL subjectBlockWasCalled;

    describe(@"a single function", ^{
        beforeEach(^{
            subjectBlockWasCalled = NO;
            subject = [PCKMaybeBlock maybeWithBlock:^id(id o) {
                subjectBlockWasCalled = YES;
                int i = [o intValue];
                if (i > 10) {
                    return o;
                }
                return nil;
            }];
        });

        it(@"can be called with something", ^{
            [subject call:@11] should equal(@11);
        });
        
        it(@"can produce nothing", ^{
            [subject call:@5] should be_nil;
        });

        it(@"can be called with nothing", ^{
            [subject call:nil];
            subjectBlockWasCalled should equal(NO);
        });

        describe(@"composing and invoking functions", ^{
            __block PCKMaybeBlock *composed;
            beforeEach(^{
                PCKMaybeBlock *other = [PCKMaybeBlock maybeWithBlock:^id(id o) {
                    int i = [o intValue];
                    if (i > 5) {
                        return o;
                    }
                    return nil;
                }];

                composed = [subject compose:other];
            });

            it(@"chains the calls", ^{
                [composed call:@11] should equal(@11);
            });
            
            it(@"shortcuts on nothing", ^{
                [composed call:@0] should be_nil;
                subjectBlockWasCalled should equal(NO);
                
                [composed call:@6] should be_nil;
                subjectBlockWasCalled should equal(YES);
            });
            
            it(@"chains many calls", ^{
                PCKMaybeBlock *maybe = [PCKMaybeBlock maybeWithBlock:^id(id o) {
                    return [o arrayByAddingObject:@([o count])];
                }];

                [[[maybe compose:maybe] compose:maybe] call:@[]] should equal(@[@0, @1, @2]);
            });
        });
    });
});

SPEC_END
