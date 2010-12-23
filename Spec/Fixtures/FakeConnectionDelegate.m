#import "FakeConnectionDelegate.h"

@implementation FakeConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request { return nil; }
@end
