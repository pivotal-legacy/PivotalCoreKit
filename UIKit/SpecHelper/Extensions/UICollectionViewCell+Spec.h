#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Spec)

- (void)tap;

+ (instancetype)instantiatePrototypeCellFromStoryboard:(UIStoryboard *)storyboard
                              viewControllerIdentifier:(NSString *)viewControllerIdentifier
                                 collectionViewKeyPath:(NSString *)collectionViewKeyPath
                                        cellIdentifier:(NSString *)cellIdentifier;

@end
