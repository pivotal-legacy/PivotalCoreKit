#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLGeocoder (Spec)

@property (nonatomic, readonly, nullable) NSString *addressString;
@property (nonatomic, readonly, nullable) CLLocation *location;

- (void)completeGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeReverseGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeGeocodeWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
