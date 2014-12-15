#import "WKInterfaceTable.h"


@interface WKInterfaceTable ()

@property (nonatomic) NSDictionary *rows;

@end


@implementation WKInterfaceTable

#pragma mark - <TestableWKInterfaceTable>

- (NSInteger)numberOfRows
{
    return self.rows.count;
}

@end
