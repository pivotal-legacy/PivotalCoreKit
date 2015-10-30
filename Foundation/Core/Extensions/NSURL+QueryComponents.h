#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (QueryComponents)
@property (nonatomic, readonly) NSDictionary *queryComponents;
@end

NS_ASSUME_NONNULL_END
