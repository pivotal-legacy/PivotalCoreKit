#import "PSHKFakeHTTPURLResponse.h"

@implementation PSHKFakeHTTPURLResponse

@synthesize statusCode = statusCode_, allHeaderFields = headers_, body = body_;

- (id)initWithStatusCode:(int)statusCode andHeaders:(NSDictionary *)headers andBody:(NSString *)body {
    if ((self = [super initWithURL:[NSURL URLWithString:@"http://www.example.com"] MIMEType:@"application/wibble" expectedContentLength:-1 textEncodingName:nil])) {
        statusCode_ = statusCode;
        headers_ = headers;
        body_ = [body copy];
    }
    return self;
}

@end
