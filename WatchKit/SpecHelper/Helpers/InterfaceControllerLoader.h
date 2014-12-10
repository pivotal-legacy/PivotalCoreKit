#import <Foundation/Foundation.h>


@interface InterfaceControllerLoader : NSObject

+(id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                  objectID:(NSString *)objectID
                                   context:(id)context;

@end
