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
    NSDictionary *dictionary = [self dictionaryForStoryboardNamed:storyboardName inBundle:bundle][@"controllers"];
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

- (id)rootInterfaceControllerForStoryboardNamed:(NSString *)storyboardName inBundle:(NSBundle *)bundle {
    NSDictionary *dictionary = [self dictionaryForStoryboardNamed:storyboardName inBundle:bundle];
    NSString *controllerID = dictionary[@"root"];

    if(!controllerID) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No root controller found for storyboard named '%@'.  Did you forget to set it in interface builder?", storyboardName];
        return nil;
    }

    return [self interfaceControllerWithStoryboardName:storyboardName
                                            identifier:controllerID
                                                bundle:bundle];
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

#pragma mark - Private

- (NSDictionary *)dictionaryForStoryboardNamed:(NSString *)storyboardName inBundle:(NSBundle *)bundle {
    NSString *pathForPlist = [bundle pathForResource:storyboardName ofType:@"plist"];
    if (!pathForPlist) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No storyboard named '%@' exists in the test target.  Did you forget to add it?", storyboardName];
        return nil;
    }

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pathForPlist];
    if (!dictionary) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Unreadable plist for the storyboard '%@'.  Please check the storyboard and try again.", storyboardName];
        return nil;
    }
    return dictionary;
}

@end
