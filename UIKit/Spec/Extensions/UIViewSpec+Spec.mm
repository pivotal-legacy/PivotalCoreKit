#import "SpecHelper.h"
#import "UIView+Spec.h"
#import "Target.h"
#import "UIGestureRecognizer+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIViewSpec_Spec)

describe(@"UIView+Spec", ^{
    __block UIView *view;
    __block Target *target;
    __block Target *otherTarget;

    beforeEach(^{
        view = [[[UIView alloc] init] autorelease];
        target = [[[Target alloc] init] autorelease];
        spy_on(target);

        otherTarget = [[[Target alloc] init] autorelease];
        spy_on(otherTarget);
    });

    describe(@"tapping on the view", ^{
        beforeEach(^{
            UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
            [tapRecognizer addTarget:target action:@selector(hello)];

            UISwipeGestureRecognizer *swipeRecognizer = [[[UISwipeGestureRecognizer alloc] init] autorelease];
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
            UISwipeGestureRecognizer *swipeRecognizer = [[[UISwipeGestureRecognizer alloc] init] autorelease];
            [swipeRecognizer addTarget:target action:@selector(hello)];

            UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
            [tapRecognizer addTarget:otherTarget action:@selector(hello)];

            [view addGestureRecognizer:tapRecognizer];
            [view addGestureRecognizer:swipeRecognizer];
        });

        it(@"should dispatch swipe events when you call -swipe", ^{
            [view swipe];

            target should have_received(@selector(hello));
            otherTarget should_not have_received(@selector(hello));
        });
    });

    describe(@"pinching the view", ^{
        beforeEach(^{
            UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] init] autorelease];
            [pinchRecognizer addTarget:target action:@selector(hello)];

            UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
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

    describe(@"finding subviews by accessibility identifier", ^{
        __block UIView *view;
        __block UIView *subview1;
        __block UIView *subview2;

        beforeEach(^{
            view = [[[UIView alloc] init] autorelease];
            subview1 = [[[UIView alloc] init] autorelease];
            subview2 = [[[UIView alloc] init] autorelease];

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
            view = [[[UIView alloc] init] autorelease];
            subview1 = [[[UIView alloc] init] autorelease];
            subview2 = [[[UILabel alloc] init] autorelease];
            subsubview = [[[UILabel alloc] init] autorelease];

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
