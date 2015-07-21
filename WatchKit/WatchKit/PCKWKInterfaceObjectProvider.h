#import <Foundation/Foundation.h>


@class WKInterfaceObject;
@class WKInterfaceController;


@interface PCKWKInterfaceObjectProvider : NSObject

- (WKInterfaceObject *)interfaceObjectWithItemDictionary:(NSDictionary *)properties
                                     interfaceController:(WKInterfaceController *)interfaceController;

@end
