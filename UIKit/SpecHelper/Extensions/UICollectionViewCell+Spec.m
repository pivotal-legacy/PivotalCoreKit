#import "UICollectionViewCell+Spec.h"
#import "UIView+Spec.h"
#import "PCKPrototypeCellInstantiatingDataSource.h"

@interface UICollectionView (PrivateAppleMethods)
- (void)_userSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation UICollectionViewCell (Spec)

- (void)tap {
    UIView *currentView = self.superview;
    while (currentView.superview != nil && ![currentView isKindOfClass:[UICollectionView class]]) {
        currentView = currentView.superview;
    }

    NSAssert(currentView, @"Cell must be a in a collection view in order to be tapped!");
    UICollectionView *collectionView = (UICollectionView *)currentView;

    NSIndexPath *indexPath = [collectionView indexPathForCell:self];
    [collectionView _userSelectItemAtIndexPath:indexPath];
}

+ (instancetype)instantiatePrototypeCellFromStoryboard:(UIStoryboard *)storyboard
                              viewControllerIdentifier:(NSString *)viewControllerIdentifier
                                 collectionViewKeyPath:(NSString *)collectionViewKeyPath
                                        cellIdentifier:(NSString *)cellIdentifier {
    NSAssert(storyboard, @"Must provide a storyboard");
    NSAssert([cellIdentifier length] > 0, @"Must provide a cell identifier");

    UIViewController *viewController = viewControllerIdentifier ? [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier] : [storyboard instantiateInitialViewController];
    NSAssert(viewController, @"Could not find the view controller");

    [viewController view];

    UICollectionView *collectionView = collectionViewKeyPath ? [viewController valueForKeyPath:collectionViewKeyPath] : [viewController.view firstSubviewOfClass:[UICollectionView class]];
    NSAssert(collectionView, @"Could not find the collection view");

    PCKPrototypeCellInstantiatingDataSource *dataSource = [[[PCKPrototypeCellInstantiatingDataSource alloc] initWithCollectionView:collectionView] autorelease];
    return [dataSource collectionViewCellWithIdentifier:cellIdentifier];
}

@end
