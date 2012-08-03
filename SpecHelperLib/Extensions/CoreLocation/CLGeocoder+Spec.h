#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (Spec)

- (NSString *)addressString;

- (void)completeGeocodeWithPlacemarks:(NSArray *)placemarks;
- (void)completeGeocodeWithError:(NSError *)error;

@end
