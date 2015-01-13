#import <WatchKit/WatchKit.h>


@interface GlanceController : WKInterfaceController

@property (weak, nonatomic, readonly) WKInterfaceLabel *titleLabel;
@property (weak, nonatomic, readonly) WKInterfaceLabel *descriptionLabel;

@end
