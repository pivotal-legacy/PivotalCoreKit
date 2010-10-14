#import "FakeConnectionDelegate.h"

@implementation FakeConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {}
- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request { return nil; }
@end
