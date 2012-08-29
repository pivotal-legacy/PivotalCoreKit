#import "UIWebView+Spec.h"
#import "objc/runtime.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface UIWebViewAttributes : NSObject
@property (nonatomic, assign) id<UIWebViewDelegate> delegate;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, assign) BOOL loading, logging, allowsInlineMediaPlayback;
@property (nonatomic, retain) NSMutableArray *javaScripts;
@property (nonatomic, retain) NSMutableDictionary *returnValueBlocksByJavaScript;
@property (nonatomic, retain) NSString *loadedHTMLString;
@property (nonatomic, retain) NSURL *loadedBaseURL;
@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;
@end

@implementation UIWebViewAttributes
@synthesize delegate = delegate_, request = request_, loading = loading_, logging = logging_,
    javaScripts = javaScripts_, returnValueBlocksByJavaScript = returnValueBlocksByJavaScript_,
    loadedHTMLString = loadedHTMLString_, loadedBaseURL = loadedBaseURL_,
    allowsInlineMediaPlayback = allowsInlineMediaPlayback_, dataDetectorTypes = dataDetectorTypes_;

- (id)init {
    if (self = [super init]) {
        self.javaScripts = [NSMutableArray array];
        self.returnValueBlocksByJavaScript = [NSMutableDictionary dictionary];
        self.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    }
    return self;
}

- (void)dealloc {
    self.loadedHTMLString = nil;
    self.loadedBaseURL = nil;
    self.request = nil;
    self.returnValueBlocksByJavaScript = nil;
    self.javaScripts = nil;
    [super dealloc];
}
@end

@interface UIWebView (Spec_Private)
- (void)loadRequest:(NSURLRequest *)request withNavigationType:(UIWebViewNavigationType)navigationType;
- (UIWebViewAttributes *)attributes;
- (void)log:(NSString *)message, ...;
@end

static char ASSOCIATED_ATTRIBUTES_KEY;

@implementation UIWebView (Spec)

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        objc_setAssociatedObject(self, &ASSOCIATED_ATTRIBUTES_KEY, [[[UIWebViewAttributes alloc] init] autorelease], OBJC_ASSOCIATION_RETAIN);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)dealloc {
    [super dealloc];
}

// Call retain/release on the superclass, because the original retain/release calls for UIWebView appear to be
// proxying the calls to some sort of internal implementation class, which we (of course) don't create in our
// fake constructor.
- (id)retain {
    return [super retain];
}

- (void)release {
    [super release];
}

#pragma mark Property overrides
- (void)setDelegate:(id<UIWebViewDelegate>)delegate {
    self.attributes.delegate = delegate;
}

- (id<UIWebViewDelegate>)delegate {
    return self.attributes.delegate;
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

- (BOOL)allowsInlineMediaPlayback {
    return self.attributes.allowsInlineMediaPlayback;
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allowed {
    self.attributes.allowsInlineMediaPlayback = allowed;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (CGRect)frame {
    return super.frame;
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes {
    self.attributes.dataDetectorTypes = dataDetectorTypes;
}

- (UIDataDetectorTypes)dataDetectorTypes {
    return self.attributes.dataDetectorTypes;
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

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScript {
    [self.attributes.javaScripts addObject:javaScript];
    UIWebViewJavaScriptReturnBlock block = [self.attributes.returnValueBlocksByJavaScript objectForKey:javaScript];
    if (block) {
        return block();
    } else {
        return nil;
    }
}

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
    UIWebViewJavaScriptReturnBlock block = [[^{ return returnValue; } copy] autorelease];
    [self.attributes.returnValueBlocksByJavaScript setObject:block forKey:javaScript];
}

- (void)setReturnBlock:(UIWebViewJavaScriptReturnBlock)block forJavaScript:(NSString *)javaScript {
    UIWebViewJavaScriptReturnBlock copiedBlock = [[block copy] autorelease];
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

#pragma mark Private interface
- (void)loadRequest:(NSURLRequest *)request withNavigationType:(UIWebViewNavigationType)navigationType {
    if (self.loading) {
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

- (UIWebViewAttributes *)attributes {
    return objc_getAssociatedObject(self, &ASSOCIATED_ATTRIBUTES_KEY);
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

#pragma clang diagnostic pop
