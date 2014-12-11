#import <Foundation/Foundation.h>


@interface InterfaceControllerLoader : NSObject

-(id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                identifier:(NSString *)objectID
                                   context:(id)context;

@end
