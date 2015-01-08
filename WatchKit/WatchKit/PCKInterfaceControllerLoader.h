#import <Foundation/Foundation.h>


@interface PCKInterfaceControllerLoader : NSObject

- (id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                 identifier:(NSString *)objectID
                                     bundle:(NSBundle *)bundle;

- (id)dynamicNotificationInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                                        bundle:(NSBundle *)bundle;

@end
