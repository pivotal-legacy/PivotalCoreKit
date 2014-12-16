#import <MapKit/MapKit.h>
#import "WKInterfaceMapPinColor.h"


@protocol TestableWKInterfaceMap <NSObject>

@optional

- (void)setVisibleMapRect:(MKMapRect)mapRect;
- (void)setRegion:(MKCoordinateRegion)coordinateRegion;

- (void)addAnnotation:(CLLocationCoordinate2D)location withImage:(UIImage *)image centerOffset:(CGPoint)offset;
- (void)addAnnotation:(CLLocationCoordinate2D)location withImageNamed:(NSString *)name centerOffset:(CGPoint)offset;
- (void)addAnnotation:(CLLocationCoordinate2D)location withPinColor:(WKInterfaceMapPinColor)pinColor;

- (void)removeAllAnnotations;

@end
