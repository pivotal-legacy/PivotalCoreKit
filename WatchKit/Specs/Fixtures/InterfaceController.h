#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>


@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic, readonly) WKInterfaceLabel *titleLabel;
@property (weak, nonatomic, readonly) WKInterfaceImage *image;
@property (weak, nonatomic, readonly) WKInterfaceSeparator *separator;

@end
