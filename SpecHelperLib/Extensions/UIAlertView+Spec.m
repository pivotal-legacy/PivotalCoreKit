#import "UIAlertView+Spec.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation UIAlertView (Spec)

static UIAlertView *currentAlertView__;

+ (void)afterEach {
    [self reset];
}

+ (UIAlertView *)currentAlertView {
    return currentAlertView__;
}

+ (void)reset {
    [currentAlertView__ release];
    currentAlertView__ = nil;
}

+ (void)setCurrentAlertView:(UIAlertView *)alertView {
    [alertView retain];
    [currentAlertView__ release];
    currentAlertView__ = alertView;
}

- (void)show {
    [UIAlertView setCurrentAlertView:self];
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
}

- (BOOL)isVisible {
    return [UIAlertView currentAlertView] == self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
    [UIAlertView reset];
}

- (void)dismissWithOkButton {
    [self dismissWithClickedButtonIndex:self.firstOtherButtonIndex animated:NO];
}

- (void)dismissWithCancelButton {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

@end
