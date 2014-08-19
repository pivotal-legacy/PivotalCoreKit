#import "PCKPrototypeCellInstantiatingDataSource.h"

@interface PCKPrototypeCellInstantiatingDataSource ()
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, assign) UICollectionView *collectionView;

@property (nonatomic, retain) UITableViewCell *tableViewCell;
@property (nonatomic, retain) UICollectionViewCell *collectionViewCell;
@property (nonatomic, retain) UICollectionReusableView *collectionReusableView;

@property (nonatomic, copy) NSString *identifier;
@end

@implementation PCKPrototypeCellInstantiatingDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    if (self = [super init]) {
        _collectionView = collectionView;
        _collectionView.dataSource = self;
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        _tableView = tableView;
        _tableView.dataSource = self;
    }
    return self;
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _collectionView.dataSource = nil;
    [_tableViewCell release];
    [_collectionViewCell release];
    [_collectionReusableView release];
    [_identifier release];
    [super dealloc];
}

- (UITableViewCell *)tableViewCellWithIdentifier:(NSString *)identifier {
    self.identifier = identifier;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];

    return [[self.tableViewCell retain] autorelease];
}

- (UICollectionViewCell *)collectionViewCellWithIdentifier:(NSString *)identifier {
    self.identifier = identifier;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    return [[self.collectionViewCell retain] autorelease];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableViewCell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    return self.tableViewCell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    return self.collectionViewCell;
}

@end


@interface PCKPrototypeReusableViewInstantiatingDataSource ()
@property (nonatomic, assign) UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionReusableView *collectionReusableView;
@property (nonatomic, copy) NSString *identifier;
@end

@implementation PCKPrototypeReusableViewInstantiatingDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    if (self = [super init]) {
        _collectionView = collectionView;
        _collectionView.dataSource = self;
    }
    return self;
}

- (void)dealloc {
    _collectionView.dataSource = nil;
    [_collectionReusableView release];
    [_identifier release];
    [super dealloc];
}

- (UICollectionReusableView *)collectionReusableViewWithIdentifier:(NSString *)identifier {
    self.identifier = identifier;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    return [[self.collectionReusableView retain] autorelease];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath { return nil; }

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    self.collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.identifier forIndexPath:indexPath];
    return self.collectionReusableView;
}

@end
