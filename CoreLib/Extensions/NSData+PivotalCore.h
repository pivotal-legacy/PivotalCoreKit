#import <Foundation/NSData.h>

@interface NSData (PivotalCore)
+ (id)dataWithSHA1HashOfString:(NSString *)string;
- (id)initWithSHA1HashOfString:(NSString *)string;

- (NSString *)hexadecimalString;
@end
