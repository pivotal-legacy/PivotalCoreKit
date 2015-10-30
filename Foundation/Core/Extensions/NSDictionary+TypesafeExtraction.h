#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (TypesafeExtraction)

- (nullable id)objectForKey:(id)key requiredType:(Class)type;

- (nullable NSString *)stringObjectForKey:(id)key;
- (nullable NSNumber *)numberObjectForKey:(id)key;
- (nullable NSDate *)dateObjectForKey:(id)key;
- (nullable NSDate *)dateObjectForKey:(id)key formatter:(nullable NSDateFormatter *)formatter;
- (nullable NSArray *)arrayObjectForKey:(id)key;
- (nullable NSArray *)arrayObjectForKey:(id)key constrainedToElementsOfClass:(Class)klass;
- (nullable NSDictionary *)dictionaryObjectForKey:(id)key;
- (nullable NSURL *)URLObjectForKey:(id)key;

- (float)floatValueForKey:(id)key;
- (NSInteger)integerValueForKey:(id)key;
- (BOOL)boolValueForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
