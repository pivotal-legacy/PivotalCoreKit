#import <Foundation/Foundation.h>
#import "NSString+PivotalCore.h"

static const unsigned char BASE64_DICTIONARY[] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (PivotalCore)

+ (id)stringWithBase64EncodedData:(NSData *)data {
    return [[[[self class] alloc] initWithBase64EncodedData:data] autorelease];
}

- (id)initWithBase64EncodedData:(NSData *)data {
    // Based on standard specified in RFC4648: http://tools.ietf.org/html/rfc4648

    size_t numberOfChunks = [data length] / 3;
    size_t extraBytes = [data length] % 3;

    size_t resultLength = 4 * numberOfChunks + (extraBytes ? 4 : 0);
    unsigned char result[resultLength];

    const unsigned char * bytes = [data bytes];
    for (unsigned char chunkIndex = 0; chunkIndex < numberOfChunks; ++chunkIndex) {
        const unsigned char * currentChunk = bytes + chunkIndex * 3;
        result[chunkIndex * 4] = BASE64_DICTIONARY[(*currentChunk & 0xFC) >> 2];
        result[chunkIndex * 4 + 1] = BASE64_DICTIONARY[(*currentChunk & 0x03) << 4 | ((*(currentChunk + 1) & 0xF0) >> 4)];
        result[chunkIndex * 4 + 2] = BASE64_DICTIONARY[((*(currentChunk + 1) & 0x0F) << 2) | ((*(currentChunk + 2) & 0xC0) >> 6)];
        result[chunkIndex * 4 + 3] = BASE64_DICTIONARY[*(currentChunk + 2) & 0x3F];
    }

    if (1 == extraBytes) {
        result[numberOfChunks * 4] = BASE64_DICTIONARY[(*(bytes + numberOfChunks * 3) & 0xFC) >> 2];
        result[numberOfChunks * 4 + 1] = BASE64_DICTIONARY[(*(bytes + numberOfChunks * 3) & 0x03) << 4];
        result[resultLength - 2] = '=';
        result[resultLength - 1] = '=';
    } else if (2 == extraBytes) {
        result[numberOfChunks * 4] = BASE64_DICTIONARY[(*(bytes + numberOfChunks * 3) & 0xFC) >> 2];
        result[numberOfChunks * 4 + 1] = BASE64_DICTIONARY[(*(bytes + numberOfChunks * 3) & 0x03) << 4 | ((*(bytes + numberOfChunks * 3 + 1) & 0xF0) >> 4)];
        result[numberOfChunks * 4 + 2] = BASE64_DICTIONARY[((*(bytes + numberOfChunks * 3 + 1) & 0x0F) << 2)];
        result[resultLength - 1] = '=';
    }

    return [self initWithBytes:result length:resultLength encoding:NSASCIIStringEncoding];
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

- (BOOL)endsWith:(NSString *)ending {
    NSRange range = [self rangeOfString:ending];
    return self.length == (range.location + range.length);
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
