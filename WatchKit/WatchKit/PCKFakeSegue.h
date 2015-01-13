#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, PCKFakeSegueType) {
    PCKFakeSegueTypePush,
    PCKFakeSegueTypeModal
};


@interface PCKFakeSegue : NSObject

@property (nonatomic, copy, readonly) NSString *destinationIdentifier;
@property (nonatomic, readonly) PCKFakeSegueType type;

- (instancetype)initWithDestinationIdentifier:(NSString *)destinationIdentifier
                                         type:(PCKFakeSegueType)type;

@end
