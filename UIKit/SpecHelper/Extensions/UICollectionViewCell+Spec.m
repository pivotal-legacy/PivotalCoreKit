#import "UICollectionViewCell+Spec.h"

@interface UICollectionView (PrivateAppleMethods)
- (void)_userSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation UICollectionViewCell (Spec)

- (void)tap {
    UIView *currentView = self;
    while (currentView.superview != nil && ![currentView isKindOfClass:[UICollectionView class]]) {
        currentView = currentView.superview;
    }

    NSAssert(currentView, @"Cell must be a in a collection view in order to be tapped!");
    UICollectionView *collectionView = (UICollectionView *)currentView;

    NSIndexPath *indexPath = [collectionView indexPathForCell:self];
    [collectionView _userSelectItemAtIndexPath:indexPath];
}

@end
