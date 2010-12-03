#import <Foundation/Foundation.h>

@class PSHKFakeHTTPURLResponse;

@interface NSURLConnection (Spec)

+ (NSArray *)connections;
+ (void)resetAll;

- (NSURLRequest *)request;
- (id)delegate;

- (void)returnResponse:(PSHKFakeHTTPURLResponse *)response;
- (void)failWithError:(NSError *)error;
- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential;

@end
