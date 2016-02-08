#import <UIKit/UIKit.h>

typedef void (^PCKTableViewRowActionHandler)(UITableViewRowAction *action, NSIndexPath *indexPath);

@interface UITableViewRowAction (Spec)

@property (nonatomic, readonly) PCKTableViewRowActionHandler handler;

@end
