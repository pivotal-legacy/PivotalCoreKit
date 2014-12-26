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
@property (nonatomic) NSMutableDictionary *rowControllers;

@end


@implementation WKInterfaceTable

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rowControllers = [NSMutableDictionary dictionary];
    }
    return self;
}

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

- (id)rowControllerAtIndex:(NSInteger)index
{
    return self.rowControllers[@(index)];
}

- (void)stubRowController:(id)rowController atIndex:(NSUInteger)index
{
    self.rowControllers[@(index)] = rowController;
}

@end
