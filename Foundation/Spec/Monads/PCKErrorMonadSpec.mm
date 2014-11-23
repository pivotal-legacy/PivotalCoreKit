#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKErrorMonad.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKErrorMonadSpec)

describe(@"PCKErrorMonad", ^{
    __block PCKErrorMonad *subject;

    describe(@"a single function", ^{
        beforeEach(^{
            subject = [PCKErrorMonad errorWithBlock:^id(id o, NSError **pError) {
                        if ([o hasSuffix:@"THERE"]) {
                            return o;
                        }
                        *pError = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:nil];
                        return nil;
                    }];
        });

        it(@"can be called with success", ^{
            [subject callWithSuccess:@"HI_THERE"
                        andOnFailure:^(NSError *error) {
                            fail(@"should not call this block");
                        }] should equal(@"HI_THERE");
        });

        it(@"can fail", ^{
            __block NSError *savedError = nil;
            [subject callWithSuccess:@"NOPE"
                        andOnFailure:^(NSError *error) {
                           savedError = error;
                        }];
            savedError.code should equal(1);
        });

        it(@"can be called with failure", ^{
            [subject callWithFailure:[NSError errorWithDomain:NSCocoaErrorDomain code:2 userInfo:nil]
                        andOnFailure:^(NSError *error) {
                error.code should equal(2);
            }];
        });

        describe(@"composing and invoking functions", ^{
            __block PCKErrorMonad *composed;
            beforeEach(^{
                PCKErrorMonad *other = [PCKErrorMonad errorWithBlock:^id(id o, NSError **pError) {
                    if (o) {
                        return [o uppercaseString];
                    }
                    *pError = [NSError errorWithDomain:NSCocoaErrorDomain code:3 userInfo:nil];
                    return nil;
                }];

               composed = [subject compose:other];
            });

            it(@"chains the calls, shortcutting on error", ^{
                [composed callWithSuccess:@"hi_there"
                             andOnFailure:^(NSError *error) {
                                 fail(@"should not call this block");
                             }] should equal(@"HI_THERE");

                __block NSError *savedError = nil;

                [composed callWithSuccess:nil
                             andOnFailure:^(NSError *error) {
                                 savedError = error;
                             }];
                savedError.code should equal(3);
            });
        });
    });
});

SPEC_END
