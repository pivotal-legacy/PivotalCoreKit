#import "UICollectionViewCell+Spec.h"

@implementation UICollectionViewCell (Spec)

- (void)tap {
    UIView *currentView = self;
    while (currentView.superview != nil && ![currentView isKindOfClass:[UICollectionView class]]) {
        currentView = currentView.superview;
    }

    NSAssert(currentView, @"Cell must be a in a collection view in order to be tapped!");
    UICollectionView *collectionView = (UICollectionView *)currentView;

    NSIndexPath *indexPath = [collectionView indexPathForCell:self];

    if (indexPath != nil) {
        if (collectionView.allowsMultipleSelection && [collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            if ([collectionView.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
                [collectionView.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
            }
        } else {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            if ([collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
                [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            }
        }
    }
}

@end
