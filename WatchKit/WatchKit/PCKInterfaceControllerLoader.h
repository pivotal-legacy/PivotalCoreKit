#import <Foundation/Foundation.h>


@interface PCKInterfaceControllerLoader : NSObject

- (id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                 identifier:(NSString *)objectID
                                     bundle:(NSBundle *)bundle;

- (id)dynamicNotificationInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                                        bundle:(NSBundle *)bundle;

- (id)glanceInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                       identifier:(NSString *)objectID
                                           bundle:(NSBundle *)bundle;

@end
