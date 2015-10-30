#import "Cedar.h"

#import "UIView+PivotalCore.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(UIView_PivotalCoreSpec)

describe(@"UIView_PivotalCore", ^{
    __block UIView *view;
    __block CGRect oldFrame;

    beforeEach(^{
        view = [[UIView alloc] initWithFrame:CGRectMake(50, 10, 200, 100)];
        oldFrame = view.frame;
    });

    describe(@"- centerBounds", ^{
        it(@"should return the center of the view's bounds", ^{
            view.centerBounds should equal(CGPointMake(100, 50));
        });
    });

    describe(@"- moveToPoint:", ^{
        it(@"should move the top left point of the view to the specified location", ^{
            [view moveToPoint:CGPointMake(20, 20)];
            expect(CGRectGetMinX(view.frame)).to(equal(20));
            expect(CGRectGetMinY(view.frame)).to(equal(20));
            expect(view.frame.size).to(equal(oldFrame.size));
        });
    });

    describe(@"- moveCorner:toPoint:", ^{
        it(@"should move the specified corner of the view to the specified location", ^{
            [view moveCorner:ViewCornerTopLeft toPoint:CGPointMake(20, 20)];
            expect(CGRectGetMinX(view.frame)).to(equal(20));
            expect(CGRectGetMinY(view.frame)).to(equal(20));
            expect(view.frame.size).to(equal(oldFrame.size));
        });

        it(@"should work with bottom left", ^{
            [view moveCorner:ViewCornerBottomLeft toPoint:CGPointMake(20, 400)];
            expect(CGRectGetMinX(view.frame)).to(equal(20));
            expect(CGRectGetMaxY(view.frame)).to(equal(400));
            expect(view.frame.size).to(equal(oldFrame.size));
        });

        it(@"should work with bottom right", ^{
            [view moveCorner:ViewCornerBottomRight toPoint:CGPointMake(300, 500)];
            expect(CGRectGetMaxX(view.frame)).to(equal(300));
            expect(CGRectGetMaxY(view.frame)).to(equal(500));
            expect(view.frame.size).to(equal(oldFrame.size));
        });

        it(@"should work with top right", ^{
            [view moveCorner:ViewCornerTopRight toPoint:CGPointMake(300, 20)];
            expect(CGRectGetMaxX(view.frame)).to(equal(300));
            expect(CGRectGetMinY(view.frame)).to(equal(20));
            expect(view.frame.size).to(equal(oldFrame.size));
        });
    });

    describe(@"- resizeTo:", ^{
        __block CGSize newSize;

        beforeEach(^{
            newSize = CGSizeMake(10, 10);
        });

        it(@"should resize the view frame while maintaining the top left corner", ^{
            [view resizeTo:newSize];
            expect(view.frame.origin).to(equal(oldFrame.origin));
            expect(view.frame.size).to(equal(newSize));
        });

        it(@"should allow you to change the corner we maintain", ^{
            [view resizeTo:newSize keepingCorner:ViewCornerBottomLeft];
            expect(view.frame.size).to(equal(newSize));
            expect(CGRectGetMinX(view.frame)).to(equal(CGRectGetMinX(oldFrame)));
            expect(CGRectGetMaxY(view.frame)).to(equal(CGRectGetMaxY(oldFrame)));
        });
    });
});

SPEC_END
