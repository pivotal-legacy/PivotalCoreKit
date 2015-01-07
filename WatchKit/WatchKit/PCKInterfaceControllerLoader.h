#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, PCKNotificationInterfaceControllerType) {
    PCKNotificationInterfaceControllerTypeStatic,
    PCKNotificationInterfaceControllerTypeDynamic
};


@interface PCKInterfaceControllerLoader : NSObject

-(id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                identifier:(NSString *)objectID
                                    bundle:(NSBundle *)bundle;

-(id)notificationInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                                  type:(PCKNotificationInterfaceControllerType)type
                                                bundle:(NSBundle *)bundle;

@end
