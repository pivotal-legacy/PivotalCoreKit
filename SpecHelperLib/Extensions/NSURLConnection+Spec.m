#import "NSURLConnection+Spec.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSURLConnectionDelegate.h"

@implementation NSURLConnection (Spec)

static NSMutableArray *connections__;
static NSMutableDictionary *requests__, *delegates__;

+ (void)initialize {
    connections__ = [[NSMutableArray alloc] init];
    requests__ = [[NSMutableDictionary alloc] init];
    delegates__ = [[NSMutableDictionary alloc] init];
}

+ (NSArray *)connections {
    return connections__;
}

+ (void)resetAll {
    [delegates__ removeAllObjects];
    [requests__ removeAllObjects];
    [connections__ removeAllObjects];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    if (self = [super init]) {
        [connections__ addObject:self];

        CFDictionaryAddValue((CFMutableDictionaryRef)requests__, self, request);
        CFDictionaryAddValue((CFMutableDictionaryRef)delegates__, self, delegate);
    }
    return self;
}

- (void)dealloc {
    CFDictionaryRemoveValue((CFMutableDictionaryRef)requests__, self);
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Test HTTP connection for request %@>", [self request]];
}

- (void)cancel {
    [connections__ removeObject:self];
    [requests__ removeObjectForKey:self];
    [delegates__ removeObjectForKey:self];
}

- (NSURLRequest *)request {
    return [requests__ objectForKey:self];
}

- (id<NSURLConnectionDelegate>)delegate {
    return [delegates__ objectForKey:self];
}

- (void)returnResponse:(PSHKFakeHTTPURLResponse *)response {
    id delegate = [self delegate];

    [delegate connection:self didReceiveResponse:response];
    [delegate connection:self didReceiveData:[[response body] dataUsingEncoding:NSUTF8StringEncoding]];
    [delegate connectionDidFinishLoading:self];
}

- (void)failWithError:(NSError *)error {
    [[self delegate] connection:self didFailWithError:error];
}

- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential {
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@"www.example.com" port:0 protocol:@"http" realm:nil authenticationMethod:nil];
    NSURLAuthenticationChallenge *challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:1 failureResponse:nil error:nil sender:nil];
    [protectionSpace release];

    [[self delegate] connection:self didReceiveAuthenticationChallenge:challenge];

    [challenge release];
}

@end
