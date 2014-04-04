#import "NSDictionary+QueryString.h"
#import "NSString+PivotalCore.h"

@implementation NSDictionary (QueryString)
+ (NSDictionary *)dictionaryFromQueryString:(NSString *)queryString {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[queryString componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString *entry, NSUInteger idx, BOOL * stop) {
        NSArray *keyValue = [entry componentsSeparatedByString:@"="];
        NSString *key = [keyValue[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [keyValue[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[key] = value;
    }];
    return [NSDictionary dictionaryWithDictionary:params];
}

- (NSString *)queryString {
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString* key in self) {
        NSString *value = [self objectForKey: key];
        NSString *part = [NSString
                          stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding includeAll:YES],
                          [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding includeAll:YES]
                          ];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];}
@end
