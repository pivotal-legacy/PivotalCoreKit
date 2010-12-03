#import "PCKResponseParser.h"
#import "PCKParser.h"

@interface PCKResponseParser ()

@property (nonatomic, retain) id<PCKParser> parser;
@property (nonatomic, assign) id<PCKHTTPConnectionDelegate> delegate;

@end

@implementation PCKResponseParser

@synthesize parser = parser_, delegate = delegate_;

- (id)initWithParser:(id<PCKParser>)parser andDelegate:(id<PCKHTTPConnectionDelegate>)delegate {
    if (self = [super init]) {
        self.parser = parser;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    self.parser = nil;
    [super dealloc];
}

#pragma mark PCKHTTPConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [self.delegate connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.parser parseChunk:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate connectionDidFinishLoading:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate connection:connection didFailWithError:error];
}

@end
