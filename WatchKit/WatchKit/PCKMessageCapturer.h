#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCKMessageCapturer : NSObject

- (NSArray *)sent_messages;
- (void)reset_sent_messages;

+ (NSArray *)sent_class_messages;
+ (void)reset_sent_messages;

@end

NS_ASSUME_NONNULL_END
