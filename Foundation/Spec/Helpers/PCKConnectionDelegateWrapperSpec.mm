#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKConnectionDelegateWrapper.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSURLConnection+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKConnectionDelegateWrapperSpec)

describe(@"PCKConnectionDelegateWrapper", ^{
    __block PCKConnectionDelegateWrapper *delegateWrapper;
    __block NSURLConnection *connection;
    __block NSData *receivedData;
    __block id<CedarDouble, NSURLConnectionDataDelegate> delegate;
    __block NSURLConnection *proxyConnection;

    beforeEach(^{
        receivedData = [NSData data];
        delegate = nice_fake_for(@protocol(NSURLConnectionDataDelegate));
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/"]];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        connection = [NSURLConnection connectionWithRequest:request
                                                   delegate:delegate];
        delegateWrapper = [PCKConnectionDelegateWrapper wrapperForConnection:connection
                                                          completionCallback:^(NSData *data) {
                                                              receivedData = data;
                                                          }];
        proxyConnection = [NSURLConnection connectionWithRequest:request
                                                        delegate:delegateWrapper];
#pragma clang diagnostic pop
    });

    context(@"when receiving a message that the delegate responds to", ^{
        it(@"should forward that message to the delegate, passing along the original connection", ^{
            NSURLResponse *response = [[NSURLResponse alloc] init];
            [delegateWrapper connection:proxyConnection
                     didReceiveResponse:response];
            delegate should have_received(@selector(connection:didReceiveResponse:)).with(connection).and_with(response);
        });
    });

    context(@"when receiving data", ^{
        beforeEach(^{
            NSData *data = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
            [delegateWrapper connection:proxyConnection didReceiveData:data];
            delegate should have_received(@selector(connection:didReceiveData:)).with(connection).and_with(data);

            [delegate reset_sent_messages];
            data = [@" World" dataUsingEncoding:NSUTF8StringEncoding];
            [delegateWrapper connection:proxyConnection didReceiveData:data];
            delegate should have_received(@selector(connection:didReceiveData:)).with(connection).and_with(data);
        });

        context(@"and the connection succeeds", ^{
            it(@"should tell the delegate and call the completion callback", ^{
                [delegateWrapper connectionDidFinishLoading:proxyConnection];
                delegate should have_received(@selector(connectionDidFinishLoading:)).with(connection);
                NSString *receivedString = [[NSString alloc] initWithData:receivedData
                                                                  encoding:NSUTF8StringEncoding];
                receivedString should equal(@"Hello World");
            });
        });

        context(@"and the connection fails", ^{
            it(@"should tell the delegate and call the completion callback, passing nil in", ^{
                NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
                [delegateWrapper connection:proxyConnection didFailWithError:error];
                delegate should have_received(@selector(connection:didFailWithError:)).with(connection).and_with(error);

                receivedData should be_nil;
            });
        });
    });

    context(@"mini-integration test: when the proxy connection receives a response", ^{
        it(@"should forward the relevant messages to the underlying delegate and call the block appropriately", ^{
            PSHKFakeHTTPURLResponse *response = [[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200
                                                                                          andHeaders:nil
                                                                                             andBody:@"RSVP"];
            [proxyConnection receiveResponse:response];
            delegate should have_received(@selector(connection:didReceiveResponse:)).with(connection).and_with(response);
            delegate should have_received(@selector(connection:didReceiveData:)).with(connection).and_with(response.bodyData);
            delegate should have_received(@selector(connectionDidFinishLoading:)).with(connection);

            NSString *receivedString = [[NSString alloc] initWithData:receivedData
                                                              encoding:NSUTF8StringEncoding];
            receivedString should equal(@"RSVP");
        });
    });
});

SPEC_END
