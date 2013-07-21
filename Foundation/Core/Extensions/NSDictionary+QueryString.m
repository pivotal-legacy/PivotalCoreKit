#import "NSDictionary+QueryString.h"
#import "NSString+PivotalCore.h"

@implementation NSDictionary (QueryString)
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
