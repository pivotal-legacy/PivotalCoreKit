#import <Foundation/Foundation.h>


@interface InterfaceControllerLoader : NSObject

-(id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                identifier:(NSString *)objectID;

@end
