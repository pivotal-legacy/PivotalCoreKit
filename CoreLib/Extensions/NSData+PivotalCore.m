#import <CommonCrypto/CommonDigest.h>
#import "NSData+PivotalCore.h"

@implementation NSData (PivotalCore)

+ (id)dataWithSHA1HashOfString:(NSString *)string {
    return [[[[self class] alloc] initWithSHA1HashOfString:string] autorelease];
}

- (id)initWithSHA1HashOfString:(NSString *)string {
    size_t bytesLength = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char bytes[bytesLength];
    [string getBytes:bytes maxLength:bytesLength usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, bytesLength) remainingRange:NULL];

    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(bytes, bytesLength, digest);
    return [self initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

@end
