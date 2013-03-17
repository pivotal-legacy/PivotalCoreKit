#import "PCKConnectionDelegateWrapper.h"
#import "NSURLConnection+Spec.h"

@interface PCKConnectionDelegateWrapper ()

@property (nonatomic, assign) NSURLConnection *connection;
@property (nonatomic, copy) PCKConnectionDelegateWrapperCompletionBlock completionCallback;
@property (nonatomic, retain) NSMutableData *data;

@end

@implementation PCKConnectionDelegateWrapper

@synthesize connection = _connection;

+ (PCKConnectionDelegateWrapper *)wrapperForConnection:(NSURLConnection *)connection
                                    completionCallback:(PCKConnectionDelegateWrapperCompletionBlock)completionCallback
{
    return [[[PCKConnectionDelegateWrapper alloc] initWithConnection:connection
                                                  completionCallback:completionCallback] autorelease];
}

- (id)initWithConnection:(NSURLConnection *)connection
      completionCallback:(PCKConnectionDelegateWrapperCompletionBlock)completionCallback
{
    if (self = [super init]) {
        self.connection = connection;
        self.completionCallback = completionCallback;
        self.data = [NSMutableData data];
    }
    
    return self;
}

- (void)dealloc
{
    self.completionCallback = nil;
    [super dealloc];
}

- (id)delegate
{
    return self.connection.delegate;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [self.delegate methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = invocation.selector;
    if ([self.delegate respondsToSelector:selector]) {
        if (invocation.methodSignature.numberOfArguments > 2) {
            [invocation setArgument:&_connection atIndex:2];
        }
        [invocation invokeWithTarget:self.delegate];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate connection:self.connection didReceiveData:data];
    }
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate connection:self.connection didFailWithError:error];
    }
    self.completionCallback(nil);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate connectionDidFinishLoading:self.connection];
    }
    self.completionCallback(self.data);
}

@end
