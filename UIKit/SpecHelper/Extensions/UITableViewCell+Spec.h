#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (SpecHelper)

- (void)tap;
- (void)tapDeleteAccessory;
- (void)tapDeleteConfirmation;

+ (instancetype)instantiatePrototypeCellFromStoryboard:(UIStoryboard *)storyboard
                              viewControllerIdentifier:(nullable NSString *)viewControllerIdentifier
                                      tableViewKeyPath:(nullable NSString *)tableViewKeyPath
                                        cellIdentifier:(NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
