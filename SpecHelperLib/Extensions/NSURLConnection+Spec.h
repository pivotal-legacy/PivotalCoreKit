#import <Foundation/Foundation.h>
#import "PCKHTTPConnectionDelegate.h"

@class PSHKFakeHTTPURLResponse;

@interface NSURLConnection (Spec)

+ (NSArray *)connections;
+ (void)resetAll;

- (NSURLRequest *)request;
- (id)delegate;

// Please use -receiveResponse: rather than -returnResponse:.
- (void)returnResponse:(PSHKFakeHTTPURLResponse *)response __attribute__((deprecated));

- (void)receiveResponse:(PSHKFakeHTTPURLResponse *)response;
- (void)failWithError:(NSError *)error;
- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential;

@end
