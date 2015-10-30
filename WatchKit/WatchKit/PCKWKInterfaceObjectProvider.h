#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WKInterfaceObject;
@class WKInterfaceController;


@interface PCKWKInterfaceObjectProvider : NSObject

- (WKInterfaceObject *)interfaceObjectWithItemDictionary:(NSDictionary *)properties
                                     interfaceController:(WKInterfaceController *)interfaceController;

@end

NS_ASSUME_NONNULL_END
