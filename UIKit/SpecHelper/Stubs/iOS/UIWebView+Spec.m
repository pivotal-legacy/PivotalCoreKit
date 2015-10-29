#if !__has_feature(objc_arc)
#error This class must be compiled with ARC
#endif

#import "UIWebView+Spec.h"
#import <objc/runtime.h>

@interface UIWebViewAttributes : NSObject

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, assign) BOOL loading, logging, canGoBack, canGoForward;
@property (nonatomic, strong) NSMutableArray *javaScripts;
@property (nonatomic, strong) NSMutableDictionary *returnValueBlocksByJavaScript;
@property (nonatomic, strong) NSString *loadedHTMLString;
@property (nonatomic, strong) NSURL *loadedBaseURL;
@property (nonatomic, strong) NSData *loadedData;
@property (nonatomic, strong) NSString *loadedMIMEType;
@property (nonatomic, strong) NSString *loadedTextEncodingName;

@end

@implementation UIWebViewAttributes

- (id)init {
    if (self = [super init]) {
        self.javaScripts = [NSMutableArray array];
        self.returnValueBlocksByJavaScript = [NSMutableDictionary dictionary];
    }
    return self;
}

@end

@interface UIWebView (Spec_Private)

- (void)loadRequest:(NSURLRequest *)request withNavigationType:(UIWebViewNavigationType)navigationType;
- (UIWebViewAttributes *)attributes;
- (void)log:(NSString *)message, ...;

@end

static char ASSOCIATED_ATTRIBUTES_KEY;

@implementation UIWebView (Spec)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#pragma mark Property overrides
- (BOOL)canGoBack {
    return self.attributes.canGoBack;
}

- (BOOL)canGoForward {
    return self.attributes.canGoForward;
}

- (void)setCanGoBack:(BOOL)canGoBack {
    self.attributes.canGoBack = canGoBack;
}

- (void)setCanGoForward:(BOOL)canGoForward {
    self.attributes.canGoForward = canGoForward;
}

- (void)setRequest:(NSURLRequest *)request {
    self.attributes.request = request;
}

- (NSURLRequest *)request {
    return self.attributes.request;
}

- (BOOL)isLoading {
    return self.attributes.loading;
}

- (void)setLoading:(BOOL)loading {
    self.attributes.loading = loading;
}

#pragma mark Method overrides
- (void)loadRequest:(NSURLRequest *)request {
    [self log:@"loadRequest: %@", request];
    [self loadRequest:request withNavigationType:UIWebViewNavigationTypeOther];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    self.attributes.loadedHTMLString = string;
    self.attributes.loadedBaseURL = baseURL;
    [self log:@"loadHTMLString:%@ baseURL:%@", string, baseURL];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
    self.attributes.loadedData = data;
    self.attributes.loadedMIMEType = MIMEType;
    self.attributes.loadedTextEncodingName = textEncodingName;
    self.attributes.loadedBaseURL = baseURL;
    [self log:@"loadData:%@ MIMEType:%@ textEncodingName:%@ baseURL:%@", data, MIMEType, textEncodingName, baseURL];
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScript {
    [self.attributes.javaScripts addObject:javaScript];
    UIWebViewJavaScriptReturnBlock block = [self.attributes.returnValueBlocksByJavaScript objectForKey:javaScript];
    if (block) {
        return block();
    } else {
        return nil;
    }
}

#pragma clang diagnostic pop

#pragma mark Additions
- (void)sendClickRequest:(NSURLRequest *)request {
    [self log:@"sendClickRequest: %@", request];
    [self loadRequest:request withNavigationType:UIWebViewNavigationTypeLinkClicked];
}

- (void)finishLoad {
    [self log:@"finishLoad, for request: %@", self.request];

    if (!self.request) {
        NSString *message = [NSString stringWithFormat:@"Attempt to finish load of nonexistent request"];
        [self log:message];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:message userInfo:nil] raise];
    }

    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
    self.loading = NO;
}

- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript {
    UIWebViewJavaScriptReturnBlock block = [^{ return returnValue; } copy];
    [self.attributes.returnValueBlocksByJavaScript setObject:block forKey:javaScript];
}

- (void)setReturnBlock:(UIWebViewJavaScriptReturnBlock)block forJavaScript:(NSString *)javaScript {
    UIWebViewJavaScriptReturnBlock copiedBlock = [block copy];
    [self.attributes.returnValueBlocksByJavaScript setObject:copiedBlock forKey:javaScript];
}

- (NSArray *)executedJavaScripts {
    return self.attributes.javaScripts;
}

- (void)enableLogging {
    self.attributes.logging = YES;
}

- (void)disableLogging {
    self.attributes.logging = NO;
}

- (NSString *)loadedHTMLString {
    return self.attributes.loadedHTMLString;
}

- (NSURL *)loadedBaseURL {
    return self.attributes.loadedBaseURL;
}

- (NSData *)loadedData {
    return self.attributes.loadedData;
}

- (NSString *)loadedMIMEType {
    return self.attributes.loadedMIMEType;
}

- (NSString *)loadedTextEncodingName {
    return self.attributes.loadedTextEncodingName;
}

#pragma mark Private interface
- (UIWebViewAttributes *)attributes {
    UIWebViewAttributes *attributes = objc_getAssociatedObject(self, &ASSOCIATED_ATTRIBUTES_KEY);

    if (!attributes) {
        attributes = [[UIWebViewAttributes alloc] init];
        objc_setAssociatedObject(self, &ASSOCIATED_ATTRIBUTES_KEY, attributes, OBJC_ASSOCIATION_RETAIN);
    }

    return attributes;
}

- (void)loadRequest:(NSURLRequest *)request withNavigationType:(UIWebViewNavigationType)navigationType {
    if (self.isLoading) {
        NSString *message = [NSString stringWithFormat:@"Attempt to load request: %@ with previously loading request: %@", request, self.request];
        [self log:message];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:message userInfo:nil] raise];
    }

    BOOL shouldStartLoad = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        shouldStartLoad = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    if (shouldStartLoad) {
        [self log:@"Starting load for request: %@", request];
        self.request = request;
        self.loading = YES;
        if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]){
            [self.delegate webViewDidStartLoad:self];
        }
    }
}

- (void)log:(NSString *)message, ... {
    if (self.attributes.logging) {
        va_list args;
        va_start(args, message);
        NSLog(@"WebView: %@", self);
        NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        NSLogv(message, args);
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        va_end(args);
    }
}

@end
