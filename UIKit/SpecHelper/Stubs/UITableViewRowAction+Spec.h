#import <UIKit/UIKit.h>

typedef void (^PCKTableViewRowActionHandler)(UITableViewRowAction *action, NSIndexPath *indexPath);

@interface UITableViewRowAction (Spec)

- (PCKTableViewRowActionHandler)handler;

@end
