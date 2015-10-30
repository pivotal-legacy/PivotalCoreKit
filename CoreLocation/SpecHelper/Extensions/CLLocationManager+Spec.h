#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLocationManager (Spec)

+ (void)setAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus;

@end

NS_ASSUME_NONNULL_END
