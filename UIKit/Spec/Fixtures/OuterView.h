#import <UIKit/UIKit.h>

@class InnerView;

@interface OuterView : UIView

@property (weak, nonatomic) IBOutlet InnerView *innerView;
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpace;

@end
