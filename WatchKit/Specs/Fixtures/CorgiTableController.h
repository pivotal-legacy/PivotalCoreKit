#import <WatchKit/WatchKit.h>


@class WKInterfaceTable;


@interface CorgiTableController : WKInterfaceController

@property (weak, nonatomic, readonly) WKInterfaceTable *table;

@end
