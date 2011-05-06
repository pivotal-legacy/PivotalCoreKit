#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIAlertView (PivotalCore)

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate context:(id)context cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (id)context;
- (void)setContext:(id)context;

@end
