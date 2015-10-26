

#import <Foundation/Foundation.h>
#import "PCKMessageCapturer.h"

NS_ASSUME_NONNULL_BEGIN

/** Contains file information, such as the file's location and optional user info
 */
NS_CLASS_AVAILABLE_IOS(9_0)
@interface WCSessionFile : PCKMessageCapturer
@property (nonatomic, readonly) NSURL *fileURL;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *metadata;
@end

/** Used to track a file being transferred.
 */
NS_CLASS_AVAILABLE_IOS(9_0)
@interface WCSessionFileTransfer : PCKMessageCapturer
@property (nonatomic, readonly) WCSessionFile *file;
@property (nonatomic, readonly, getter=isTransferring) BOOL transferring;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END