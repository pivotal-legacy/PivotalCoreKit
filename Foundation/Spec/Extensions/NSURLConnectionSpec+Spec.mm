#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "NSURLConnection+Spec.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSURLConnectionDelegate.h"
#import "ConnectionDelegate.h"
#import "FakeHTTP.h"
#import "FakeOperationQueue.h"


@interface SelfReferentialConnection : NSURLConnection
@end

@implementation SelfReferentialConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    return [super initWithRequest:request delegate:self startImmediately:startImmediately];
}

@end


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

SPEC_BEGIN(NSURLConnectionSpec_Spec)

describe(@"NSURLConnection (spec extensions)", ^{
    __block NSURLRequest *request;
    __block NSURLConnection *connection;
    __block id<NSURLConnectionDelegate, CedarDouble> delegate;

    beforeEach(^{
        delegate = nice_fake_for(@protocol(NSURLConnectionDataDelegate));
        NSURL *url = [NSURL URLWithString:@"http://example.com"];
        request = [NSURLRequest requestWithURL:url];

        // OS X 10.7 introduced the NSURLDownload class, which has an initWithRequest:delegate: initializer
        // exactly like the one on NSURLConnection, EXCEPT that the type of the delegete argument is
        // id<NSURLDownloadDelegate> while the type of the NSURLConnection delegate argument is id.  The
        // compiler sees these as ambiguous methods with different arguments, so emits a warning.  Explicitly
        // cast the result of the alloc to NSURLConnection * to quiet the compiler.
        connection = [(NSURLConnection *)[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    });

    describe(@"+resetAll", ^{
        it(@"should remove all connections from the global list of connections", ^{
            expect([NSURLConnection connections]).to_not(be_empty());
            [NSURLConnection resetAll];
            expect([NSURLConnection connections]).to(be_empty());
        });
    });

    describe(@"on initialization", ^{
        it(@"should record the existence of the object in the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
        });
    });

    describe(@"on destruction", ^{
        beforeEach(^{
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
            delegate = nice_fake_for(@protocol(NSURLConnectionDataDelegate));

            connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
             connection = nil;
            [NSURLConnection resetAll];
        });

        describe(@"when the delegate is self", ^{
            beforeEach(^{
                connection = [[SelfReferentialConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
            });

            it(@"should not explode", ^{
                ^ {[NSURLConnection resetAll]; } should_not raise_exception;
            });
        });
    });

    describe(@"when the connection is generated with the asynchronous convenience class method", ^{
        __block NSURL *URL;
        __block NSHTTPURLResponse *receivedResponse;
        __block NSData *receivedData;
        __block NSError *receivedError;

        beforeEach(^{
            receivedResponse = nil;
            receivedData = nil;
            receivedError = nil;

            URL = [NSURL URLWithString:@"http://www.google.com/"];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       receivedData = data;
                                       receivedError = error;
                                       receivedResponse = (NSHTTPURLResponse *)response;
                                   }];
            connection = [[NSURLConnection connections] lastObject];
        });

        it(@"should be captured and made available in the array of connections", ^{
            connection.request.URL should equal(URL);
        });

        it(@"should receive responses", ^{
            PSHKFakeHTTPURLResponse *response = [[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200 andHeaders:@{@"Content-Type": @"application/json"} andBody:@"Response"];

            [connection receiveResponse:response];

            NSString *receivedString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
            receivedString should equal(@"Response");
            receivedResponse.statusCode should equal(200);
            [receivedResponse MIMEType] should equal(@"application/json");
        });

        it(@"should receive failures", ^{
            NSData *data = [@"Fail" dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];

            [connection failWithError:error data:data];

            receivedData should be_nil; //SDK docs say that data is guaranteed to be nil when an error occurs
            receivedError should equal(error);
        });
    });

    describe(@"cancel", ^{
        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection cancel];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });
    });

    describe(@"receiveResponse:", ^{
        __block PSHKFakeHTTPURLResponse *response;

        beforeEach(^{
            response = [[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200
                                                                 andHeaders:[NSDictionary dictionary]
                                                                    andBody:@"foo"];
        });

        it(@"should send the response to the delegate", ^{
            [connection receiveResponse:response];
            delegate should have_received("connection:didReceiveResponse:").with(connection).and_with(response);
        });

        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection receiveResponse:response];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });

        it(@"should not call subsequent delegate methods if cancelled", ^{
            spy_on(delegate);

            delegate stub_method("connection:didReceiveResponse:").and_do(^(NSInvocation * inv) {
                __unsafe_unretained NSURLConnection * theConnection;
                [inv getArgument:&theConnection atIndex:2];
                [theConnection cancel];
            });

            [connection receiveResponse:response];

            delegate should_not have_received("connection:didReceiveData:");
        });
    });

    describe(@"receive succesful response", ^{
        it(@"should send a succesful response (along with the data) to the delegate", ^{
            ConnectionDelegate *delegate = [[ConnectionDelegate alloc] init];
            connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
            [connection receiveSuccesfulResponseWithBody:@"The Internet"];
            delegate.dataAsString should equal(@"The Internet");
            [(NSHTTPURLResponse *)delegate.response statusCode] should equal(200);
        });
    });

    describe(@"failWithError:", ^{
        __block NSError *error;

        beforeEach(^{
            error = [NSError errorWithDomain:@"domain" code:8 userInfo:nil];
        });

        it(@"should send the error to the delegate", ^{
            spy_on(delegate);
            [connection failWithError:error];

            delegate should have_received("connection:didFailWithError:").with(connection).and_with(error);
        });

        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection failWithError:error];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });
    });

    describe(@"failWithError:data:", ^{
        __block NSError *error;
        __block NSData *data;

        beforeEach(^{
            error = [NSError errorWithDomain:@"domain" code:8 userInfo:nil];
            data = [@"error info" dataUsingEncoding:NSUTF8StringEncoding];
        });

        it(@"should send the error to the delegate", ^{
            spy_on(delegate);
            [connection failWithError:error data:data];

            delegate should have_received("connection:didFailWithError:").with(connection).and_with(error);
        });

        it(@"should send the data to the delegate", ^{
            spy_on(delegate);
            [connection failWithError:error data:data];

            delegate should have_received("connection:didReceiveData:").with(connection).and_with(data);
        });

        it(@"should remove the connection from the global list of connections", ^{
            expect([NSURLConnection connections]).to(contain(connection));
            [connection failWithError:error];
            expect([NSURLConnection connections]).to_not(contain(connection));
        });
    });

    describe(@"fetching all pending connections synchronously", ^{
        __block NSOperationQueue *fakeOperationQueue;

        __block NSData *firstData;
        __block NSData *secondData;
        __block NSData *thirdData;

        beforeEach(^{
            fakeOperationQueue = [[FakeOperationQueue alloc] init];
            [(FakeOperationQueue *)fakeOperationQueue setRunSynchronously:YES];

            [NSURLConnection resetAll];
            [FakeHTTP startMocking];

            NSURLRequest *firstRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
            NSURLRequest *secondRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pivotallabs.com"]];
            NSURLRequest *thirdRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://apple.com"]];

            FakeHTTPURLResponse *firstResponse = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 headers:@{} body:[@"I'm Feeling Lucky" dataUsingEncoding:NSUTF8StringEncoding]];
            FakeHTTPURLResponse *secondResponse = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 headers:@{} body:[@"Pivotal Labs" dataUsingEncoding:NSUTF8StringEncoding]];
            FakeHTTPURLResponse *thirdResponse = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 headers:@{} body:[@"Apple Inc." dataUsingEncoding:NSUTF8StringEncoding]];

            [FakeHTTP registerURL:firstRequest.URL withResponse:firstResponse];
            [FakeHTTP registerURL:secondRequest.URL withResponse:secondResponse];
            [FakeHTTP registerURL:thirdRequest.URL withResponse:thirdResponse];

            [NSURLConnection sendAsynchronousRequest:firstRequest queue:fakeOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                firstData = data;
                //kick off another request
                [NSURLConnection sendAsynchronousRequest:thirdRequest queue:fakeOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    thirdData = data;
                }];
            }];

            [NSURLConnection sendAsynchronousRequest:secondRequest queue:fakeOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                secondData = data;
            }];
        });

        it(@"should fetch all pending connections, including any new connections that generated as a result", ^{
            [NSURLConnection fetchAllPendingConnectionsSynchronouslyWithTimeout:2];

            [[NSString alloc] initWithData:firstData encoding:NSUTF8StringEncoding] should contain(@"I'm Feeling Lucky");
            [[NSString alloc] initWithData:secondData encoding:NSUTF8StringEncoding] should contain(@"Pivotal Labs");
            [[NSString alloc] initWithData:thirdData encoding:NSUTF8StringEncoding] should contain(@"Apple Inc.");
        });
    });

    describe(@"fetching an individual connection's data synchronously", ^{
        __block NSURL *URL;
        __block NSURLRequest *request;
        __block NSString *expectedString;
        __block NSURLConnection *connection;

        beforeEach(^{
            [NSURLConnection resetAll];
            [FakeHTTP startMocking];

            URL = [NSURL URLWithString:@"http://google.com/"];
            expectedString = @"I'm Feeling Lucky";
            request = [NSURLRequest requestWithURL:URL];

            NSData *bodyData = [@"I'm Feeling Lucky" dataUsingEncoding:NSUTF8StringEncoding];
            FakeHTTPURLResponse *response = [[FakeHTTPURLResponse alloc] initWithStatusCode:200
                                                                                     headers:@{}
                                                                                        body:bodyData];
            [FakeHTTP registerURL:URL withResponse:response];
        });

        context(@"when the connection is built with a delegate", ^{
            __block ConnectionDelegate *delegate;

            beforeEach(^{
                delegate = [[ConnectionDelegate alloc] init];
                connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
            });

            it(@"should fetch the data from the URL synchronously, return the resulting data in addition to passing it to the delegate, and remove the original request from the list of connections", ^{
                [[NSURLConnection connections] count] should equal(1);
                delegate.data.length should equal(0);

                NSData *data = [connection fetchSynchronouslyWithTimeout:2];

                delegate.dataAsString should contain(expectedString);
                [[NSURLConnection connections] count] should equal(0);
                NSString *returnedDataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                returnedDataAsString should contain(expectedString);
            });


            context(@"when the delegate cancels the request", ^{
                beforeEach(^{
                    delegate.cancelRequestWhenResponseIsReceived = YES;
                });

                it(@"should cancel the synchronous connection", ^{
                    delegate.data.length should equal(0);

                    [connection fetchSynchronouslyWithTimeout:2];

                    delegate.data.length should equal(0);
                    [[NSURLConnection connections] count] should equal(0);
                });
            });

            context(@"when the connection times out", ^{
                it(@"should cancel the underlying connection and tell the delegate an error occured", ^{
                    delegate.data.length should equal(0);

                    NSData *data = [connection fetchSynchronouslyWithTimeout:0];

                    delegate.data.length should equal(0);
                    delegate.error.domain should equal(NSURLErrorDomain);
                    delegate.error.code should equal(NSURLErrorTimedOut);

                    data should be_nil;
                });
            });
        });

        describe(@"when using the convenience asynchronous class method", ^{
            __block NSOperationQueue *fakeOperationQueue;
            __block NSData *receivedData;
            __block NSError *receivedError;

            beforeEach(^{
                fakeOperationQueue = [[FakeOperationQueue alloc] init];
                [(FakeOperationQueue *)fakeOperationQueue setRunSynchronously:YES];

                receivedData = nil;
                receivedError = nil;

                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:fakeOperationQueue
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           receivedData = data;
                                           receivedError = error;
                                       }];

                [[NSURLConnection connections] count] should equal(1);
                receivedData should be_nil;

                connection = [[NSURLConnection connections] lastObject];
                connection should_not be_nil;
                connection.request should equal(request);
            });

            it(@"should fetch the data from the URL synchronously", ^{
                NSData *data = [connection fetchSynchronouslyWithTimeout:2.0];

                receivedData should equal(data);

                [[NSURLConnection connections] count] should equal(0);
                NSString *returnedDataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                returnedDataAsString should contain(expectedString);
            });

            it(@"should pass the appropriate error in when the request times out", ^{
                NSData *data = [connection fetchSynchronouslyWithTimeout:0];

                receivedError.domain should equal(NSURLErrorDomain);
                receivedError.code should equal(NSURLErrorTimedOut);

                data should be_nil;
            });
        });
    });
});

SPEC_END

#pragma clang diagnostic pop
