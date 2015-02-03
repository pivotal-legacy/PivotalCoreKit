#import "UIAlertAction+Spec.h"
#import "PCKMethodRedirector.h"
#import <objc/runtime.h>


static char * kHandlerKey;

@interface UIAlertAction (SpecPrivate)
+ (instancetype)original_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *))handler;
@end

@implementation UIAlertAction (Spec)

+ (void)load {
    [PCKMethodRedirector redirectSelector:@selector(actionWithTitle:style:handler:)
                                 forClass:objc_getMetaClass(class_getName([self class]))
                                       to:@selector(_actionWithTitle:style:handler:)
                            andRenameItTo:@selector(original_actionWithTitle:style:handler:)];
}

+ (instancetype)_actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *))handler {
    UIAlertAction *action = [self original_actionWithTitle:title style:style handler:handler];
    objc_setAssociatedObject(action, &kHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return action;
}

- (PCKAlertActionHandler)handler {
    return objc_getAssociatedObject(self, &kHandlerKey);
}

@end
