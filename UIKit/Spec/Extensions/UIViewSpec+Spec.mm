#import "Cedar.h"
#import "UIView+Spec.h"
#import "UIView+StubbedGestureRecognizers.h"
#import "Target.h"
#import "UIGestureRecognizer+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIViewSpec_Spec)

describe(@"UIView+Spec", ^{
    __block UIView *view;
    __block Target *target, *otherTarget;

    beforeEach(^{
        view = [[UIView alloc] init];
        target = [[Target alloc] init];
        spy_on(target);

        otherTarget = [[Target alloc] init];
        spy_on(otherTarget);
    });

    describe(@"tapping on the view", ^{
        beforeEach(^{
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
            [tapRecognizer addTarget:target action:@selector(hello)];

            UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
            [swipeRecognizer addTarget:otherTarget action:@selector(hello)];

            [view addGestureRecognizer:tapRecognizer];
            [view addGestureRecognizer:swipeRecognizer];
        });

        it(@"should dispatch tap events when you call -tap", ^{
            [view tap];

            target should have_received(@selector(hello));
            otherTarget should_not have_received(@selector(hello));
        });
    });
    
    describe(@"long pressing on the view", ^{
        beforeEach(^{
            UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] init];
            [longPressRecognizer addTarget:target action:@selector(hello)];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
            [tapRecognizer addTarget:otherTarget action:@selector(hello)];
            
            [view addGestureRecognizer:longPressRecognizer];
            [view addGestureRecognizer:tapRecognizer];
        });
        
        it(@"should dispatch longPress events when you call -longPress", ^{
            [view longPress];
            
            target should have_received(@selector(hello));
            otherTarget should_not have_received(@selector(hello));
        });
    });

    describe(@"swiping the view", ^{
        beforeEach(^{
            UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
            [swipeRecognizer addTarget:target action:@selector(hello)];

            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
            [tapRecognizer addTarget:otherTarget action:@selector(hello)];

            [view addGestureRecognizer:tapRecognizer];
            [view addGestureRecognizer:swipeRecognizer];
        });

        it(@"should dispatch swipe events when you call -swipe", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            [view swipe];
#pragma clang diagnostic pop

            target should have_received(@selector(hello));
            otherTarget should_not have_received(@selector(hello));
        });
    });

    describe(@"swiping the view with a direction", ^{
        __block Target *upTarget, *leftTarget, *rightTarget, *downTarget;

        beforeEach(^{
            upTarget = nice_fake_for([Target class]);
            leftTarget = nice_fake_for([Target class]);
            rightTarget = nice_fake_for([Target class]);
            downTarget = nice_fake_for([Target class]);

            UISwipeGestureRecognizer *upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
            upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;

            [upSwipeRecognizer addTarget:upTarget action:@selector(hello)];

            UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
            leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

            [leftSwipeRecognizer addTarget:leftTarget action:@selector(hello)];

            UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
            rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

            [rightSwipeRecognizer addTarget:rightTarget action:@selector(hello)];

            UISwipeGestureRecognizer *downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
            downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;

            [downSwipeRecognizer addTarget:downTarget action:@selector(hello)];

            [view addGestureRecognizer:upSwipeRecognizer];
            [view addGestureRecognizer:downSwipeRecognizer];
            [view addGestureRecognizer:leftSwipeRecognizer];
            [view addGestureRecognizer:rightSwipeRecognizer];
        });

        it(@"should swipe events for the up direction when you call -swipeWithDirection: with UISwipeGestureRecognizerDirectionUp", ^{
            [view swipeInDirection:UISwipeGestureRecognizerDirectionUp];
            upTarget should have_received(@selector(hello));
            downTarget should_not have_received(@selector(hello));
            leftTarget should_not have_received(@selector(hello));
            rightTarget should_not have_received(@selector(hello));
        });

        it(@"should swipe events for the up direction when you call -swipeWithDirection: with UISwipeGestureRecognizerDirectionDown", ^{
            [view swipeInDirection:UISwipeGestureRecognizerDirectionDown];
            downTarget should have_received(@selector(hello));
            upTarget should_not have_received(@selector(hello));
            leftTarget should_not have_received(@selector(hello));
            rightTarget should_not have_received(@selector(hello));
        });

        it(@"should swipe events for the up direction when you call -swipeWithDirection: with UISwipeGestureRecognizerDirectionLeft", ^{
            [view swipeInDirection:UISwipeGestureRecognizerDirectionLeft];
            leftTarget should have_received(@selector(hello));
            upTarget should_not have_received(@selector(hello));
            downTarget should_not have_received(@selector(hello));
            rightTarget should_not have_received(@selector(hello));
        });

        it(@"should swipe events for the up direction when you call -swipeWithDirection: with UISwipeGestureRecognizerDirectionRight", ^{
            [view swipeInDirection:UISwipeGestureRecognizerDirectionRight];
            rightTarget should have_received(@selector(hello));
            upTarget should_not have_received(@selector(hello));
            downTarget should_not have_received(@selector(hello));
            leftTarget should_not have_received(@selector(hello));
        });
    });

