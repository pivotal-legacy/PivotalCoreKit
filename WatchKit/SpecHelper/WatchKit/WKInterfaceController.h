#import "MessageCapturer.h"


@interface WKInterfaceController : MessageCapturer

- (void)awakeWithContext:(id)context;
- (void)willActivate;
- (void)didDeactivate;

- (void)pushControllerWithName:(NSString *)name context:(id)context;
- (void)presentControllerWithName:(NSString *)name context:(id)context;

@end
