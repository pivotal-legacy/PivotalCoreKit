#import "PCKResponseParser.h"
#import "PCKParser.h"

@interface PCKResponseParser ()

@property (nonatomic, retain) id<PCKParser> parser;
@property (nonatomic, assign) id<NSURLConnectionDelegate> delegate;

@end

@implementation PCKResponseParser

@synthesize parser = parser_, delegate = delegate_;

- (id)initWithParser:(id<PCKParser>)parser andDelegate:(id<NSURLConnectionDelegate>)delegate {
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

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([self.delegate respondsToSelector:_cmd]) {
        [(id)self.delegate connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.parser parseChunk:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:_cmd]) {
        [(id)self.delegate connectionDidFinishLoading:connection];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate connection:connection didFailWithError:error];
}

@end
