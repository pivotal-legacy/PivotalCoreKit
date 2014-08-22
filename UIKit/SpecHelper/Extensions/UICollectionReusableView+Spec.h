#import <UIKit/UIKit.h>

@interface UICollectionReusableView (Spec)

+ (instancetype)instantiatePrototypeReusableViewFromStoryboard:(UIStoryboard *)storyboard
                                      viewControllerIdentifier:(NSString *)viewControllerIdentifier
                                         collectionViewKeyPath:(NSString *)collectionViewKeyPath
                                                viewIdentifier:(NSString *)viewIdentifier;

@end
