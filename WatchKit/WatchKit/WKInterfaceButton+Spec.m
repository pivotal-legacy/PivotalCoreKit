#import "WKInterfaceButton+Spec.h"
#import <objc/message.h>
#import <objc/runtime.h>


void (*wk_interface_button_tap)(id target, SEL action) = (void*)objc_msgSend;


static char *controllerStorageKey;

@implementation WKInterfaceButton (Spec2)

- (void)triggerNonSegueAction
{
    NSString *action = [self action];
    SEL actionSelector = NSSelectorFromString(action);
    wk_interface_button_tap(self.controller, actionSelector);
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
