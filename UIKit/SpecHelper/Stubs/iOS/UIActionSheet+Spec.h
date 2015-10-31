#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIActionSheet (Spec)

+ (void)afterEach;

+ (nullable UIActionSheet *)currentActionSheet;
+ (nullable UIView *)currentActionSheetView; // might return a UIBarButtonItem

+ (void)reset;
+ (void)setCurrentActionSheet:(nullable UIActionSheet *)actionSheet forView:(nullable UIView *)view;

@property (nonatomic, readonly) NSArray *buttonTitles;
- (void)dismissByClickingButtonWithTitle:(NSString *)buttonTitle;

- (void)dismissByClickingDestructiveButton;
- (void)dismissByClickingCancelButton;

@end

NS_ASSUME_NONNULL_END
