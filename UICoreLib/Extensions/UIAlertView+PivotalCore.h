#import <UIKit/UIKit.h>

typedef void (^UIAlertViewClickedBlock)(NSInteger);

@interface UIAlertView (PivotalCore)

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       clickedBlock:(UIAlertViewClickedBlock)clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitle:(NSString *)otherButtonTitle;

@end
