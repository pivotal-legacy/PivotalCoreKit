#import "UIAlertView+Spec.h"
#import <objc/runtime.h>

static UIAlertView *currentAlertView__;

@implementation UIAlertView (Spec)

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
}

- (BOOL)isVisible {
    return [UIAlertView currentAlertView] == self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	[UIAlertView reset];
    [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
}

@end
