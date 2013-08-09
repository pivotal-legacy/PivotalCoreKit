#import "NSURL+Spec.h"

@implementation NSURL (Spec)
-(NSDictionary *)queryComponents {
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    
    for(NSString *keyValuePairString in [self.query componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString *key = [self CGIDecodedStringForString:[keyValuePairArray objectAtIndex:0]];
        NSString *value = [self CGIDecodedStringForString:[keyValuePairArray objectAtIndex:1]];
        id results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
        if(!results) {
            queryComponents[key] = value;
        } else {
            if ([results isKindOfClass:[NSString class]]) {
                NSString *existing = (NSString *)results;
                results = [@[existing] mutableCopy];
                queryComponents[key] = results;
                [results release];
            }
            [(NSMutableArray *)queryComponents[key] addObject:value];
        }
    }
    return queryComponents;
}

- (NSString *)CGIDecodedStringForString:(NSString *)string {
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