#if !TARGET_OS_TV
    describe(@"pinching the view", ^{
        beforeEach(^{
            UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] init];
            [pinchRecognizer addTarget:target action:@selector(hello)];

            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
            [tapRecognizer addTarget:otherTarget action:@selector(hello)];

            [view addGestureRecognizer:tapRecognizer];
            [view addGestureRecognizer:pinchRecognizer];
        });

        it(@"should dispatch pinch events when you call -pinch", ^{
            [view pinch];

            target should have_received(@selector(hello));
            otherTarget should_not have_received(@selector(hello));
        });
    });
#endif

    describe(@"finding subviews by accessibility identifier", ^{
        __block UIView *view;
        __block UIView *subview1;
        __block UIView *subview2;

        beforeEach(^{
            view = [[UIView alloc] init];
            subview1 = [[UIView alloc] init];
            subview2 = [[UIView alloc] init];

            [subview1 setAccessibilityIdentifier:@"I, Robot"];
            [subview2 setAccessibilityIdentifier:@"Foundation"];

            [view addSubview:subview1];
            [view addSubview:subview2];
        });

        it(@"should return a subview with matching accessibility identifier", ^{
            [view subviewWithAccessibilityIdentifier:@"I, Robot"] should equal(subview1);
            [view subviewWithAccessibilityIdentifier:@"Foundation"] should equal(subview2);
            [view subviewWithAccessibilityIdentifier:@"Kryten"] should be_nil;
        });
    });

    describe(@"finding the first subview of a class", ^{
        __block UIView *view;
        __block UIView *subview1;
        __block UILabel *subview2;
        __block UILabel *subsubview;

        beforeEach(^{
            view = [[UIView alloc] init];
            subview1 = [[UIView alloc] init];
            subview2 = [[UILabel alloc] init];
            subsubview = [[UILabel alloc] init];

            [view addSubview:subview1];
            [view addSubview:subview2];
            [subview1 addSubview:subsubview];
        });

        it(@"should return the closest subview in the tree that is of the given class", ^{
            [view firstSubviewOfClass:[UILabel class]] should equal(subview2);
        });
    });
    
    describe(@"determining if view is completely on screen", ^{
        __block UIView *rootView;
        
        beforeEach(^{
            rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        });
        
        context(@"if the view is visible", ^{
            it(@"should be visible", ^{
                [rootView isTrulyVisible] should be_truthy;
            });
        });
        
        context(@"if a view is hidden", ^{
            beforeEach(^{
                rootView.hidden = YES;
            });
            
            it(@"should not be visible", ^{
                [rootView isTrulyVisible] should be_falsy;
            });
        });
        
        context(@"if a view has 0 alpha", ^{
            beforeEach(^{
                rootView.alpha = 0;
            });
            
            it(@"should not be visible", ^{
                [rootView isTrulyVisible] should be_falsy;
            });
        });
        
        context(@"if a view has clipsToBounds turned on", ^{
            beforeEach(^{
                rootView.clipsToBounds = YES;
            });
            
            context(@"and it has no width", ^{
                beforeEach(^{
                    rootView.frame = CGRectMake(0, 0, 0, 50);
                });
                
                it(@"should not be visible", ^{
                    [rootView isTrulyVisible] should be_falsy;
                });
            });
            
            context(@"and it has no height", ^{
                beforeEach(^{
                    rootView.frame = CGRectMake(0, 0, 50, 0);
                });
                
                it(@"should not be visible", ^{
                    [rootView isTrulyVisible] should be_falsy;
                });
            });
        });
        
        context(@"if a view has clipsToBounds turned off", ^{
            beforeEach(^{
                rootView.clipsToBounds = NO;
            });
            
            context(@"when the view has subviews", ^{
                context(@"and it has no width or no height", ^{
                    beforeEach(^{
                        [rootView addSubview:[UIView new]];
                        rootView.frame = CGRectMake(0, 0, 0, 50);
                    });
                    
                    it(@"should still be considered visible", ^{
                        [rootView isTrulyVisible] should be_truthy;
                    });
                });
            });
            
            context(@"when the view does not have any subviews", ^{
                context(@"and it has no width or no height", ^{
                    beforeEach(^{
                        rootView.frame = CGRectMake(0, 0, 0, 50);
                    });
                    
                    it(@"should not be visible", ^{
                        [rootView isTrulyVisible] should be_falsy;
                    });
                });
            });
        });
        
        context(@"if there is a view inside of another view", ^{
            __block UIView *childView;
            beforeEach(^{
                childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                [rootView addSubview:childView];
            });
            
            context(@"and the superview and the child view are both visible", ^{
                it(@"should be visible", ^{
                    [childView isTrulyVisible] should be_truthy;
                });
            });
            
            context(@"and the superview is not visible", ^{
                beforeEach(^{
                    rootView.alpha = 0;
                    [rootView isTrulyVisible] should be_falsy;
                });
                
                it(@"should not be visible", ^{
                    [childView isTrulyVisible] should be_falsy;
                });
            });
        });
    });
});

SPEC_END
