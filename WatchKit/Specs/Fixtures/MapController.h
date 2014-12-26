#import <WatchKit/WatchKit.h>


@class WKInterfaceMap;


@interface MapController : WKInterfaceController

@property (weak, nonatomic, readonly) WKInterfaceMap *map;

@end
