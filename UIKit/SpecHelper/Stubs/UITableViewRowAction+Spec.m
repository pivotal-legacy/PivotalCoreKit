#import "UITableViewRowAction+Spec.h"
#import "PCKMethodRedirector.h"
#import <objc/runtime.h>

static char * kHandlerKey;

@interface UITableViewRowAction (SpecPrivate)
+ (instancetype)original_rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title handler:(void (^)(UITableViewRowAction *, NSIndexPath *))handler;
@end

@implementation UITableViewRowAction (Spec)

+ (void)load {
    [PCKMethodRedirector redirectSelector:@selector(rowActionWithStyle:title:handler:)
                                 forClass:objc_getMetaClass(class_getName([self class]))
                                       to:@selector(_rowActionWithStyle:title:handler:)
                            andRenameItTo:@selector(original_rowActionWithStyle:title:handler:)];
}

+ (instancetype)_rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title handler:(void (^)(UITableViewRowAction *, NSIndexPath *))handler {
    UITableViewRowAction *action = [self original_rowActionWithStyle:style title:title handler:handler];
    objc_setAssociatedObject(action, &kHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return action;
}

- (PCKTableViewRowActionHandler)handler {
    return objc_getAssociatedObject(self, &kHandlerKey);
}

@end
