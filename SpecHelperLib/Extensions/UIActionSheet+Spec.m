#import "UIActionSheet+Spec.h"

static UIActionSheet *currentActionSheet__;
static UIView *currentActionSheetView__;

@implementation UIActionSheet (Spec)

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
    [actionSheet retain];
    [view retain];

    [currentActionSheet__ release];
    [currentActionSheetView__ release];

    currentActionSheet__ = actionSheet;
    currentActionSheetView__ = view;
}

- (void)showInView:(UIView *)view {
    [UIActionSheet setCurrentActionSheet:self forView:view];
}

- (BOOL)isVisible {
    return [UIActionSheet currentActionSheet] == self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    [UIActionSheet reset];
}

@end
