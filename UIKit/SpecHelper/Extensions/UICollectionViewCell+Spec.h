#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (Spec)

- (void)tap;

+ (instancetype)instantiatePrototypeCellFromStoryboard:(UIStoryboard *)storyboard
                              viewControllerIdentifier:(nullable NSString *)viewControllerIdentifier
                                 collectionViewKeyPath:(nullable NSString *)collectionViewKeyPath
                                        cellIdentifier:(NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
