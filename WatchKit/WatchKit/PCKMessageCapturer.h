#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKMessageCapturer : NSObject

- (NSArray *)sent_messages;
+ (NSArray *)sent_class_messages;

@end

NS_ASSUME_NONNULL_END
