#import <Foundation/Foundation.h>

typedef void (^PCKConnectionDelegateWrapperCompletionBlock)(NSData *);

@interface PCKConnectionDelegateWrapper : NSObject <NSURLConnectionDataDelegate>

+ (PCKConnectionDelegateWrapper *)wrapperForConnection:(NSURLConnection *)connection
                                    completionCallback:(PCKConnectionDelegateWrapperCompletionBlock)completionCallback;

@end
