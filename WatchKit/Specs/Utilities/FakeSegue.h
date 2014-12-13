#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, FakeSegueType) {
    FakeSegueTypePush,
    FakeSegueTypeModal
};


@interface FakeSegue : NSObject

@property (nonatomic, copy, readonly) NSString *destinationIdentifier;
@property (nonatomic, readonly) FakeSegueType type;

- (instancetype)initWithDestinationIdentifier:(NSString *)destinationIdentifier
                                         type:(FakeSegueType)type;

@end
