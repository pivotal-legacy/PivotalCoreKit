#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUUID (Spec)
+ (NSArray *)generatedUUIDs;
+ (void)reset;
@end

NS_ASSUME_NONNULL_END
