#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import "NSData+PivotalCore.h"

@implementation NSData (PivotalCore)

+ (id)dataWithSHA1HashOfString:(NSString *)string {
    return [[[[self class] alloc] initWithSHA1HashOfString:string] autorelease];
}

- (id)initWithSHA1HashOfString:(NSString *)string {
    NSUInteger bytesLength = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char bytes[bytesLength];
    [string getBytes:bytes maxLength:bytesLength usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, bytesLength) remainingRange:NULL];

    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(bytes, (CC_LONG)bytesLength, digest);
    return [self initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];

    if (!dataBuffer) {
        return [NSString string];
    }

    NSUInteger dataLength = [self length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02x", dataBuffer[i]]];
    }

    return [NSString stringWithString:hexString];
}

@end
