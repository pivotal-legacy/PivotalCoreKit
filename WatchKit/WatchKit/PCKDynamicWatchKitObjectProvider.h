#import <Foundation/Foundation.h>


@class WKInterfaceObject;


@interface PCKDynamicWatchKitObjectProvider : NSObject

- (id)interfaceControllerWithProperties:(NSDictionary *)controllerProperties;
- (WKInterfaceObject *)interfaceObjectWithProperties:(NSDictionary *)properties;

@end
