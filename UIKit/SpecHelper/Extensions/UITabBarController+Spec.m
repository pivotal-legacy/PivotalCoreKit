#import "UITabBarController+Spec.h"

@implementation UITabBarController (Spec)

-(void) tapTabAtIndex:(NSUInteger)position {
    if (self.viewControllers.count <= position) {
        [[NSException exceptionWithName:@"Untappable" reason:@"TabBarController does not have a tab at that index" userInfo:nil] raise];
    }

    BOOL shouldSelectTab = YES;
    if (self.delegate) {
        UIViewController *controller = self.viewControllers[position];
        shouldSelectTab = [self.delegate tabBarController:self shouldSelectViewController:controller];
    }
    if (shouldSelectTab) {
        self.selectedIndex = position;
    }
}
@end
