#import "InterfaceControllerLoader.h"
#import "TestableWKInterfaceController.h"
#import "TestableWKInterfaceLabel.h"
#import "WKInterfaceLabel.h"
#import <objc/runtime.h>


@interface InterfaceControllerLoader ()

@property (nonatomic) NSMutableSet *propertiesThatMayOrMayNotBeWeaklyRetainedByTheirInterfaceControllers;

@end


@implementation InterfaceControllerLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.propertiesThatMayOrMayNotBeWeaklyRetainedByTheirInterfaceControllers = [NSMutableSet set];
    }
    return self;
}
-(id)interfaceControllerWithStoryboardName:(NSString *)storyboardName
                                  objectID:(NSString *)objectID
                                   context:(id)context
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *pathForPlist = [bundle pathForResource:storyboardName ofType:@"plist"];
    if (!pathForPlist) {
        [NSException raise:NSInvalidArgumentException format:@"No storyboard named '%@' exists in the test target.  Did you forget to add it?", storyboardName];
        return nil;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pathForPlist][@"controllers"];
    NSString* controllerID = [NSString stringWithFormat:@"controller-%@", objectID];
    NSDictionary* controllerProperties = dictionary[controllerID];
    if (!controllerProperties) {
        [NSException raise:NSInvalidArgumentException format:@"No interface controller named '%@' exists in the storyboard '%@'.  Please check the storyboard and try again.", objectID, storyboardName];
        return nil;
    }
    
    Class interfaceControllerClass = NSClassFromString(controllerProperties[@"controllerClass"]);
    id interfaceController = [[interfaceControllerClass alloc] initWithContext:context];
    
    NSDictionary *propertyTypes = @{@"label": @"WKInterfaceLabel",
                                    @"image": @"WKInterfaceImage",
                                    @"separator": @"WKInterfaceSeparator",
                                    @"button": @"WKInterfaceButton"};
    NSDictionary *properties = dictionary[controllerID][@"items"];

    for (NSDictionary *propertiesDictionary in properties) {
        NSString *propertyKey = propertiesDictionary[@"property"];
        NSString *propertyType = propertiesDictionary[@"type"];
        NSString *propertyClassName = propertyTypes[propertyType];
        Class propertyClass = NSClassFromString(propertyClassName);
        
        id property = [[propertyClass alloc] init];
        [self.propertiesThatMayOrMayNotBeWeaklyRetainedByTheirInterfaceControllers addObject:property];

        NSMutableDictionary *propertyValues = [propertiesDictionary mutableCopy];
        [propertyValues removeObjectForKey:@"property"];
        [propertyValues removeObjectForKey:@"type"];
        for (NSString *name in propertyValues) {
            NSString *value = propertyValues[name];
            @try {
                [property setValue:value forKey:name];
            }
            @catch (NSException *exception) {
                NSLog(@"Tried to set %@ := %@ on %@", name, value, propertyKey);
            }
        }
        
        [interfaceController setValue:property forKey:propertyKey];
    }
    
    return interfaceController;
    return nil;
}

@end
