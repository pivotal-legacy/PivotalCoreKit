#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface WKInterfaceController : NSObject

- (instancetype)initWithContext:(id)context NS_DESIGNATED_INITIALIZER;

- (void)willActivate;
- (void)didDeactivate;

@end
