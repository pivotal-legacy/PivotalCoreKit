#import "UICollectionReusableView+Spec.h"
#import "PCKPrototypeCellInstantiatingDataSource.h"
#import "UIView+Spec.h"

@implementation UICollectionReusableView (Spec)

+ (instancetype)instantiatePrototypeReusableViewFromStoryboard:(UIStoryboard *)storyboard
                                      viewControllerIdentifier:(NSString *)viewControllerIdentifier
                                         collectionViewKeyPath:(NSString *)collectionViewKeyPath
                                                viewIdentifier:(NSString *)viewIdentifier {
    NSAssert(storyboard, @"Must provide a storyboard");
    NSAssert([viewIdentifier length] > 0, @"Must provide a view identifier");

    UIViewController *viewController = viewControllerIdentifier ? [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier] : [storyboard instantiateInitialViewController];
    NSAssert(viewController, @"Could not find the view controller");

    [viewController view];

    UICollectionView *collectionView = collectionViewKeyPath ? [viewController valueForKeyPath:collectionViewKeyPath] : [viewController.view firstSubviewOfClass:[UICollectionView class]];
    NSAssert(collectionView, @"Could not find the collection view");

    PCKPrototypeReusableViewInstantiatingDataSource *dataSource = [[[PCKPrototypeReusableViewInstantiatingDataSource alloc] initWithCollectionView:collectionView] autorelease];
    return [dataSource collectionReusableViewWithIdentifier:viewIdentifier];
}

@end
