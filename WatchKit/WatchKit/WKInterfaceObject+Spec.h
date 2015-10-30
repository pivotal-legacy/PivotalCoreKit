#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceObject (Spec)

@property (nonatomic, readonly) BOOL isHidden;
@property (nonatomic, readonly) CGFloat alpha;

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@end

NS_ASSUME_NONNULL_END
