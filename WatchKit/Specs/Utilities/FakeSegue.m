#import "FakeSegue.h"


@interface FakeSegue ()

@property (nonatomic, copy) NSString *destinationIdentifier;
@property (nonatomic) FakeSegueType type;

@end


@implementation FakeSegue

- (instancetype)initWithDestinationIdentifier:(NSString *)destinationIdentifier
                                         type:(FakeSegueType)type
{
    self = [super init];
    if (self) {
        self.destinationIdentifier = destinationIdentifier;
        self.type = type;
    }
    return self;
}

@end
