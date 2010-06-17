#import <Foundation/Foundation.h>

@interface PSHKFakeHTTPURLResponse : NSURLResponse {
    int statusCode_;
    NSDictionary *headers_;
    NSString *body_;
}

- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBody:(NSString *)body;

@property (nonatomic, readonly) int statusCode;
@property (nonatomic, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, readonly) NSString *body;

@end
