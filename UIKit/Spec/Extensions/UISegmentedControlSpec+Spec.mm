#import "Cedar.h"
#import "UISegmentedControl+Spec.h"
#import "Target.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UISegmentedControlSpec_Spec)

describe(@"UISegmentedControl_Spec", ^{
    __block UISegmentedControl *segmentedControl;
    __block Target *target;

    beforeEach(^{
        target = [[Target alloc] init];
        spy_on(target);

        segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"First", @"Second" ]];
        [segmentedControl addTarget:target action:@selector(ciao:) forControlEvents:UIControlEventValueChanged];
    });

    describe(@"selecting an index", ^{
        context(@"when visible and enabled", ^{
            beforeEach(^{
                segmentedControl.enabled = YES;
                segmentedControl.hidden = NO;
            });

            context(@"and the segment exists", ^{
                beforeEach(^{
                    [segmentedControl selectSegmentAtIndex:1];
                });

                it(@"should set the selected segment index", ^{
                    segmentedControl.selectedSegmentIndex should equal(1);
                });

                it(@"should send the segmented control's action", ^{
                    target should have_received(@selector(ciao:)).with(segmentedControl);
                });
            });

            context(@"and the segment does not exist", ^{
                it(@"should cause a spec failure", ^{
                    ^{ [segmentedControl selectSegmentAtIndex:2]; } should raise_exception.with_reason(@"Can't select a segment that does not exist");
                });
            });
        });

        context(@"when visible and disabled", ^{
            beforeEach(^{
                segmentedControl.enabled = NO;
                segmentedControl.hidden = NO;
            });

            it(@"should cause a spec failure", ^{
                ^{ [segmentedControl selectSegmentAtIndex:0]; } should raise_exception.with_reason(@"Can't toggle a disabled segmented control");
            });

            it(@"should not send control actions", ^{
                @try {
                    [segmentedControl selectSegmentAtIndex:0];
                } @catch(NSException *e) { }
                target should_not have_received(@selector(ciao:));
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                segmentedControl.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                ^{ [segmentedControl selectSegmentAtIndex:0]; } should raise_exception.with_reason(@"Can't toggle an invisible segmented control");
            });

            it(@"should not send control actions", ^{
                @try {
                    [segmentedControl selectSegmentAtIndex:0];
                } @catch(NSException *e) { }
                target should_not have_received(@selector(ciao:));
            });
        });
    });
});

SPEC_END
