#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIActivityViewController (Spec)

@property (nonatomic, readonly) NSArray *activityItems;
@property (nonatomic, readonly, nullable) NSArray *applicationActivities;

@end

NS_ASSUME_NONNULL_END
