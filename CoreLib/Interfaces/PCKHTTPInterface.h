#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnection : NSURLConnection <NSURLConnectionDelegate> {
    PCKHTTPInterface *interface_;
    id<NSURLConnectionDelegate> delegate_;
}

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;
@end


@interface PCKHTTPInterface : NSObject {
    NSURL *baseURLAndPath_, *baseSecureURLAndPath_;
    NSMutableArray *activeConnections_;
}

@property (nonatomic, readonly) NSArray *activeConnections;

#pragma mark protected
- (NSURLConnection *)connectionForPath:(NSString *)path andDelegate:(id<NSURLConnectionDelegate>)delegate secure:(BOOL)secure;
- (NSURLConnection *)connectionForPath:(NSString *)path withHeaders:(NSDictionary *)headers andDelegate:(id<NSURLConnectionDelegate>)delegate secure:(BOOL)secure;

@end

@interface PCKHTTPInterface (SubclassDelegation)
// required
- (NSString *)host;
// optional
- (NSString *)basePath;
@end
