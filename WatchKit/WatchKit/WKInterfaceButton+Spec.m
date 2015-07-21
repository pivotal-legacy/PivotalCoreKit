#import "WKInterfaceButton+Spec.h"
#import <objc/message.h>
#import <objc/runtime.h>


void (*wk_interface_button_tap)(id target, SEL action) = (void*)objc_msgSend;


static char *controllerStorageKey;


@implementation WKInterfaceButton (Spec)

- (void)triggerNonSegueAction
{
    NSString *action = [self action];
    SEL actionSelector = NSSelectorFromString(action);
    wk_interface_button_tap(self.controller, actionSelector);
}

- (NSString *)action
{
    return [self valueForKey:@"_action"];
}

- (PCKFakeSegue *)segue
{
    return [self valueForKey:@"_segue"];
}

- (UIColor *)color
{
    return [self valueForKey:@"_color"];
}

- (WKInterfaceGroup *)content
{
    return [self valueForKey:@"_content"];
}

- (NSString *)title
{
    return [self valueForKey:@"_title"];
}

- (BOOL)enabled
{
    return [[self valueForKey:@"_enabled"] boolValue];
}

- (WKInterfaceController *)controller
{
    return objc_getAssociatedObject(self, &controllerStorageKey);
}

- (void)setController:(WKInterfaceController *)controller
{
    objc_setAssociatedObject(self, &controllerStorageKey, controller, OBJC_ASSOCIATION_ASSIGN);
}

@end