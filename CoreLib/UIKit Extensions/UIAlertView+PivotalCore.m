#import "UIAlertView+PivotalCore.h"

static char UIAlertViewContextKey;

@implementation UIAlertView (PivotalCore)

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate context:(id)context cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
	self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
	if (self) {
		[self setContext:context];
	}
	return self;
}

- (id)context {
	return objc_getAssociatedObject(self, &UIAlertViewContextKey);
}

- (void)setContext:(id)context {
	objc_setAssociatedObject(self, &UIAlertViewContextKey, context, OBJC_ASSOCIATION_ASSIGN);
}


@end
