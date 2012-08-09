#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (Spec)

- (NSString *)addressString;
- (CLLocation *)location;

- (void)completeGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeReverseGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeGeocodeWithError:(NSError *)error;

@end
