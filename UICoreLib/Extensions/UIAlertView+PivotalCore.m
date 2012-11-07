#import "UIAlertView+PivotalCore.h"

@implementation UIAlertView (PivotalCore)

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       clickedBlock:(UIAlertViewClickedBlock)clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitle:(NSString *)otherButtonTitle {
    if (self = [self initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil]) {

    }
    return self;
}

@end
