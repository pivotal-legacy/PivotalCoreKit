#import "UIView+PivotalCore.h"

@implementation UIView (PivotalCore)

- (CGPoint)centerBounds {
    return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}

- (void)moveCorner:(ViewCorner)corner toPoint:(CGPoint)point {
    CGRect frame = self.frame;
    switch (corner) {
        case ViewCornerTopLeft:
            frame.origin = point;
            break;
        case ViewCornerBottomLeft:
            frame.origin = CGPointMake(point.x, point.y - frame.size.height);
            break;
        case ViewCornerBottomRight:
            frame.origin = CGPointMake(point.x - frame.size.width, point.y - frame.size.height);
            break;
        case ViewCornerTopRight:
            frame.origin = CGPointMake(point.x - frame.size.width, point.y);
            break;
    }
    self.frame = frame;
}

- (void)moveToPoint:(CGPoint)point {
    [self moveCorner:ViewCornerTopLeft toPoint:point];
}

- (void)moveBy:(CGPoint)pointDelta {
    CGRect frame = self.frame;
    frame.origin = CGPointMake(frame.origin.x + pointDelta.x,
                               frame.origin.y + pointDelta.y);
    self.frame = frame;
}

- (void)resizeTo:(CGSize)size keepingCorner:(ViewCorner)corner {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
    switch (corner) {
        case ViewCornerTopLeft:
            break;
        case ViewCornerBottomLeft:
            [self moveCorner:corner toPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
            break;
        case ViewCornerBottomRight:
            [self moveCorner:corner toPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
            break;
        case ViewCornerTopRight:
            [self moveCorner:corner toPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
            break;
    }
}

- (void)resizeTo:(CGSize)size {
    [self resizeTo:size keepingCorner:ViewCornerTopLeft];
}

@end
