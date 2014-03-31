#import <UIKit/UIKit.h>

@class InnerView;

@interface OuterView : UIView

@property (retain, nonatomic) IBOutlet InnerView *innerView;
@property (retain, nonatomic) IBOutlet UIView *subview;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpace;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *verticalSpace;

@end
