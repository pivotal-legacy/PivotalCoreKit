#import <Foundation/Foundation.h>

@interface PSHKFakeHTTPURLResponse : NSURLResponse

- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBody:(NSString *)body;
- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBodyData:(NSData *)body;

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, retain, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, retain, readonly) NSData *bodyData;
- (NSCachedURLResponse *)asCachedResponse;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName statusCode:(int)statusCode;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName;

@end
