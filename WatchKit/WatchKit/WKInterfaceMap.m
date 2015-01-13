#import "WKInterfaceMap.h"

@interface WKInterfaceObject ()

- (void)setVisibleMapRect:(MKMapRect)mapRect NS_REQUIRES_SUPER;
- (void)setRegion:(MKCoordinateRegion)coordinateRegion NS_REQUIRES_SUPER;

- (void)addAnnotation:(CLLocationCoordinate2D)location
            withImage:(UIImage *)image
         centerOffset:(CGPoint)offset NS_REQUIRES_SUPER;
- (void)addAnnotation:(CLLocationCoordinate2D)location
       withImageNamed:(NSString *)name
         centerOffset:(CGPoint)offset NS_REQUIRES_SUPER;
- (void)addAnnotation:(CLLocationCoordinate2D)location withPinColor:(WKInterfaceMapPinColor)pinColor NS_REQUIRES_SUPER;

- (void)removeAllAnnotations NS_REQUIRES_SUPER;

@end

@implementation WKInterfaceMap

- (void)setVisibleMapRect:(MKMapRect)mapRect
{
    [super setVisibleMapRect:mapRect];
}

- (void)setRegion:(MKCoordinateRegion)coordinateRegion
{
    [super setRegion:coordinateRegion];
}

- (void)addAnnotation:(CLLocationCoordinate2D)location
            withImage:(UIImage *)image
         centerOffset:(CGPoint)offset
{

    [super addAnnotation:location withImage:image centerOffset:offset];
}

- (void)addAnnotation:(CLLocationCoordinate2D)location
       withImageNamed:(NSString *)name
         centerOffset:(CGPoint)offset
{
    [super addAnnotation:location withImageNamed:name centerOffset:offset];
}

- (void)addAnnotation:(CLLocationCoordinate2D)location withPinColor:(WKInterfaceMapPinColor)pinColor
{
    [super addAnnotation:location withPinColor:pinColor];
}

- (void)removeAllAnnotations
{
    [super removeAllAnnotations];
}

@end
