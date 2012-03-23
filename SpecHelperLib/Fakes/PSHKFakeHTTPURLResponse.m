#import "PSHKFakeHTTPURLResponse.h"

@interface PSHKFakeHTTPURLResponse ()

@property (nonatomic, assign, readwrite) int statusCode;
@property (nonatomic, retain, readwrite) NSDictionary *allHeaderFields;
@property (nonatomic, copy, readwrite) NSString *body;

@end

@implementation PSHKFakeHTTPURLResponse

@synthesize statusCode = statusCode_, allHeaderFields = headers_, body = body_;

- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBody:(NSString *)body {
    if ((self = [super initWithURL:[NSURL URLWithString:@"http://www.example.com"] MIMEType:@"application/wibble" expectedContentLength:-1 textEncodingName:nil])) {
        self.statusCode = statusCode;
        self.allHeaderFields = headers;
        self.body = body;
    }
    return self;
}

- (void)dealloc {
    [headers_ release];
    [body_ release];
    [super dealloc];
}

- (NSCachedURLResponse *)asCachedResponse {
    NSData *responseData = [self.body dataUsingEncoding:NSUTF8StringEncoding];
    return [[[NSCachedURLResponse alloc] initWithResponse:self data:responseData] autorelease];
}

@end
