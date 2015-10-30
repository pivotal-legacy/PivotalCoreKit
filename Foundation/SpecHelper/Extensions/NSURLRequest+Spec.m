#import "NSURLRequest+Spec.h"

@implementation NSURLRequest (Spec)

- (NSString *)HTTPBodyAsString {
    NSData *body = self.HTTPBody;
    return body ? [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease] : nil;
}

@end
