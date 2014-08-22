#import "PrototypeCellObjects.h"

@implementation SpecCollectionViewPrototypeCellsViewController
- (void)dealloc {
    [_collectionView release];
    [super dealloc];
}
@end


@implementation SpecCollectionViewCell
- (void)dealloc {
    [_subview release];
    [super dealloc];
}
@end


@implementation SpecCollectionReusableView
- (void)dealloc {
    [_subview release];
    [super dealloc];
}
@end


@implementation SpecTableViewPrototypeCellsViewController
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end


@implementation SpecTableViewCell
- (void)dealloc {
    [_subview release];
    [super dealloc];
}
@end