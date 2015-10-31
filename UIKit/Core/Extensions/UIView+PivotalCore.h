#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ViewCornerTopLeft,
    ViewCornerBottomLeft,
    ViewCornerTopRight,
    ViewCornerBottomRight
} ViewCorner;

@interface UIView (PivotalCore)

// Intended for the idiom view.center = superview.centerBounds;
@property (nonatomic, readonly)  CGPoint centerBounds;

// Move/resize as separate operations, working off of all four corners
- (void)moveCorner:(ViewCorner)corner toPoint:(CGPoint)point;
- (void)moveToPoint:(CGPoint)point;
- (void)moveBy:(CGPoint)pointDelta;
- (void)resizeTo:(CGSize)size keepingCorner:(ViewCorner)corner;
- (void)resizeTo:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
