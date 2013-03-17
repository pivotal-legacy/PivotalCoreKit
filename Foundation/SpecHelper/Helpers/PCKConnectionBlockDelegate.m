#import "PCKConnectionBlockDelegate.h"

@interface PCKConnectionBlockDelegate ()

@property (nonatomic, copy) PCKConnectionAsynchronousRequestBlock block;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURLResponse *response;

@end

@implementation PCKConnectionBlockDelegate

+ (PCKConnectionBlockDelegate *)delegateWithBlock:(PCKConnectionAsynchronousRequestBlock)block
{
    PCKConnectionBlockDelegate *delegate = [[[PCKConnectionBlockDelegate alloc] init] autorelease];
    
    delegate.block = block;
    delegate.data = [NSMutableData data];
    
    return delegate;
}

- (void)dealloc
{
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.block(self.response, nil, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.block(self.response, self.data, nil);
}

@end
