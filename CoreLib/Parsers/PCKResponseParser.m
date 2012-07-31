#import "PCKResponseParser.h"
#import "PCKParser.h"

@interface PCKResponseParser ()

@property (nonatomic, retain) id<PCKParser> parser;
@property (nonatomic, retain) id<NSURLConnectionDelegate> connectionDelegate;
@property (nonatomic, assign) id<PCKParserDelegate> successParserDelegate, errorParserDelegate;

@end

@implementation PCKResponseParser

@synthesize parser = parser_
, connectionDelegate = connectionDelegate_
, successParserDelegate = successParserDelegate_
, errorParserDelegate = errorParserDelegate_;

- (id)initWithParser:(id<PCKParser>)parser successParserDelegate:(id<PCKParserDelegate>)successParserDelegate errorParserDelegate:(id<PCKParserDelegate>)errorParserDelegate connectionDelegate:(id<NSURLConnectionDelegate>)connectionDelegate {
    if ((self = [super init])) {
        self.parser = parser;
        self.connectionDelegate = connectionDelegate;
        self.successParserDelegate = successParserDelegate;
        self.errorParserDelegate = errorParserDelegate;
    }
    return self;
}

- (void)dealloc {
    [connectionDelegate_ release];
    [parser_ release];
    [super dealloc];
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([(id)response statusCode] / 100 == 2) {
        [self.parser setDelegate:self.successParserDelegate];
    } else {
        [self.parser setDelegate:self.errorParserDelegate];
    }

    if ([self.connectionDelegate respondsToSelector:_cmd]) {
        [(id)self.connectionDelegate connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.parser parseChunk:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.connectionDelegate respondsToSelector:_cmd]) {
        [(id)self.connectionDelegate connectionDidFinishLoading:connection];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.connectionDelegate connection:connection didFailWithError:error];
}

@end
