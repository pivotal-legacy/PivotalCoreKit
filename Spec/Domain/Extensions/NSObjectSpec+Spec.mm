#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#import "PSHKTime.h"

using namespace Cedar::Matchers;

@interface MyObject : NSObject
- (void)noop;
@end

@implementation MyObject
- (void)noop {}
@end


SPEC_BEGIN(NSObject_Spec)

describe(@"NSObject spec extensions", ^{
    __block NSObject *object;
    __block id mockObject;

    SEL selector = @selector(noop);
    NSTimeInterval delay = 1.0;

    beforeEach(^{
        [PSHKTime reset];
        object = [[[MyObject alloc] init] autorelease];
        mockObject = [OCMockObject partialMockForObject:object];

    });

    describe(@"performSelector:withObject:afterDelay", ^{
            it(@"should not immediately execute the selector", ^{
            [[mockObject reject] performSelector:selector];
            [object performSelector:selector withObject:nil afterDelay:delay];
        });

        it(@"should execute the selector after the delay", ^{
            [[mockObject expect] performSelector:selector];

            [object performSelector:selector withObject:nil afterDelay:delay];
            [PSHKTime advanceBy:delay];

            [mockObject verify];
        });




        it(@"should execute the selector only once after the delay", ^{
            [[mockObject expect] performSelector:selector];

            [object performSelector:selector withObject:nil afterDelay:delay];
            [PSHKTime advanceBy:delay];

            [mockObject verify];

            [[mockObject reject] performSelector:selector];
            [PSHKTime advanceBy:delay];


        });



        it(@"should not execute the selector before enough time has passed", ^{

            [[mockObject reject] performSelector:selector];

            [object performSelector:selector withObject:nil afterDelay:delay];
            [PSHKTime advanceBy:(delay/2)];

        });




        it(@"should execute the selector when time passes in parts", ^{


            [[mockObject expect] performSelector:selector];

            [object performSelector:selector withObject:nil afterDelay:delay];
            [PSHKTime advanceBy:(delay/2)];
            [PSHKTime advanceBy:(delay-delay/2)];


            [mockObject verify];

        });



        it(@"should execute the selector after a longer than required delay", ^{
            [[mockObject expect] performSelector:selector];

            [object performSelector:selector withObject:nil afterDelay:delay];
            [PSHKTime advanceBy:delay*2];

            [mockObject verify];
        });
    });

    describe(@"cancelPreviousPerformRequestsWithTarget:selector:object:", ^{
        beforeEach(^{
            [object performSelector:selector withObject:nil afterDelay:delay];
        });

        context(@"when the target and selector match", ^{
            it(@"should allow cancelation before time passes", ^{

                [[mockObject reject] performSelector:selector];


                [NSObject cancelPreviousPerformRequestsWithTarget:object selector:selector object:nil];


                [PSHKTime advanceBy:delay];

            });
        });

        context(@"for a different selector than the scheduled one", ^{
            it(@"should not cancel the scheduled selector", ^{
                [[mockObject expect] performSelector:selector];

                [NSObject cancelPreviousPerformRequestsWithTarget:object selector:@selector(different) object:nil];
                [PSHKTime advanceBy:delay];

                [mockObject verify];
            });
        });

    });
});

SPEC_END
