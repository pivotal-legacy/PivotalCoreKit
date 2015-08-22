#import <UIKit/UIKit.h>

@interface InnerView : UIView

@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UIView *anotherSubview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpace;

@end
