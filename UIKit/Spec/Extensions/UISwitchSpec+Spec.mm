#import "CDRSpecHelper.h"
#import "UISwitch+Spec.h"
#import "Target.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UISwitch_SpecSpec)

describe(@"UISwitch+Spec", ^{
    __block UISwitch *uiswitch;
    __block Target *target;

    beforeEach(^{
        target = [[Target alloc] init];
        spy_on(target);

        uiswitch = [[UISwitch alloc] init];
        [uiswitch addTarget:target action:@selector(ciao:) forControlEvents:UIControlEventValueChanged];
    });

    describe(@"-toggle", ^{
        context(@"when visible and enabled", ^{
            beforeEach(^{
                uiswitch.enabled = YES;
                uiswitch.hidden = NO;
            });

            context(@"switch is on", ^{
                beforeEach(^{
                    uiswitch.on = YES;
                    [uiswitch toggle];
                });

                it(@"should toggle the switch to off", ^{
                    uiswitch.on should_not be_truthy;
                });

                it(@"should send the switch's control action", ^{
                    target should have_received(@selector(ciao:)).with(uiswitch);
                });
            });

            context(@"switch is off", ^{
                beforeEach(^{
                    uiswitch.on = NO;
                    [uiswitch toggle];
                });

                it(@"should toggle the switch to on", ^{
                    uiswitch.on should be_truthy;
                });

                it(@"should send the switch's control action", ^{
                    target should have_received(@selector(ciao:)).with(uiswitch);
                });
            });
        });

        context(@"when visible and disabled", ^{
            beforeEach(^{
                uiswitch.enabled = NO;
                uiswitch.hidden = NO;
            });

            it(@"should cause a spec failure", ^{
                ^{ [uiswitch toggle]; } should raise_exception.with_reason(@"Can't toggle a disabled switch");
            });

            it(@"should not send control actions", ^{
                @try {
                    [uiswitch toggle];
                } @catch(NSException *e) { }
                target should_not have_received(@selector(ciao:));
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                uiswitch.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                ^{ [uiswitch toggle]; } should raise_exception.with_reason(@"Can't toggle an invisible switch");
            });

            it(@"should not send control actions", ^{
                @try {
                    [uiswitch toggle];
                } @catch(NSException *e) { }
                target should_not have_received(@selector(ciao:));
            });
        });
    });

    describe(@"-toggleToOn:", ^{
        context(@"when visible and enabled", ^{
            beforeEach(^{
                uiswitch.enabled = YES;
                uiswitch.hidden = NO;
            });

            context(@"the switch is already on", ^{
                beforeEach(^{
                    uiswitch.on = YES;
                });

                context(@"toggling to on", ^{
                    beforeEach(^{
                        [uiswitch toggleToOn:YES];
                    });

                    it(@"should toggle the switch to on", ^{
                        uiswitch.on should be_truthy;
                    });

                    it(@"should not send the switch's control action", ^{
                        target should_not have_received(@selector(ciao:));
                    });
                });

                context(@"toggling to off", ^{
                    beforeEach(^{
                        [uiswitch toggleToOn:NO];
                    });

                    it(@"should toggle the switch to off", ^{
                        uiswitch.on should_not be_truthy;
                    });

                    it(@"should send the switch's control action", ^{
                        target should have_received(@selector(ciao:)).with(uiswitch);
                    });
                });
            });

            context(@"the switch is already off", ^{
                beforeEach(^{
                    uiswitch.on = NO;
                });

                context(@"toggling to on", ^{
                    beforeEach(^{
                        [uiswitch toggleToOn:YES];
                    });

                    it(@"should toggle the switch to on", ^{
                        uiswitch.on should be_truthy;
                    });

                    it(@"should send the switch's control action", ^{
                        target should have_received(@selector(ciao:)).with(uiswitch);
                    });
                });

                context(@"toggling to off", ^{
                    beforeEach(^{
                        [uiswitch toggleToOn:NO];
                    });

                    it(@"should toggle the switch to off", ^{
                        uiswitch.on should_not be_truthy;
                    });

                    it(@"should not send the switch's control action", ^{
                        target should_not have_received(@selector(ciao:));
                    });
                });

                describe(@"observing the switch's value changing", ^{
                    __block BOOL observedValue;

                    beforeEach(^{
                        target stub_method(@selector(ciao:)).and_do_block(^(UISwitch *theSwitch){
                            observedValue = theSwitch.on;
                        });

                        [uiswitch addTarget:target action:@selector(ciao:) forControlEvents:UIControlEventValueChanged];
                        [uiswitch toggleToOn:YES];
                    });

                    it(@"should observe the control value changing to YES", ^{
                        observedValue should be_truthy;
                    });
                });
            });
        });

        context(@"when visible and disabled", ^{
            beforeEach(^{
                uiswitch.enabled = NO;
                uiswitch.hidden = NO;
            });

            it(@"should cause a spec failure", ^{
                ^{ [uiswitch toggleToOn:YES]; } should raise_exception.with_reason(@"Can't toggle a disabled switch");
                ^{ [uiswitch toggleToOn:NO]; } should raise_exception.with_reason(@"Can't toggle a disabled switch");
            });

            it(@"should not send control actions", ^{
                @try {
                    [uiswitch toggleToOn:YES];
                } @catch(NSException *e) { }
                @try {
                    [uiswitch toggleToOn:NO];
                } @catch(NSException *e) { }
                target should_not have_received(@selector(ciao:));
            });
        });

        context(@"when not visible", ^{
            beforeEach(^{
                uiswitch.hidden = YES;
            });

            it(@"should cause a spec failure", ^{
                ^{ [uiswitch toggleToOn:YES]; } should raise_exception.with_reason(@"Can't toggle an invisible switch");
                ^{ [uiswitch toggleToOn:NO]; } should raise_exception.with_reason(@"Can't toggle an invisible switch");
            });

            it(@"should not send control actions", ^{
                @try {
                    [uiswitch toggleToOn:YES];
                } @catch(NSException *e) { }
                @try {
                    [uiswitch toggleToOn:NO];
                } @catch(NSException *e) { }
                target should_not have_received(@selector(ciao:));
            });
        });
    });
});

SPEC_END
