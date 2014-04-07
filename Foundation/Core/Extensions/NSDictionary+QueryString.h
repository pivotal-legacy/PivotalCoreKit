#import <Foundation/Foundation.h>

@interface NSDictionary (QueryString)
+ (NSDictionary *)dictionaryFromQueryString:(NSString *)queryString;
- (NSString *)queryString;
@end
