#import <MapKit/MapKit.h>
#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum WKInterfaceMapPinColor : NSInteger {
    WKInterfaceMapPinColorRed,
    WKInterfaceMapPinColorGreen,
    WKInterfaceMapPinColorPurple,
} WKInterfaceMapPinColor;


@interface WKInterfaceMap : WKInterfaceObject

- (void)setVisibleMapRect:(MKMapRect)mapRect;
- (void)setRegion:(MKCoordinateRegion)coordinateRegion;

- (void)addAnnotation:(CLLocationCoordinate2D)location
            withImage:(nullable UIImage *)image
         centerOffset:(CGPoint)offset;
- (void)addAnnotation:(CLLocationCoordinate2D)location
       withImageNamed:(nullable NSString *)name
         centerOffset:(CGPoint)offset;
- (void)addAnnotation:(CLLocationCoordinate2D)location withPinColor:(WKInterfaceMapPinColor)pinColor;

- (void)removeAllAnnotations;

@end

NS_ASSUME_NONNULL_END
