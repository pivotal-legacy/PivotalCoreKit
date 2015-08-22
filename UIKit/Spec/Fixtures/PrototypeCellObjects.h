#import <UIKit/UIKit.h>

@interface SpecCollectionViewPrototypeCellsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@interface SpecCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *subview;
@end

@interface SpecCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *subview;
@end


@interface SpecTableViewPrototypeCellsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@interface SpecTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *subview;
@end
