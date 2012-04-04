#import <Foundation/Foundation.h>

@interface PSHKFakeHTTPURLResponse : NSURLResponse

- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBody:(NSString *)body;

@property (nonatomic, assign, readonly) int statusCode;
@property (nonatomic, retain, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, copy, readonly) NSString *body;
- (NSCachedURLResponse *)asCachedResponse;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName statusCode:(int)statusCode;
+ (PSHKFakeHTTPURLResponse *)responseFromFixtureNamed:(NSString *)fixtureName;

@end
