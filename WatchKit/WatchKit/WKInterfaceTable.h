#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceTable : WKInterfaceObject

- (void)setRowTypes:(NSArray<NSString *> *)rowTypes;
- (void)setNumberOfRows:(NSInteger)numberOfRows withRowType:(NSString *)rowType;

@property(nonatomic,readonly) NSInteger numberOfRows;
- (id)rowControllerAtIndex:(NSInteger)index;

- (void)insertRowsAtIndexes:(NSIndexSet *)rows withRowType:(NSString *)rowType;
- (void)removeRowsAtIndexes:(NSIndexSet *)rows;

- (void)scrollToRowAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
