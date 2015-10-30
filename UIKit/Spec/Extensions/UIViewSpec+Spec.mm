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
});

SPEC_END
