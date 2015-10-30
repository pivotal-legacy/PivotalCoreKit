#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (QueryString)
+ (NSDictionary *)dictionaryFromQueryString:(NSString *)queryString;
- (NSString *)queryString;
@end

NS_ASSUME_NONNULL_END
