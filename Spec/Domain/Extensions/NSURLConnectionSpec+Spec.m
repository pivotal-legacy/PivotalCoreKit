#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSURLConnection+Spec.h"
#import "PCKHTTPConnectionDelegate.h"
#import "PSHKFakeHTTPURLResponse.h"

@interface SelfReferentialConnection : NSURLConnection
@end

@implementation SelfReferentialConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    return [super initWithRequest:request delegate:self startImmediately:startImmediately];
}

@end


SPEC_BEGIN(NSURLConnectionSpec_Spec)

describe(@"NSURLConnection (spec extensions)", ^{
    __block NSURLRequest *request;
    __block id mockDelegate;
    __block NSURLConnection *connection;

    beforeEach(^{
        mockDelegate = [OCMockObject niceMockForProtocol:@protocol(PCKHTTPConnectionDelegate)];
        NSURL *url = [NSURL URLWithString:@"http://example.com"];
        request = [NSURLRequest requestWithURL:url];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:mockDelegate];
    });

    afterEach(^{
        [connection release];
        [NSURLConnection resetAll];
    });

    describe(@"+resetAll", ^{
        it(@"should remove all connections from the global list of connections", ^{
            assertThatInt([NSURLConnection connections].count, isNot(equalToInt(0)));
            [NSURLConnection resetAll];
            assertThatInt([NSURLConnection connections].count, equalToInt(0));
        });
    });

    describe(@"on initialization", ^{
        it(@"should record the existence of the object in the global list of connections", ^{
            assertThat([NSURLConnection connections], hasItem(connection));
        });

        it(@"should retain the request", ^{
            assertThatInt([request retainCount], equalToInt(2));
        });

        describe(@"when the delegate is self", ^{
            beforeEach(^{
                [connection release];
                connection = [[SelfReferentialConnection alloc] initWithRequest:request delegate:nil startImmediately:YES];
            });

            it(@"should not retain the delegate", ^{
                // One retain for alloc, one retain for the connections array.
                assertThatInt([connection retainCount], equalToInt(2));
            });
        });

        describe(@"when the delegate is not self", ^{
            it(@"should retain the delegate", ^{
                assertThatInt([mockDelegate retainCount], equalToInt(2));
            });
        });
    });

    describe(@"on destruction", ^{
        beforeEach(^{
            [NSURLConnection resetAll];
            [connection release]; connection = nil;
        });

        it(@"should release the request", ^{
            assertThatInt([request retainCount], equalToInt(1));
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
                assertThatInt([mockDelegate retainCount], equalToInt(1));
            });
        });
    });

    describe(@"cancel", ^{
        it(@"should remove the connection from the global list of connections", ^{
            assertThat([NSURLConnection connections], hasItem(connection));
            [connection cancel];
            assertThat([NSURLConnection connections], isNot(hasItem(connection)));
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
            [[mockDelegate expect] connection:connection didReceiveResponse:response];
            [connection receiveResponse:response];
            [mockDelegate verify];
        });

        it(@"should remove the connection from the global list of connections", ^{
            assertThat([NSURLConnection connections], hasItem(connection));
            [connection receiveResponse:response];
            assertThat([NSURLConnection connections], isNot(hasItem(connection)));
        });
    });

    describe(@"failWithError:", ^{
        __block NSError *error;

        beforeEach(^{
            error = [NSError errorWithDomain:@"domain" code:8 userInfo:nil];
        });

        it(@"should send the error to the delegate", ^{
            [[mockDelegate expect] connection:connection didFailWithError:error];
            [connection failWithError:error];
            [mockDelegate verify];
        });

        it(@"should remove the connection from the global list of connections", ^{
            assertThat([NSURLConnection connections], hasItem(connection));
            [connection failWithError:error];
            assertThat([NSURLConnection connections], isNot(hasItem(connection)));
        });
    });
});

SPEC_END
