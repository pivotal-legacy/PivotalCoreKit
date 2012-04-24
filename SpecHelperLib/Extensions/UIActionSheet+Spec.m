#import "UIActionSheet+Spec.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation UIActionSheet (Spec)

static UIActionSheet *currentActionSheet__;
static UIView *currentActionSheetView__;

+ (void)afterEach {
    [self reset];
}

+ (UIActionSheet *)currentActionSheet {
    return currentActionSheet__;
}

+ (UIView *)currentActionSheetView {
    return currentActionSheetView__;
}

+ (void)reset {
    [self setCurrentActionSheet:nil forView:nil];
}

+ (void)setCurrentActionSheet:(UIActionSheet *)actionSheet forView:(UIView *)view {
    [currentActionSheet__ release];
    [currentActionSheetView__ release];

    currentActionSheet__ = [actionSheet retain];
    currentActionSheetView__ = [view retain];
}

- (void)showInView:(UIView *)view {
    [UIActionSheet setCurrentActionSheet:self forView:view];
}

- (BOOL)isVisible {
    return [UIActionSheet currentActionSheet] == self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
    }
    [UIActionSheet reset];
}

@end
