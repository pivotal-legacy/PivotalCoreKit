#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKPrototypeCellInstantiatingDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>
- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

- (UITableViewCell *)tableViewCellWithIdentifier:(NSString *)cellIdentifier;
- (UICollectionViewCell *)collectionViewCellWithIdentifier:(NSString *)cellIdentifier;
@end

@interface PCKPrototypeReusableViewInstantiatingDataSource : NSObject <UICollectionViewDataSource>
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
- (UICollectionReusableView *)collectionReusableViewWithIdentifier:(NSString *)viewIdentifier;
@end

NS_ASSUME_NONNULL_END
