#import "UIBarButtonItem+Spec.h"
#import <objc/message.h>


@implementation UIBarButtonItem (Spec)

- (void)tap
{
    id target = self.target;
    SEL action = self.action;
    objc_msgSend(target, action, nil);
}

@end
