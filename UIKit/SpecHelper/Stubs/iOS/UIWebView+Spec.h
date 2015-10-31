#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * __nullable (^UIWebViewJavaScriptReturnBlock)();

@interface UIWebView (Spec)

// Loaded Requests
- (nullable NSString *)loadedHTMLString;
- (nullable NSURL *)loadedBaseURL;
- (nullable NSData *)loadedData;
- (nullable NSString *)loadedMIMEType;
- (nullable NSString *)loadedTextEncodingName;

// Faking Requests
- (void)sendClickRequest:(NSURLRequest *)request;
- (void)finishLoad;

// Faking Back/Forward Enabled/Disabled state
- (void)setCanGoBack:(BOOL)canGoBack;
- (void)setCanGoForward:(BOOL)canGoForward;

// JavaScript
- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript;
- (void)setReturnBlock:(UIWebViewJavaScriptReturnBlock)block forJavaScript:(NSString *)javaScript;
- (NSArray *)executedJavaScripts;

// Debugging
- (void)enableLogging;
- (void)disableLogging;

@end

NS_ASSUME_NONNULL_END
