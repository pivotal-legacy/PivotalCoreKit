#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (Spec)

@property (nonatomic, readonly) NSString *addressString;
@property (nonatomic, readonly) CLLocation *location;

- (void)completeGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeReverseGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeGeocodeWithError:(NSError *)error;

@end
