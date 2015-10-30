#import <Foundation/Foundation.h>

@protocol NSURLConnectionDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^RequestSetupBlock)(NSMutableURLRequest * __nonnull);

@interface PCKHTTPInterface : NSObject {
    NSURL *baseURLAndPath_, *baseSecureURLAndPath_;
    NSMutableArray *activeConnections_;
}

@property (nonatomic, readonly) NSArray *activeConnections;

#pragma mark protected
- (NSURLConnection *)connectionForPath:(NSString *)path secure:(BOOL)secure andDelegate:(nullable id<NSURLConnectionDelegate>)delegate;
- (NSURLConnection *)connectionForPath:(NSString *)path secure:(BOOL)secure andDelegate:(nullable id<NSURLConnectionDelegate>)delegate withRequestSetup:(nullable RequestSetupBlock)requestSetup;

- (NSMutableURLRequest *)requestForPath:(NSString *)path secure:(BOOL)secure;
- (NSURLConnection *)connectionForRequest:(NSURLRequest *)request delegate:(nullable id<NSURLConnectionDelegate>)delegate;

@end

@interface PCKHTTPInterface (SubclassDelegation)
// required
- (NSString *)host;
// optional
- (NSString *)baseURLPath;
@end

NS_ASSUME_NONNULL_END
