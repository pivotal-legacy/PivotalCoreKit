#import "PCKConnectionBlockDelegate.h"

@interface PCKConnectionBlockDelegate ()

@property (nonatomic, copy) PCKConnectionAsynchronousRequestBlock block;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSOperationQueue *queue;
@end

@implementation PCKConnectionBlockDelegate

+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block {
    return [self delegateWithBlock:block queue:[NSOperationQueue mainQueue]];
}

+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block queue:(NSOperationQueue *)queue {
    PCKConnectionBlockDelegate *delegate = [[[PCKConnectionBlockDelegate alloc] init] autorelease];
    delegate.block = block;
    delegate.data = [NSMutableData data];
    delegate.queue = queue;
    return delegate;
}

- (void)dealloc {
    self.queue = nil;
    self.response = nil;
    self.block = nil;
    self.data = nil;
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([[NSOperationQueue mainQueue] isEqual:self.queue]) {
        self.block(self.response, nil, error);
    } else if (self.queue){
        [self.queue addOperationWithBlock:^{
            self.block(self.response, nil, error);
        }];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([[NSOperationQueue mainQueue] isEqual:self.queue]) {
        self.block(self.response, self.data, nil);
    } else if (self.queue) {
        [self.queue addOperationWithBlock:^{
            self.block(self.response, self.data, nil);
        }];
    }
}

@end
