#import "NSURLRequest+Spec.h"

@implementation NSURLRequest (Spec)

- (NSString *)HTTPBodyAsString {
    return [[[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding] autorelease];
}

@end
