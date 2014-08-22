#import <UIKit/UIKit.h>

@interface UITableViewCell (SpecHelper)

- (void)tap;
- (void)tapDeleteAccessory;
- (void)tapDeleteConfirmation;

+ (instancetype)instantiatePrototypeCellFromStoryboard:(UIStoryboard *)storyboard
                              viewControllerIdentifier:(NSString *)viewControllerIdentifier
                                      tableViewKeyPath:(NSString *)tableViewKeyPath
                                        cellIdentifier:(NSString *)cellIdentifier;

@end
