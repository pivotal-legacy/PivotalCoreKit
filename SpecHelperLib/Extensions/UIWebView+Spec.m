#import "UIWebView+Spec.h"

@interface UIWebViewAttributes : NSObject
@property (nonatomic, assign) id<UIWebViewDelegate> delegate;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, assign) BOOL loading, logging;
@property (nonatomic, retain) NSMutableArray *javaScripts;
@property (nonatomic, retain) NSMutableDictionary *returnValuesByJavaScript;
+ (id)attributes;
@end

@implementation UIWebViewAttributes
@synthesize delegate = delegate_, request = request_, loading = loading_, logging = logging_,
    javaScripts = javaScripts_, returnValuesByJavaScript = returnValuesByJavaScript_;

+ (id)attributes {
    return [[[[self class] alloc] init] autorelease];
}

- (id)init {
    if (self = [super init]) {
        self.javaScripts = [NSMutableArray array];
        self.returnValuesByJavaScript = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.request = nil;
    self.returnValuesByJavaScript = nil;
    self.javaScripts = nil;
    [super dealloc];
}

@end

static NSMutableDictionary *attributes__;

@interface UIWebView (Spec_Private)
- (UIWebViewAttributes *)attributes;
- (void)log:(NSString *)message, ...;
@end

@implementation UIWebView (Spec)

+ (void)initialize {
    attributes__ = [[NSMutableDictionary alloc] init];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CFDictionaryAddValue((CFMutableDictionaryRef)attributes__, self, [UIWebViewAttributes attributes]);
    }
    return self;
}

- (void)dealloc {
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

#pragma mark Method overrides
- (void)loadRequest:(NSURLRequest *)request {
    [self log:@"loadRequest: %@", request];

    if (self.request) {
        NSString *message = [NSString stringWithFormat:@"Attempt to load request: %@ with previously loading request: %@", request, self.request];
        [self log:message];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:message userInfo:nil] raise];
    }

    if ([self.delegate webView:self shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeOther]) {
        [self log:@"Starting load for request: %@", request];
        self.request = request;
        self.loading = YES;
        [self.delegate webViewDidStartLoad:self];
    }
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScript {
    [self.attributes.javaScripts addObject:javaScript];
    return [self.attributes.returnValuesByJavaScript objectForKey:javaScript];
}

#pragma mark Additions
- (void)finishLoad {
    [self log:@"finishLoad, for request: %@", self.request];

    if (!self.request) {
        NSString *message = [NSString stringWithFormat:@"Attempt to finish load of nonexistent request"];
        [self log:message];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:message userInfo:nil] raise];
    }

    [self.delegate webViewDidFinishLoad:self];
    self.loading = NO;
}

- (void)setReturnValue:(NSString *)returnValue forJavaScript:(NSString *)javaScript {
    [self.attributes.returnValuesByJavaScript setObject:returnValue forKey:javaScript];
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
