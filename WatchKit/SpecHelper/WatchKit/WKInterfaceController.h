#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TestableWKInterfaceController.h"


@interface WKInterfaceController : NSObject <TestableWKInterfaceController>

- (instancetype)initWithContext:(id)context NS_DESIGNATED_INITIALIZER;

- (void)willActivate;
- (void)didDeactivate;

@end
