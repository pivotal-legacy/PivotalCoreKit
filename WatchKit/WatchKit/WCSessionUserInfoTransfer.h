#import <Foundation/Foundation.h>
#import "PCKMessageCapturer.h"

NS_ASSUME_NONNULL_BEGIN

/** Used to track a user info dictionary being transferred.
 */
NS_CLASS_AVAILABLE_IOS(9_0)

@interface WCSessionUserInfoTransfer : PCKMessageCapturer

@property (nonatomic, readonly, getter=isCurrentComplicationInfo) BOOL currentComplicationInfo __WATCHOS_UNAVAILABLE;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *userInfo;
@property (nonatomic, readonly, getter=isTransferring) BOOL transferring;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END