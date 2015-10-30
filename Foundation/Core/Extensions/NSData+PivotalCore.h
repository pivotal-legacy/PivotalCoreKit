#import <Foundation/NSData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (PivotalCore)
+ (id)dataWithSHA1HashOfString:(NSString *)string;
- (id)initWithSHA1HashOfString:(NSString *)string;

@property (nonatomic, readonly) NSString *hexadecimalString;

@end

NS_ASSUME_NONNULL_END
