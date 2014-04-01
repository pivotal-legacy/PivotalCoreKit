#import "UIViewController+PCKNibHelpers.h"
#import "UIView+PCKNibHelpers.h"
#import <objc/runtime.h>

@interface UIViewController (PCKNibHelpersPrivate)

- (void)_originalSetView:(UIView *)view;

@end

@implementation UIViewController (PCKNibHelpers)

+ (void)load
{
    IMP originalSetClassIMP = class_getMethodImplementation(self, @selector(setView:));
    class_replaceMethod(self, @selector(_originalSetView:), originalSetClassIMP, "v@:@");

    IMP swizzledSetClassIMP = imp_implementationWithBlock(^(id me, UIView *viewToReplace) {
        if ([viewToReplace.restorationIdentifier hasPrefix:@"placeholder"]) {
            NSArray *nibObjects = [[UINib nibWithNibName:NSStringFromClass([me class]) bundle:nil] instantiateWithOwner:me options:nil];

            UIView *replacingView = nil;
            for (id obj in nibObjects) {
                if ([obj isKindOfClass:[UIView class]]) {
                    replacingView = obj;
                    break;
                }
            }

            [me _originalSetView:replacingView];

            UIView *superview = viewToReplace.superview;
            [superview insertSubview:replacingView belowSubview:viewToReplace];
            [replacingView configureWithPlaceholderView:viewToReplace];
            [viewToReplace removeFromSuperview];

            return;
        }

        [me _originalSetView:viewToReplace];
    });

    class_replaceMethod(self, @selector(setView:), swizzledSetClassIMP, "v@:@");
}

@end
