#import <Foundation/Foundation.h>


@interface PCKInterfaceControllerLoader : NSObject

-(id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                identifier:(NSString *)objectID
                                    bundle:(NSBundle *)bundle;

@end
