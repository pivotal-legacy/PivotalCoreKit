#import <UIKit/UIKit.h>

@interface SpecCollectionViewPrototypeCellsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@interface SpecCollectionViewCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIView *subview;
@end

@interface SpecCollectionReusableView : UICollectionReusableView
@property (retain, nonatomic) IBOutlet UIView *subview;
@end


@interface SpecTableViewPrototypeCellsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end

@interface SpecTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *subview;
@end
