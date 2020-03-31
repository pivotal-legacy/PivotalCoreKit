#if !__has_feature(objc_arc)
#error This class must be compiled with ARC
#endif

#import "UIAlertView+Spec.h"
#import "PCKMethodRedirector.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation UIAlertView (Spec)

static NSMutableArray *alertViewStack__ = nil;

+ (void)load {
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
    [PCKMethodRedirector redirectPCKReplaceSelectorsForClass:self];
}

+ (void)afterEach {
    [self reset];
}

+ (UIAlertView *)currentAlertView {
    return [alertViewStack__ lastObject];
}

+ (void)reset {
    alertViewStack__ = nil;
}

+ (void)setCurrentAlertView:(UIAlertView *)alertView {
    if (!alertViewStack__) {
        alertViewStack__ = [[NSMutableArray alloc] init];
    }
    [alertViewStack__ addObject:alertView];
}

- (void)pck_replace_show {
    [UIAlertView setCurrentAlertView:self];
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
}

- (BOOL)pck_replace_isVisible {
    return [UIAlertView currentAlertView] == self;
}

- (void)pck_replace_dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
    [alertViewStack__ removeObject:self];
}

- (void)dismissWithOkButton {
    [self dismissWithClickedButtonIndex:self.firstOtherButtonIndex animated:NO];
}

- (void)dismissWithCancelButton {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

@end

#pragma clang diagnostic pop // "-Wdeprecated-declarations"
