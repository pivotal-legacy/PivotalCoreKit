#import <Foundation/Foundation.h>

@protocol NSURLConnectionDelegate;

typedef void (^RequestSetupBlock)(NSMutableURLRequest *);

@interface PCKHTTPInterface : NSObject {
    NSURL *baseURLAndPath_, *baseSecureURLAndPath_;
    NSMutableArray *activeConnections_;
}

@property (nonatomic, readonly) NSArray *activeConnections;

#pragma mark protected
- (NSURLConnection *)connectionForPath:(NSString *)path secure:(BOOL)secure andDelegate:(id<NSURLConnectionDelegate>)delegate;
- (NSURLConnection *)connectionForPath:(NSString *)path secure:(BOOL)secure andDelegate:(id<NSURLConnectionDelegate>)delegate withRequestSetup:(RequestSetupBlock)requestSetup;

- (NSMutableURLRequest *)requestForPath:(NSString *)path secure:(BOOL)secure;
- (NSURLConnection *)connectionForRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate;

@end

@interface PCKHTTPInterface (SubclassDelegation)
// required
- (NSString *)host;
// optional
- (NSString *)baseURLPath;
@end
