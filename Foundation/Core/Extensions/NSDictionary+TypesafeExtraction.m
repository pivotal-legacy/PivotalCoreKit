#import "NSDictionary+TypesafeExtraction.h"

@implementation NSDictionary (TypesafeExtraction)

- (id)objectForKey:(id)key requiredType:(Class)type {
    id obj = self[key];
    return [obj isKindOfClass:type] ? obj : nil;
}

- (NSString *)stringObjectForKey:(id)key {
    return [self objectForKey:key requiredType:[NSString class]];
}

- (NSNumber *)numberObjectForKey:(id)key {
    NSNumber *numberObject = [self objectForKey:key requiredType:[NSNumber class]];
    if (numberObject) {
        return numberObject;
    }

    NSString *numberString = [self stringObjectForKey:key];
    return ([numberString length] > 0) ? @([numberString doubleValue]) : nil;
}

- (NSDate *)dateObjectForKey:(id)key {
    return [self dateObjectForKey:key formatter:nil];
}

- (NSDate *)dateObjectForKey:(id)key formatter:(NSDateFormatter *)formatter {
    NSDate *date = [self objectForKey:key requiredType:[NSDate class]];
    if (date) {
        return date;
    }

    if (formatter) {
        NSString *dateString = [self objectForKey:key requiredType:[NSString class]];
        if (!dateString) {
            return nil;
        }

        return [formatter dateFromString:dateString];
    } else {
        NSNumber *number = [self numberObjectForKey:key];
        double doubleValue = [number doubleValue];
        return (number && doubleValue!=0.0) ? [NSDate dateWithTimeIntervalSince1970:doubleValue] : nil;
    }
}

- (NSArray *)arrayObjectForKey:(id)key {
    return [self objectForKey:key requiredType:[NSArray class]];
}

- (NSArray *)arrayObjectForKey:(id)key constrainedToElementsOfClass:(Class)klass {
    NSArray *unsafeArray = [self objectForKey:key requiredType:[NSArray class]];
    if (!unsafeArray) { return nil; }

    return [unsafeArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:klass];
    }]];
}

- (NSDictionary *)dictionaryObjectForKey:(id)key {
    return [self objectForKey:key requiredType:[NSDictionary class]];
}

- (NSURL *)URLObjectForKey:(id)key {
    NSURL *url = [self objectForKey:key requiredType:[NSURL class]];
    if (url) { return url; }

    NSString *str = [self objectForKey:key requiredType:[NSString class]];
    return ([str length] > 0) ? [NSURL URLWithString:str] : nil;
}

- (float)floatValueForKey:(id)key {
    NSNumber *numberObject = [self numberObjectForKey:key];
    if (numberObject) {
        return [numberObject floatValue];
    }
    return [[self stringObjectForKey:key] floatValue];
}

- (NSInteger)integerValueForKey:(id)key {
    NSNumber *numberObject = [self numberObjectForKey:key];
    if (numberObject) {
        return [numberObject integerValue];
    }
    return [[self stringObjectForKey:key] integerValue];
}

- (BOOL)boolValueForKey:(id)key {
    NSNumber *numberObject = [self numberObjectForKey:key];
    if (numberObject) {
        return [numberObject boolValue];
    }
    return [[self stringObjectForKey:key] boolValue];
}

@end
