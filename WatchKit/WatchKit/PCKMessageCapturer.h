#import <UIKit/UIKit.h>


@interface PCKMessageCapturer : NSObject

- (NSArray *)sent_messages;
- (void)reset_sent_messages;

+ (NSArray *)sent_class_messages;
+ (void)reset_sent_messages;

@end
