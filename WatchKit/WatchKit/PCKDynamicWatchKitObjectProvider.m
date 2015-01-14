#import "PCKDynamicWatchKitObjectProvider.h"
#import "WKInterfaceObject.h"
#import "WKInterfaceController.h"


@interface PCKDynamicWatchKitObjectProvider ()

@property (nonatomic) NSMutableSet *propertiesThatMayOrMayNotBeWeaklyRetainedByTheirInterfaceControllers;

@end


@implementation PCKDynamicWatchKitObjectProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.propertiesThatMayOrMayNotBeWeaklyRetainedByTheirInterfaceControllers = [NSMutableSet set];
    }
    return self;
}

- (id)interfaceControllerWithProperties:(NSDictionary *)controllerProperties
{
    NSString *controllerClassName = controllerProperties[@"controllerClass"];
    Class interfaceControllerClass = NSClassFromString(controllerClassName);
    if (!interfaceControllerClass) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No class named '%@' exists in the current target.  Did you forget to add it to the test target?", controllerClassName];
    }
    id interfaceController = [interfaceControllerClass alloc];
    
    NSDictionary *rootItems = controllerProperties[@"items"];
    for (NSDictionary *itemDictionary in rootItems) {
        [self interfaceObjectWithItemDictionary:itemDictionary
                            interfaceController:interfaceController];
    }

    return [interfaceController init];
}

#pragma mark - Private

- (WKInterfaceObject *)interfaceObjectWithItemDictionary:(NSDictionary *)properties
                                     interfaceController:(WKInterfaceController *)interfaceController
{
    NSString *propertyType = properties[@"type"];
    NSString *propertyClassName = [NSString stringWithFormat:@"WKInterface%@", [propertyType capitalizedString]];
    Class propertyClass = NSClassFromString(propertyClassName);
    if (!propertyClass) {
        [NSException raise:NSInvalidArgumentException format:@"No property class found for '%@'.", propertyClassName];
        return nil;
    }
    WKInterfaceObject *interfaceObject = [[propertyClass alloc] init];

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
                    WKInterfaceObject *object = [self interfaceObjectWithItemDictionary:item
                                                                    interfaceController:interfaceController];
                    [value addObject:object];
                }
                [interfaceObject setValue:value forKey:name];
            } else {
                NSString *value = propertyValues[name];
                [interfaceObject setValue:value forKey:name];
            }
        }
    }

    NSString *propertyKey = properties[@"property"];
    if (propertyKey) {
        [interfaceController setValue:interfaceObject forKey:propertyKey];
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
