#import <Foundation/Foundation.h>


@class WKInterfaceController;


@protocol TestableWKInterfaceController <NSObject>

- (id)initWithContext:(id)context;
- (void)willActivate;
- (void)didDeactivate;
- (void)pushControllerWithName:(NSString *)name context:(id)context;
- (void)presentControllerWithName:(NSString *)name context:(id)context;

@optional

- (WKInterfaceController *)childController;
- (WKInterfaceController *)presentedController;

@end
