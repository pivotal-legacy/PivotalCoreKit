#import "PCKHTTPInterface.h"
#import "NSURLConnectionDelegate.h"

@interface PCKHTTPInterface (PCKHTTPConnectionFriend)
- (void)clearConnection:(NSURLConnection *)connection;
@end

@implementation PCKHTTPConnection

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super initWithRequest:request delegate:self]) {
        interface_ = interface;
        delegate_ = [delegate retain];
    }
    return self;
}

- (void)dealloc {
    [delegate_ release];
    [super dealloc];
}

- (void)cancel {
    [super cancel];

    [interface_ clearConnection:self];
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [delegate_ respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return delegate_;
}

#pragma mark NSURLConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [delegate_ connectionDidFinishLoading:connection];
    [interface_ clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate_ connection:connection didFailWithError:error];
    [interface_ clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([delegate_ respondsToSelector:@selector(connection:didCancelAuthenticationChallenge:)]) {
        [delegate_ connection:connection didCancelAuthenticationChallenge:challenge];
    }
    [interface_ clearConnection:connection];
}

@end

@interface PCKHTTPInterface (private)
- (NSURL *)urlForPath:(NSString *)path secure:(BOOL)secure;
- (NSURL *)baseURLAndPathWithSecurity:(BOOL)secure;
- (NSURL *)newBaseURLAndPathWithProtocol:(NSString *)protocol;
@end

@implementation PCKHTTPInterface

@synthesize activeConnections = activeConnections_;

- (id)init {
    if (self = [super init]) {
        activeConnections_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [activeConnections_ release]; activeConnections_ = nil;
    [baseURLAndPath_ release]; baseURLAndPath_ = nil;
    [baseSecureURLAndPath_ release]; baseSecureURLAndPath_ = nil;
    [super dealloc];
}

- (NSURLConnection *)connectionForPath:(NSString *)path secure:(BOOL)secure andDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionForPath:path secure:secure andDelegate:delegate withRequestSetup:nil];
}

- (NSURLConnection *)connectionForPath:(NSString *)path secure:(BOOL)secure andDelegate:(id<NSURLConnectionDelegate>)delegate withRequestSetup:(RequestSetupBlock)requestSetup {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlForPath:path secure:secure]];
    if (requestSetup) {
        requestSetup(request);
    }
    NSURLConnection *connection = [[PCKHTTPConnection alloc] initWithHTTPInterface:self forRequest:request andDelegate:delegate];
    [activeConnections_ addObject:connection];

    [connection release];
    [request release];

    return connection;
}

#pragma mark friend interface for PCKHTTPConnection

- (void)clearConnection:(NSURLConnection *)connection {
    [activeConnections_ removeObject:connection];
}

#pragma mark private interface

- (NSURL *)urlForPath:(NSString *)path secure:(BOOL)secure {
    return [[[NSURL alloc] initWithString:path relativeToURL:[self baseURLAndPathWithSecurity:secure]] autorelease];
}

- (NSURL *)baseURLAndPathWithSecurity:(BOOL)secure {
    if (secure) {
        if (!baseSecureURLAndPath_) {
            baseSecureURLAndPath_ = [self newBaseURLAndPathWithProtocol:@"https://"];
        }
        return baseSecureURLAndPath_;
    } else {
        if (!baseURLAndPath_) {
            baseURLAndPath_ = [self newBaseURLAndPathWithProtocol:@"http://"];
        }
        return baseURLAndPath_;
    }
}

- (NSURL *)newBaseURLAndPathWithProtocol:(NSString *)protocol {
    NSMutableString *baseURLString = [[NSMutableString alloc] initWithFormat:@"%@%@", protocol, [self host]];
    if ([self respondsToSelector:@selector(basePath)]) {
        [baseURLString appendString:[self basePath]];
    }
    NSURL *url = [[NSURL alloc] initWithString:baseURLString];
    [baseURLString release];
    return url;
}

@end
