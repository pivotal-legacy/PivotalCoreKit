#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * __nullable (^UIWebViewJavaScriptReturnBlock)();

@interface UIWebView (Spec)

// Loaded Requests
@property (nonatomic, readonly, nullable) NSString *loadedHTMLString;
@property (nonatomic, readonly, nullable) NSURL *loadedBaseURL;
@property (nonatomic, readonly, nullable) NSData *loadedData;
@property (nonatomic, readonly, nullable) NSString *loadedMIMEType;
@property (nonatomic, readonly, nullable) NSString *loadedTextEncodingName;

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

NS_ASSUME_NONNULL_END
