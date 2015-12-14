#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, PCKFakeSegueType) {
    PCKFakeSegueTypePush,
    PCKFakeSegueTypeModal
};


NS_ASSUME_NONNULL_BEGIN

@interface PCKFakeSegue : NSObject

@property (nonatomic, copy, readonly) NSString *destinationIdentifier;
@property (nonatomic, readonly) PCKFakeSegueType type;

- (instancetype)initWithDestinationIdentifier:(NSString *)destinationIdentifier
                                         type:(PCKFakeSegueType)type;

@end

NS_ASSUME_NONNULL_END
