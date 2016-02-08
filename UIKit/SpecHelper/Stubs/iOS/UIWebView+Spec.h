#import <UIKit/UIKit.h>

typedef NSString *(^UIWebViewJavaScriptReturnBlock)();

@interface UIWebView (Spec)

// Loaded Requests
@property (nonatomic, readonly) NSString *loadedHTMLString;
@property (nonatomic, readonly) NSURL *loadedBaseURL;
@property (nonatomic, readonly) NSData *loadedData;
@property (nonatomic, readonly) NSString *loadedMIMEType;
@property (nonatomic, readonly) NSString *loadedTextEncodingName;

// Faking Requests
- (void)sendClickRequest:(NSURLRequest *)request;
- (void)finishLoad;

// Faking Back/Forward Enabled/Disabled state
- (void)setCanGoBack:(BOOL)canGoBack;
- (void)setCanGoForward:(BOOL)canGoForward;

// JavaScript
- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript;
- (void)setReturnBlock:(UIWebViewJavaScriptReturnBlock)block forJavaScript:(NSString *)javaScript;
@property (nonatomic, readonly) NSArray *executedJavaScripts;

// Debugging
- (void)enableLogging;
- (void)disableLogging;

@end
