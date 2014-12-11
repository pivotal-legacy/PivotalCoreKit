#import <Foundation/Foundation.h>


@class WKInterfaceController;


@protocol TestableWKInterfaceController <NSObject>

- (id)initWithContext:(id)context;
- (void)pushControllerWithName:(NSString *)name context:(id)context;

@optional

- (WKInterfaceController *)childController;

@end
