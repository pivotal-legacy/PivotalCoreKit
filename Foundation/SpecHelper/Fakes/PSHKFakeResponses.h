#import <Foundation/Foundation.h>

@class PSHKFakeHTTPURLResponse;

NS_ASSUME_NONNULL_BEGIN

@interface PSHKFakeResponses : NSObject {
    NSString * request_;
}

+ (id)responsesForRequest:(NSString *)request;
- (id)initForRequest:(NSString *)request;

@property (nonatomic, readonly) PSHKFakeHTTPURLResponse *success;
@property (nonatomic, readonly) PSHKFakeHTTPURLResponse *badRequest;
@property (nonatomic, readonly) PSHKFakeHTTPURLResponse *authenticationFailure;
@property (nonatomic, readonly) PSHKFakeHTTPURLResponse *serverError;
@property (nonatomic, readonly) PSHKFakeHTTPURLResponse *conflict;

- (PSHKFakeHTTPURLResponse *)responseForStatusCode:(int)statusCode;

@end

NS_ASSUME_NONNULL_END
