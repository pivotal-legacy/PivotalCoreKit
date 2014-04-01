#import <UIKit/UIKit.h>

@class ChildViewController;

@interface MainController : UIViewController

@property (strong, nonatomic) IBOutlet ChildViewController *childController;

@end
