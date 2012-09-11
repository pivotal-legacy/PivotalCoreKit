#import <UIKit/UIKit.h>

typedef NSString *(^UIWebViewJavaScriptReturnBlock)();

@interface UIWebView (Spec)

- (void)sendClickRequest:(NSURLRequest *)request;
- (void)finishLoad;
- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript;
- (void)setReturnBlock:(UIWebViewJavaScriptReturnBlock)block forJavaScript:(NSString *)javaScript;
- (NSArray *)executedJavaScripts;
- (void)enableLogging;
- (void)disableLogging;
- (NSString *)loadedHTMLString;
- (NSURL *)loadedBaseURL;
- (void)setCanGoBack:(BOOL)canGoBack;
- (void)setCanGoForward:(BOOL)canGoForward;

@end
