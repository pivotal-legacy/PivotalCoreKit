#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKInterfaceControllerLoader : NSObject

- (id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                 identifier:(NSString *)objectID
                                     bundle:(nullable NSBundle *)bundle;

- (id)rootInterfaceControllerForStoryboardNamed:(NSString *)storyboardName inBundle:(nullable NSBundle *)bundle;

- (id)dynamicNotificationInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                          notificationCategory:(nullable NSString *)notificationCategoryOrNil
                                                        bundle:(nullable NSBundle *)bundle;

- (id)glanceInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                       identifier:(NSString *)objectID
                                           bundle:(nullable NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
