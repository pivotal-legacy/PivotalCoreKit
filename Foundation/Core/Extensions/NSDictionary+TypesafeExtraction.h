#import <Foundation/Foundation.h>

@interface NSDictionary (TypesafeExtraction)

- (id)objectForKey:(id)key requiredType:(Class)type;

- (NSString *)stringObjectForKey:(id)key;
- (NSNumber *)numberObjectForKey:(id)key;
- (NSDate *)dateObjectForKey:(id)key;
- (NSDate *)dateObjectForKey:(id)key formatter:(NSDateFormatter *)formatter;
- (NSArray *)arrayObjectForKey:(id)key;
- (NSArray *)arrayObjectForKey:(id)key constrainedToElementsOfClass:(Class)klass;
- (NSDictionary *)dictionaryObjectForKey:(id)key;
- (NSURL *)URLObjectForKey:(id)key;

- (float)floatValueForKey:(id)key;
- (NSInteger)integerValueForKey:(id)key;
- (BOOL)boolValueForKey:(id)key;

@end
