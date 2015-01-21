#import "PCKInterfaceControllerLoader.h"
#import "PCKDynamicWatchKitObjectProvider.h"
#import "WKInterfaceLabel+Spec.h"
#import "WKInterfaceLabel.h"
#import "WKInterfaceObject.h"


@implementation PCKInterfaceControllerLoader

- (id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                 identifier:(NSString *)objectID
                                     bundle:(NSBundle *)bundle
{
    NSString *pathForPlist = [bundle pathForResource:storyboardName ofType:@"plist"];
    if (!pathForPlist) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No storyboard named '%@' exists in the test target.  Did you forget to add it?", storyboardName];
        return nil;
    }

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pathForPlist][@"controllers"];
    NSString *controllerID = dictionary[objectID] ? objectID : [NSString stringWithFormat:@"controller-%@", objectID];
    NSDictionary *controllerProperties = dictionary[controllerID];
    if (!controllerProperties) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No interface controller named '%@' exists in the storyboard '%@'.  Please check the storyboard and try again.", objectID, storyboardName];
        return nil;
    }
    
    PCKDynamicWatchKitObjectProvider *provider = [[PCKDynamicWatchKitObjectProvider alloc] init];
    return [provider interfaceControllerWithProperties:controllerProperties];
}

- (id)dynamicNotificationInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                          notificationCategory:(NSString *)notificationCategoryOrNil
                                                        bundle:(NSBundle *)bundle
{
    NSString *processedStoryboardName = [storyboardName stringByAppendingString:@"-notification"];
    NSString *pathForPlist = [bundle pathForResource:processedStoryboardName ofType:@"plist"];

    if (!pathForPlist) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No storyboard named '%@' exists in the test target.  Did you forget to add it?", storyboardName];
        return nil;
    }

    NSDictionary *serializedNotificationControllerStoryboard = [NSDictionary dictionaryWithContentsOfFile:pathForPlist];

    NSString *categoryKey = notificationCategoryOrNil ? notificationCategoryOrNil : @"default";
    NSDictionary *controllerProperties = serializedNotificationControllerStoryboard[@"categories"][categoryKey][@"dynamic"];
    PCKDynamicWatchKitObjectProvider *provider = [[PCKDynamicWatchKitObjectProvider alloc] init];

    return [provider interfaceControllerWithProperties:controllerProperties];
}

- (id)glanceInterfaceControllerWithStoryboardName:(NSString *)storyboardName
                                       identifier:(NSString *)objectID
                                           bundle:(NSBundle *)bundle
{
    NSString *processedStoryboardName = [storyboardName stringByAppendingString:@"-glance"];
    NSString *pathForPlist = [bundle pathForResource:processedStoryboardName ofType:@"plist"];

    if (!pathForPlist) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No storyboard named '%@' exists in the test target.  Did you forget to add it?", storyboardName];
        return nil;
    }

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pathForPlist][@"controllers"];
    NSString *controllerID = dictionary[objectID] ? objectID : [NSString stringWithFormat:@"controller-%@", objectID];
    NSDictionary *controllerProperties = dictionary[controllerID];
    if (!controllerProperties) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No interface controller named '%@' exists in the storyboard '%@'.  Please check the storyboard and try again.", objectID, storyboardName];
        return nil;
    }

    PCKDynamicWatchKitObjectProvider *provider = [[PCKDynamicWatchKitObjectProvider alloc] init];
    return [provider interfaceControllerWithProperties:controllerProperties];
}

@end
