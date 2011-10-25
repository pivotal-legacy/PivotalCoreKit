#import <Foundation/Foundation.h>

// NSURLConnectionDelegate exists in iOS5 and 10.7, but not in 10.6.
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070

@protocol NSURLConnectionDelegate <NSObject>
@optional
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end

#endif
#endif
