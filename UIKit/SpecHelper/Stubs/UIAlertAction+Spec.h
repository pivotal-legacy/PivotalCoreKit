#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PCKAlertActionHandler)(UIAlertAction * __nonnull action);

@interface UIAlertAction (Spec)

@property (nonatomic, readonly, nullable) PCKAlertActionHandler handler;

@end

NS_ASSUME_NONNULL_END
