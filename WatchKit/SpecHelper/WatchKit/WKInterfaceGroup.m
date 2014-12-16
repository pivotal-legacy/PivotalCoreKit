#import "WKInterfaceGroup.h"


@interface WKInterfaceGroup ()

@property (nonatomic) NSArray *items;

@end


@implementation WKInterfaceGroup

#pragma mark - NSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

@end
