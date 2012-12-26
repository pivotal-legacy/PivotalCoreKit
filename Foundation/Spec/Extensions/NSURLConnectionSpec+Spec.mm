#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSURLConnection+Spec.h"
#import "PSHKFakeHTTPURLResponse.h"
#import "NSURLConnectionDelegate.h"
#import "FakeConnectionDelegate.h"

@interface SelfReferentialConnection : NSURLConnection
@end

@implementation SelfReferentialConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    return [super initWithRequest:request delegate:self startImmediately:startImmediately];
}

@end


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

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

    afterEach(^{
        [connection release];
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

        it(@"should retain the request", ^{
            expect(request.retainCount).to(equal(2));
        });

        describe(@"when the delegate is self", ^{
            beforeEach(^{
                [connection release];
                connection = [[SelfReferentialConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
            });

            it(@"should not retain the delegate", ^{
                // One retain for alloc, one retain for the connections array.
                expect(connection.retainCount).to(equal(2));
            });
        });

        describe(@"when the delegate is not self", ^{
            __block FakeConnectionDelegate *delegate;

            beforeEach(^{
                delegate = [[[FakeConnectionDelegate alloc] init] autorelease];
                connection = [(NSURLConnection *)[NSURLConnection alloc] initWithRequest:request delegate:delegate];
            });

            it(@"should retain the delegate", ^{
                expect([delegate retainCount]).to(equal(2));
            });
        });
    });

    describe(@"on destruction", ^{
        beforeEach(^{
            [NSURLConnection resetAll];
            [connection release]; connection = nil;
        });

        it(@"should release the request", ^{
            expect(request.retainCount).to(equal(1));
        });

        describe(@"when the delegate is self", ^{
            beforeEach(^{
                [connection release];
                connection = [[SelfReferentialConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
                [NSURLConnection resetAll];
            });

            it(@"should not explode", ^{
                [connection release]; connection = nil;
            });
        });

        describe(@"when the delegate is not self", ^{
            it(@"should release the delegate", ^{
                expect([delegate retainCount]).to(equal(1));
            });
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
            response = [[[PSHKFakeHTTPURLResponse alloc] initWithStatusCode:200
                                                                 andHeaders:[NSDictionary dictionary]
                                                                    andBody:@"foo"]
                        autorelease];
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
                NSURLConnection * theConnection;
                [inv getArgument:&theConnection atIndex:2];
                [theConnection cancel];
            });

            [connection receiveResponse:response];

            delegate should_not have_received("connection:didReceiveData:");
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
});

SPEC_END
