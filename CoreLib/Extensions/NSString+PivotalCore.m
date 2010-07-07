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

    int numberOfChunks = [data length] / 3;
    int extraBytes = [data length] % 3;

    int resultLength = 4 * numberOfChunks + (extraBytes ? 4 : 0);
    char result[resultLength];

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

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding newEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    NSString *escapedUrlString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                     (CFStringRef)self,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]~",
                                                                                     newEncoding);
    return [escapedUrlString autorelease];
}

@end
