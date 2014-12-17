#import "WKInterfaceTable.h"


@interface WKInterfaceTable (Spec)

- (NSInteger)numberOfRows;

- (void)stubRowController:(id)rowController atIndex:(NSUInteger)index;

@end
