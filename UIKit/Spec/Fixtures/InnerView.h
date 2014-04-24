#import <UIKit/UIKit.h>

@interface InnerView : UIView

@property (retain, nonatomic) IBOutlet UIView *subview;
@property (retain, nonatomic) IBOutlet UIView *anotherSubview;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *verticalSpace;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpace;

@end
