#import <Foundation/Foundation.h>

@class PSHKFakeHTTPURLResponse;

NS_ASSUME_NONNULL_BEGIN

@interface PSHKFakeResponses : NSObject {
    NSString * request_;
}

+ (id)responsesForRequest:(NSString *)request;
- (id)initForRequest:(NSString *)request;

- (PSHKFakeHTTPURLResponse *)success;
- (PSHKFakeHTTPURLResponse *)badRequest;
- (PSHKFakeHTTPURLResponse *)authenticationFailure;
- (PSHKFakeHTTPURLResponse *)serverError;
- (PSHKFakeHTTPURLResponse *)conflict;

- (PSHKFakeHTTPURLResponse *)responseForStatusCode:(int)statusCode;

@end

NS_ASSUME_NONNULL_END
