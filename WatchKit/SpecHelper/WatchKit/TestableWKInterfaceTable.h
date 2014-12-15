#import <Foundation/Foundation.h>

@protocol TestableWKInterfaceTable <NSObject>


@optional

@property(nonatomic,readonly) NSInteger numberOfRows;

- (void)setRowTypes:(NSArray *)rowTypes;
- (void)setNumberOfRows:(NSInteger)numberOfRows withRowType:(NSString *)rowType;

- (void)insertRowsAtIndexes:(NSIndexSet *)rows withRowType:(NSString *)rowType;
- (void)removeRowsAtIndexes:(NSIndexSet *)rows;

- (void)scrollToRowAtIndex:(NSInteger)index;

@end
