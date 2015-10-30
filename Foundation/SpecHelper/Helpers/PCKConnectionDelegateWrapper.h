#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PCKConnectionDelegateWrapperCompletionBlock)(NSData * __nullable);

@interface PCKConnectionDelegateWrapper : NSObject <NSURLConnectionDataDelegate>

+ (PCKConnectionDelegateWrapper *)wrapperForConnection:(NSURLConnection *)connection
                                    completionCallback:(PCKConnectionDelegateWrapperCompletionBlock)completionCallback;

@end

NS_ASSUME_NONNULL_END
