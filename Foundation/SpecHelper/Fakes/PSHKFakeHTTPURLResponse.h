#import <Foundation/Foundation.h>

@interface PSHKFakeHTTPURLResponse : NSHTTPURLResponse

- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBody:(NSString *)body;
- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBodyData:(NSData *)body;

@property (assign, readonly) NSInteger statusCode;
@property (copy, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, retain, readonly) NSData *bodyData;
- (NSCachedURLResponse *)asCachedResponse;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName statusCode:(int)statusCode;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName;

@end
