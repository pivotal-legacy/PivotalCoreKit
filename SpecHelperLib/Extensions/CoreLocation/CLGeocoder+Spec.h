#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (Spec)

- (void)completeGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeGeocodeWithError:(NSError *)error;

@end
