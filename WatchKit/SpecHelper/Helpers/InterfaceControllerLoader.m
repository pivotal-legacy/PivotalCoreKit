#import "InterfaceControllerLoader.h"
#import "WKInterfaceLabel+Spec.h"
#import "WKInterfaceLabel.h"
#import <objc/runtime.h>
#import "WKInterfaceObject.h"


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
                                identifier:(NSString *)objectID
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *pathForPlist = [bundle pathForResource:storyboardName ofType:@"plist"];
    if (!pathForPlist) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No storyboard named '%@' exists in the test target.  Did you forget to add it?", storyboardName];
        return nil;
    }

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pathForPlist][@"controllers"];
    NSString* controllerID = dictionary[objectID] ? objectID : [NSString stringWithFormat:@"controller-%@", objectID];
    NSDictionary* controllerProperties = dictionary[controllerID];
    if (!controllerProperties) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No interface controller named '%@' exists in the storyboard '%@'.  Please check the storyboard and try again.", objectID, storyboardName];
        return nil;
    }

    NSString *controllerClassName = controllerProperties[@"controllerClass"];
    Class interfaceControllerClass = NSClassFromString(controllerClassName);
    if (!interfaceControllerClass) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No class named '%@' exists in the current target.  Did you forget to add it to the test target?", controllerClassName];
        return nil;
    }
    id interfaceController = [interfaceControllerClass alloc];

    NSDictionary *properties = dictionary[controllerID][@"items"];
    for (NSDictionary *propertiesDictionary in properties) {
        NSString *propertyKey = propertiesDictionary[@"property"];
        WKInterfaceObject *interfaceObject = [self interfaceObjectWithProperties:propertiesDictionary];
        [interfaceController setValue:interfaceObject forKey:propertyKey];
    }

    return [interfaceController init];
}

#pragma mark - Private

-(WKInterfaceObject *)interfaceObjectWithProperties:(NSDictionary *)properties
{
    NSString *propertyType = properties[@"type"];
    NSString *propertyClassName = [NSString stringWithFormat:@"WKInterface%@", [propertyType capitalizedString]];
    Class propertyClass = NSClassFromString(propertyClassName);
    if (!propertyClass) {
        [NSException raise:NSInvalidArgumentException format:@"No property class found for '%@'.", propertyClassName];
        return nil;
    }
    WKInterfaceObject *interfaceObject = [[propertyClass alloc] init];

    [self.propertiesThatMayOrMayNotBeWeaklyRetainedByTheirInterfaceControllers addObject:interfaceObject];

    NSMutableDictionary *propertyValues = [properties mutableCopy];
    [propertyValues removeObjectForKey:@"property"];
    [propertyValues removeObjectForKey:@"type"];
    for (NSString *name in propertyValues) {
        SEL setterSelector = [self setterNameWithGetterName:name];
        if ([interfaceObject respondsToSelector:setterSelector]) {
            if ([name isEqualToString:@"items"]) {
                NSArray *items = propertyValues[name];
                NSMutableArray *value = [NSMutableArray arrayWithCapacity:items.count];
                for (NSDictionary *item in items) {
                    WKInterfaceObject *object = [self interfaceObjectWithProperties:item];
                    [value addObject:object];
                }
                [interfaceObject setValue:value forKey:name];
            } else {
                NSString *value = propertyValues[name];
                [interfaceObject setValue:value forKey:name];
            }
        }
    }

    return interfaceObject;
}

- (SEL)setterNameWithGetterName:(NSString *)getterName
{
    NSString *capitalizedFirstLetter = [[getterName substringWithRange:NSMakeRange(0, 1)] capitalizedString];
    NSString *remainder = [getterName substringWithRange:NSMakeRange(1, [getterName length] - 1)];
    return NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", capitalizedFirstLetter, remainder]);
}

@end
