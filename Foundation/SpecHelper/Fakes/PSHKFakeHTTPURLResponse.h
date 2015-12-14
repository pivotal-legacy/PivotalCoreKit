#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSHKFakeHTTPURLResponse : NSHTTPURLResponse

- (id)initWithStatusCode:(int)statusCode andHeaders:(nullable NSDictionary *)headers andBody:(nullable NSString *)body;
- (id)initWithStatusCode:(int)statusCode andHeaders:(nullable NSDictionary *)headers andBodyData:(nullable NSData *)body;

@property (assign, readonly) NSInteger statusCode;
@property (copy, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, copy, readonly, nullable) NSString *body;
@property (nonatomic, retain, readonly, nullable) NSData *bodyData;
- (NSCachedURLResponse *)asCachedResponse;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName statusCode:(int)statusCode;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName;

@end

NS_ASSUME_NONNULL_END
