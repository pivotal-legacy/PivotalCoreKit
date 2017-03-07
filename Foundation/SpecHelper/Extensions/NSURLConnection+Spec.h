#import <Foundation/Foundation.h>

@class PSHKFakeHTTPURLResponse;

NS_ASSUME_NONNULL_BEGIN

@interface NSURLConnection (Spec)

+ (NSArray *)connections;
+ (nullable NSURLConnection *)connectionForPath:(NSString *)path;
+ (void)fetchAllPendingConnectionsSynchronouslyWithTimeout:(NSTimeInterval)timeout __attribute__((deprecated));
+ (void)resetAll;

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly, nullable) id delegate;

// Please use -receiveResponse: rather than -returnResponse:.
- (void)returnResponse:(PSHKFakeHTTPURLResponse *)response __attribute__((deprecated));

- (void)receiveResponse:(PSHKFakeHTTPURLResponse *)response;
- (void)receiveSuccesfulResponseWithBody:(NSString *)responseBody;

- (void)failWithError:(NSError *)error;
- (void)failWithError:(NSError *)error data:(NSData *)data;
- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential;

// Perform synchronous network requests
- (nullable NSData *)fetchSynchronouslyWithTimeout:(NSTimeInterval)timeout __attribute__((deprecated));

@end

NS_ASSUME_NONNULL_END
