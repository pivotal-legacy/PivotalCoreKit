#import "PCKFakeSegue.h"


@interface PCKFakeSegue ()

@property (nonatomic, copy) NSString *destinationIdentifier;
@property (nonatomic) PCKFakeSegueType type;

@end


@implementation PCKFakeSegue

- (instancetype)initWithDestinationIdentifier:(NSString *)destinationIdentifier
                                         type:(PCKFakeSegueType)type
{
    self = [super init];
    if (self) {
        self.destinationIdentifier = destinationIdentifier;
        self.type = type;
    }
    return self;
}

@end
