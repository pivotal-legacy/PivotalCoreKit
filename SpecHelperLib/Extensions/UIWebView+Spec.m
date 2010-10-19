#import "UIWebView+Spec.h"

@interface UIWebViewAttributes : NSObject
@property (nonatomic, assign) id<UIWebViewDelegate> delegate;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, assign) BOOL loading, logging;
@property (nonatomic, retain) NSMutableArray *javaScripts;
@property (nonatomic, retain) NSMutableDictionary *returnValueBlocksByJavaScript;
@end

@implementation UIWebViewAttributes
@synthesize delegate = delegate_, request = request_, loading = loading_, logging = logging_,
    javaScripts = javaScripts_, returnValueBlocksByJavaScript = returnValueBlocksByJavaScript_;

- (id)init {
    if (self = [super init]) {
        self.javaScripts = [NSMutableArray array];
        self.returnValueBlocksByJavaScript = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.request = nil;
    self.returnValueBlocksByJavaScript = nil;
    self.javaScripts = nil;
    [super dealloc];
}

@end

static NSMutableDictionary *attributes__;

@interface UIWebView (Spec_Private)
- (void)loadRequest:(NSURLRequest *)request withNavigationType:(UIWebViewNavigationType)navigationType;
- (UIWebViewAttributes *)attributes;
- (void)log:(NSString *)message, ...;
@end

@implementation UIWebView (Spec)

+ (void)initialize {
    attributes__ = (NSMutableDictionary *)CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CFDictionaryAddValue((CFMutableDictionaryRef)attributes__, self, [[UIWebViewAttributes alloc] init]);
    }
    return self;
}

- (void)dealloc {
    UIWebViewAttributes const *attributes = CFDictionaryGetValue((CFMutableDictionaryRef)attributes__, self);
    [attributes release];
    CFDictionaryRemoveValue((CFMutableDictionaryRef)attributes__, self);
    [super dealloc];
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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (CGRect)frame {
    return super.frame;
}

#pragma mark Method overrides
- (void)loadRequest:(NSURLRequest *)request {
    [self log:@"loadRequest: %@", request];

    [self loadRequest:request withNavigationType:UIWebViewNavigationTypeOther];
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
    return [attributes__ objectForKey:self];
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
