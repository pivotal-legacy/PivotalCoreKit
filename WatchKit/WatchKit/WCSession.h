#import "WCDefines.h"
#import "PCKMessageCapturer.h"

NS_ASSUME_NONNULL_BEGIN

@class WCSessionFile, WCSessionFileTransfer, WCSessionUserInfoTransfer;
@protocol WCSessionDelegate;


NS_CLASS_AVAILABLE_IOS(9_0)
@interface WCSession : PCKMessageCapturer

+ (BOOL)isSupported;

+ (WCSession *)defaultSession;

/** A delegate must exist before the session will allow sends. */
@property (nonatomic, weak, nullable) id <WCSessionDelegate> delegate;

/** The default session must be activated on startup before the session will begin receiving delegate callbacks. Calling activate without a delegate set is undefined. */
- (void)activateSession;

/** -------------------------- Background Transfers ------------------------- */

@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *applicationContext;
- (BOOL)updateApplicationContext:(NSDictionary<NSString *, id> *)applicationContext error:(NSError **)error;

/** Stores the most recently received applicationContext from the counterpart app. */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *receivedApplicationContext;


/** The system will enqueue the user info dictionary and transfer it to the counterpart app at an opportune time. The transfer of user info will continue after the sending app has exited. The counterpart app will receive a delegate callback on next launch if the file has successfully arrived. The userInfo dictionary can only accept the property list types.
 */
- (WCSessionUserInfoTransfer *)transferUserInfo:(NSDictionary<NSString *, id> *)userInfo;

/** Enqueues a user info dictionary containing the most current information for an enabled complication. If the app's complication is enabled the system will try to transfer this user info immediately. Once a current complication user info is received the system will launch the Watch App Extension in the background and allow it to update the complication content. If the current user info cannot be transferred (i.e. devices disconnected, out of background launch budget, etc.) it will wait in the outstandingUserInfoTransfers queue until next opportune time. There can only be one current complication user info in the outstandingUserInfoTransfers queue. If a current complication user info is outstanding (waiting to transfer) and -transferCurrentComplicationUserInfo: is called again with new user info, the new user info will be tagged as current and the previously current user info will be untagged. The previous user info will however stay in the queue of outstanding transfers. */
- (WCSessionUserInfoTransfer *)transferCurrentComplicationUserInfo:(NSDictionary<NSString *, id> *)userInfo __WATCHOS_UNAVAILABLE;

/** Returns an array of user info transfers that are still transferring (i.e. have not been cancelled, failed, or been received by the counterpart app).*/
@property (nonatomic, readonly, copy) NSArray<WCSessionUserInfoTransfer *> *outstandingUserInfoTransfers;

/** The system will enqueue the file and transfer it to the counterpart app at an opportune time. The transfer of a file will continue after the sending app has exited. The counterpart app will receive a delegate callback on next launch if the file has successfully arrived. The metadata dictionary can only accept the property list types. */
- (WCSessionFileTransfer *)transferFile:(NSURL *)file metadata:(nullable NSDictionary<NSString *, id> *)metadata;

/** Returns an array of file transfers that are still transferring (i.e. have not been cancelled, failed, or been received by the counterpart app). */
@property (nonatomic, readonly, copy) NSArray<WCSessionFileTransfer *> *outstandingFileTransfers;

/** ------------------------- Interactive Messaging ------------------------- */

/** The counterpart app must be reachable for a send message to succeed. */
@property (nonatomic, readonly, getter=isReachable) BOOL reachable;

@property (nonatomic, readonly) BOOL iOSDeviceNeedsUnlockAfterRebootForReachability __IOS_UNAVAILABLE __WATCHOS_AVAILABLE(2_0);

/** Clients can use this method to send messages to the counterpart app. Clients wishing to receive a reply to a particular message should pass in a replyHandler block. If the message cannot be sent or if the reply could not be received, the errorHandler block will be invoked with an error. If both a replyHandler and an errorHandler are specified, then exactly one of them will be invoked. Messages can only be sent while the sending app is running. If the sending app exits before the message is dispatched the send will fail. If the counterpart app is not running the counterpart app will be launched upon receiving the message (iOS counterpart app only). The message dictionary can only accept the property list types. */
- (void)sendMessage:(NSDictionary<NSString *, id> *)message replyHandler:(nullable void (^)(NSDictionary<NSString *, id> *replyMessage))replyHandler errorHandler:(nullable void (^)(NSError *error))errorHandler;

/** Clients can use this method to send message data. All the policies of send message apply to send message data. Send message data is meant for clients that have an existing transfer format and do not need the convenience of the send message dictionary. */
- (void)sendMessageData:(NSData *)data replyHandler:(nullable void (^)(NSData *replyMessageData))replyHandler errorHandler:(nullable void (^)(NSError *error))errorHandler;

@end
/** ----------------------------- WCSessionDelegate -----------------------------
 *  The session calls the delegate methods when content is received and session
 *  state changes. All delegate methods will be called on the same queue. The
 *  delegate queue is a non-main serial queue. It is the client's responsibility
 *  to dispatch to another queue if neccessary.
 */
@protocol WCSessionDelegate <NSObject>
@optional

/** ------------------------- iOS App State For Watch ------------------------ */

/** Called when any of the Watch state properties change */
- (void)sessionWatchStateDidChange:(WCSession *)session __WATCHOS_UNAVAILABLE;

/** ------------------------- Interactive Messaging ------------------------- */

/** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
- (void)sessionReachabilityDidChange:(WCSession *)session;

/** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message;

/** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler;

/** Called on the delegate of the receiver. Will be called on startup if the incoming message data caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData;

/** Called on the delegate of the receiver when the sender sends message data that expects a reply. Will be called on startup if the incoming message data caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData replyHandler:(void(^)(NSData *replyMessageData))replyHandler;

/** -------------------------- Background Transfers ------------------------- */

/** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext;

/** Called on the sending side after the user info transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the user info finished. */
- (void)session:(WCSession * __nonnull)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(nullable NSError *)error;

/** Called on the delegate of the receiver. Will be called on startup if the user info finished transferring when the receiver was not running. */
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo;

/** Called on the sending side after the file transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the transfer finished. */
- (void)session:(WCSession *)session didFinishFileTransfer:(WCSessionFileTransfer *)fileTransfer error:(nullable NSError *)error;

/** Called on the delegate of the receiver. Will be called on startup if the file finished transferring when the receiver was not running. The incoming file will be located in the Documents/Inbox/ folder when being delivered. The receiver must take ownership of the file by moving it to another location. The system will remove any content that has not been moved when this delegate method returns. */
- (void)session:(WCSession *)session didReceiveFile:(WCSessionFile *)file;


@end
NS_ASSUME_NONNULL_END
