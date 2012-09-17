#import <UIKit/UIKit.h>

@interface UIActionSheet (Spec)

+ (void)afterEach;

+ (UIActionSheet *)currentActionSheet;
+ (UIView *)currentActionSheetView;

+ (void)reset;
+ (void)setCurrentActionSheet:(UIActionSheet *)actionSheet forView:(UIView *)view;

- (NSArray *)buttonTitles;
- (void)dismissByClickingButtonWithTitle:(NSString *)buttonTitle;

- (void)dismissByClickingDestructiveButton;
- (void)dismissByClickingCancelButton;
@end
