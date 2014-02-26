#import "PCKHTTPInterface.h"
#import "PCKHTTPConnection.h"

@interface PCKHTTPInterface (private)
- (NSURL *)urlForPath:(NSString *)path secure:(BOOL)secure;
- (NSURL *)baseURLAndPathWithSecurity:(BOOL)secure;
- (NSURL *)newBaseURLAndPathWithProtocol:(NSString *)protocol;
@end

@implementation PCKHTTPInterface

@synthesize activeConnections = activeConnections_;

- (id)init {
    if ((self = [super init])) {
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
    NSMutableURLRequest *request = [self requestForPath:path secure:secure];
    if (requestSetup) {
        requestSetup(request);
    }
    return [self connectionForRequest:request delegate:delegate];
}

- (NSMutableURLRequest *)requestForPath:(NSString *)path secure:(BOOL)secure {
    return [[[NSMutableURLRequest alloc] initWithURL:[self urlForPath:path secure:secure]] autorelease];
}

- (NSURLConnection *)connectionForRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    NSURLConnection *connection = [[[PCKHTTPConnection alloc] initWithHTTPInterface:self forRequest:request andDelegate:delegate] autorelease];
    [activeConnections_ addObject:connection];
    return connection;
}

#pragma mark friend interface for PCKHTTPConnection
- (void)clearConnection:(NSURLConnection *)connection {
    [activeConnections_ removeObject:connection];
}

#pragma mark Private interface
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
    if ([self respondsToSelector:@selector(baseURLPath)]) {
        [baseURLString appendString:[self baseURLPath]];
    }
    NSURL *url = [[NSURL alloc] initWithString:baseURLString];
    [baseURLString release];
    return url;
}

@end
