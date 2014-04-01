#import "ChildViewController.h"

@implementation ChildViewController

- (void)dealloc {
    [_helloLabel release];
    [super dealloc];
}

@end
