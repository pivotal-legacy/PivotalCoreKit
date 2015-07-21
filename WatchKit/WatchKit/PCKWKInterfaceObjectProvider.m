#import "WKInterfaceButton+Spec.h"
#import "WKInterfaceButton.h"
#import "WKInterfaceGroup.h"
#import "WKInterfaceObject.h"
#import "WKInterfaceController.h"
#import "WKInterfaceObject.h"
#import "PCKWKInterfaceControllerProvider.h"
#import "PCKWKInterfaceObjectProvider.h"


@implementation PCKWKInterfaceObjectProvider

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

    NSMutableDictionary *propertiesCopy = [properties mutableCopy];
    [propertiesCopy removeObjectForKey:@"property"];
    [propertiesCopy removeObjectForKey:@"type"];

    for (NSString *name in propertiesCopy) {
        NSString *capitalizedFirstLetter = [[name substringWithRange:NSMakeRange(0, 1)] capitalizedString];
        NSString *remainder1 = [name substringWithRange:NSMakeRange(1, [name length] - 1)];
        SEL setterSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",
                                                                             capitalizedFirstLetter,
                                                                             remainder1]);
        if ([interfaceObject respondsToSelector:setterSelector]) {

            id propertyValue;

            if ([name isEqualToString:@"items"]) {
                NSArray *items = propertiesCopy[name];

                NSMutableArray *interfaceObjects = [NSMutableArray arrayWithCapacity:items.count];
                for (NSDictionary *item in items) {
                    WKInterfaceObject *object = [self interfaceObjectWithItemDictionary:item
                                                                    interfaceController:interfaceController];
                    [interfaceObjects addObject:object];
                }

                NSArray *value = interfaceObjects;

                propertyValue = value;
            }
                
            else if ([name isEqualToString:@"content"]) {

                NSDictionary *groupDictionary = propertiesCopy[name];
                WKInterfaceObject *group = [self interfaceObjectWithItemDictionary:groupDictionary
                                                               interfaceController:interfaceController];
                propertyValue = group;
            }

            else {
                id propertyValueOfSomeKind = propertiesCopy[name];
                propertyValue = propertyValueOfSomeKind;
            }

            [interfaceObject setValue:propertyValue forKey:name];
        }
    }

    NSString *propertyKey = properties[@"property"];
    if (propertyKey) {
        [interfaceController setValue:interfaceObject forKey:propertyKey];
    }

    if ([interfaceObject isKindOfClass:[WKInterfaceButton class]]) {
        WKInterfaceButton *button = (WKInterfaceButton *)interfaceObject;
        button.controller = interfaceController;
    }

    return interfaceObject;
}

@end
