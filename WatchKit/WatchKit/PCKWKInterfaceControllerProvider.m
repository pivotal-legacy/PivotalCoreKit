#import "PCKWKInterfaceControllerProvider.h"
#import "WKInterfaceObject.h"
#import "WKInterfaceController.h"
#import "PCKWKInterfaceObjectProvider.h"


@interface PCKWKInterfaceControllerProvider ()

@property (nonatomic) PCKWKInterfaceObjectProvider *interfaceObjectProvider;

@end


@implementation PCKWKInterfaceControllerProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interfaceObjectProvider = [[PCKWKInterfaceObjectProvider alloc] init];
    }

    return self;
}

- (WKInterfaceController *)interfaceControllerWithProperties:(NSDictionary *)controllerProperties
{
    NSString *controllerClassName = controllerProperties[@"controllerClass"];
    Class interfaceControllerClass = NSClassFromString(controllerClassName);
    if (!interfaceControllerClass) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No class named '%@' exists in the current target.  Did you forget to add it to the test target?", controllerClassName];
    }

    id interfaceController = [interfaceControllerClass alloc];

    NSArray *rootItems = controllerProperties[@"items"];
    for (NSDictionary *itemDictionary in rootItems) {
        [self.interfaceObjectProvider interfaceObjectWithItemDictionary:itemDictionary
                                                    interfaceController:interfaceController];
    }

    return [interfaceController init];
}

@end
