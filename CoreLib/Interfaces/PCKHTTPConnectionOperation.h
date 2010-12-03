#import <Foundation/Foundation.h>
#import "PCKHTTPConnectionDelegate.h"

@class PCKHTTPInterface;

@interface PCKHTTPConnectionOperation : NSOperation <PCKHTTPConnectionDelegate>

- (id)initWithHTTPInterface:(PCKHTTPInterface *)interface forRequest:(NSURLRequest *)request andDelegate:(id<PCKHTTPConnectionDelegate>)delegate;

@end
