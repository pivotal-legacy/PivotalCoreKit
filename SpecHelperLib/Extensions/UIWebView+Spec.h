#import <UIKit/UIKit.h>

@interface UIWebView (Spec)

- (void)finishLoad;
- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript;
- (NSArray *)executedJavaScripts;
- (void)enableLogging;
- (void)disableLogging;

@end
