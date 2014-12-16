#import "WKInterfaceTable.h"


@interface WKInterfaceObject ()

- (void)setRowTypes:(NSArray *)rowTypes NS_REQUIRES_SUPER;
- (void)setNumberOfRows:(NSInteger)numberOfRows withRowType:(NSString *)rowType NS_REQUIRES_SUPER;

- (void)insertRowsAtIndexes:(NSIndexSet *)rows withRowType:(NSString *)rowType NS_REQUIRES_SUPER;
- (void)removeRowsAtIndexes:(NSIndexSet *)rows NS_REQUIRES_SUPER;

- (void)scrollToRowAtIndex:(NSInteger)index NS_REQUIRES_SUPER;

@end


@interface WKInterfaceTable ()

@property (nonatomic) NSDictionary *rows;

@end


@implementation WKInterfaceTable

- (NSInteger)numberOfRows
{
    return self.rows.count;
}

- (void)setRowTypes:(NSArray *)rowTypes
{
    [super setRowTypes:rowTypes];
}

- (void)setNumberOfRows:(NSInteger)numberOfRows withRowType:(NSString *)rowType
{
    [super setNumberOfRows:numberOfRows withRowType:rowType];
}

- (void)insertRowsAtIndexes:(NSIndexSet *)rows withRowType:(NSString *)rowType
{
    [super insertRowsAtIndexes:rows withRowType:rowType];
}

- (void)removeRowsAtIndexes:(NSIndexSet *)rows
{
    [super removeRowsAtIndexes:rows];
}

- (void)scrollToRowAtIndex:(NSInteger)index
{
    [super scrollToRowAtIndex:index];
}

@end
