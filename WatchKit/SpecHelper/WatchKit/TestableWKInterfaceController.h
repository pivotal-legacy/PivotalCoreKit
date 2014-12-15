#import <Foundation/Foundation.h>


@class WKInterfaceController;
@class FakeInterfaceController;


@protocol TestableWKInterfaceController <NSObject>

- (void)awakeWithContext:(id)context;
- (void)willActivate;
- (void)didDeactivate;

@optional

- (NSArray *)sent_messages;
- (void)pushControllerWithName:(NSString *)name context:(id)context;
- (void)presentControllerWithName:(NSString *)name context:(id)context;

@end
