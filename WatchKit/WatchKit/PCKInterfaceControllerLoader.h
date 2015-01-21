#import <Foundation/Foundation.h>


@interface PCKInterfaceControllerLoader : NSObject

- (id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                 identifier:(NSString *)objectID
                                     bundle:(NSBundle *)bundle;

- (id)dynamicNotificationInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                          notificationCategory:(NSString *)notificationCategoryOrNil
                                                        bundle:(NSBundle *)bundle;

- (id)glanceInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                       identifier:(NSString *)objectID
                                           bundle:(NSBundle *)bundle;

@end
