#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionReusableView (Spec)

+ (instancetype)instantiatePrototypeReusableViewFromStoryboard:(UIStoryboard *)storyboard
                                      viewControllerIdentifier:(nullable NSString *)viewControllerIdentifier
                                         collectionViewKeyPath:(nullable NSString *)collectionViewKeyPath
                                                viewIdentifier:(NSString *)viewIdentifier;

@end

NS_ASSUME_NONNULL_END
