#import "ConnectionDelegate.h"

@implementation ConnectionDelegate

- (id)init {
    self = [super init];
    if (self) {
        self.data = [NSMutableData data];
    }
    return self;
}


- (NSString *)dataAsString
{
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    if (self.cancelRequestWhenResponseIsReceived) {
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

@end
