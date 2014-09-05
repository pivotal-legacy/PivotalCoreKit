#import <Foundation/Foundation.h>
#import "NSString+PivotalCore.h"

@implementation NSString (PivotalCore)

+ (id)stringWithBase64EncodedData:(NSData *)data DEPRECATED_ATTRIBUTE {
    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        return [data base64EncodedStringWithOptions:0];
    } else {
        return [data base64Encoding];
    }
}

- (id)initWithBase64EncodedData:(NSData *)data DEPRECATED_ATTRIBUTE {
    self = [self init];
    [self release];

    if ([data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        return [[data base64EncodedStringWithOptions:0] retain];
    } else {
        return [[data base64Encoding] retain];
    }
}

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding includeAll:(BOOL)includeAll {
    if (!includeAll) {
        return [self stringByAddingPercentEscapesUsingEncoding:encoding];
    }
    CFStringEncoding newEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    NSString *escapedUrlString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)self,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]~",
                                                                                     newEncoding);
    return [escapedUrlString autorelease];
}

- (NSString *)stringByCamelizing {
    NSMutableString *camelized = [NSMutableString string];

    for (NSUInteger i = 0; i < [self length]; ++i) {
        unichar oneChar = [self characterAtIndex:i];
        if (i > 0 && ([self characterAtIndex:i - 1] == '_')) {
            [camelized appendString:[[NSString stringWithFormat:@"%C", oneChar] uppercaseString]];
        } else if (oneChar != '_') {
            [camelized appendFormat:@"%C", oneChar];
        }
    }

    return [camelized stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)isBlank {
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (trimmedString.length == 0);
}

- (BOOL)isValidEmailAddress {
    // From http://www.regular-expressions.info/email.html
    NSString *pattern = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)\\b";
    NSRegularExpression *validator = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [validator numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

@end
