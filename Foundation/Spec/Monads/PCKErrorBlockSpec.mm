#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKErrorBlock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKErrorBlockSpec)

describe(@"PCKErrorBlock", ^{
    __block PCKErrorBlock *subject;

    describe(@"a single function", ^{
        beforeEach(^{
            subject = [PCKErrorBlock errorWithBlock:^id(id o, NSError **pError) {
                if ([o hasSuffix:@"THERE"]) {
                    return o;
                }
                *pError = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:nil];
                return nil;
            }];
        });

        it(@"can be called with success", ^{
            NSError *error = nil;
            [subject callWithSuccess:@"HI_THERE"
                               error:&error] should equal(@"HI_THERE");
        });

        it(@"can fail", ^{
            NSError *error = nil;
            [subject callWithSuccess:@"NOPE" error:&error];
            error.code should equal(1);
        });

        it(@"can be called with failure", ^{
            NSError *error = nil;
            [subject callWithFailure:[NSError errorWithDomain:NSCocoaErrorDomain code:2 userInfo:nil]
                               error:&error];
            error.code should equal(2);
        });

        describe(@"composing and invoking functions", ^{
            __block PCKErrorBlock *composed;
            beforeEach(^{
                PCKErrorBlock *other = [PCKErrorBlock errorWithBlock:^id(id o, NSError **pError) {
                    if (o) {
                        return [o uppercaseString];
                    }
                    *pError = [NSError errorWithDomain:NSCocoaErrorDomain code:3 userInfo:nil];
                    return nil;
                }];

               composed = [subject compose:other];
            });

            it(@"chains the calls, shortcutting on error", ^{
                NSError *error = nil;
                [composed callWithSuccess:@"hi_there"
                                    error:&error] should equal(@"HI_THERE");

                error = nil;

                [composed callWithSuccess:nil error:&error];
                error.code should equal(3);
            });
        });
    });
});

SPEC_END
