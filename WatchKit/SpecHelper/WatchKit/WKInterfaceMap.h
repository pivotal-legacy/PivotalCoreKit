#import <MapKit/MapKit.h>
#import "WKInterfaceObject.h"
#import "WKInterfaceMapPinColor.h"


@interface WKInterfaceMap : WKInterfaceObject

- (void)setVisibleMapRect:(MKMapRect)mapRect;
- (void)setRegion:(MKCoordinateRegion)coordinateRegion;

- (void)addAnnotation:(CLLocationCoordinate2D)location
            withImage:(UIImage *)image
         centerOffset:(CGPoint)offset;
- (void)addAnnotation:(CLLocationCoordinate2D)location
       withImageNamed:(NSString *)name
         centerOffset:(CGPoint)offset;
- (void)addAnnotation:(CLLocationCoordinate2D)location withPinColor:(WKInterfaceMapPinColor)pinColor;

- (void)removeAllAnnotations;

@end
