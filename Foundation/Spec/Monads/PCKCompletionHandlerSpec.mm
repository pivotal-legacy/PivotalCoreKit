#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "PCKCompletionHandler.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKCompletionHandlerSpec)

describe(@"PCKCompletionHandler", ^{
    __block PCKCompletionHandler *subject;

    describe(@"a single function", ^{
        beforeEach(^{
            subject = [PCKCompletionHandler completionHandlerWithBlock:^id(id o, NSURLResponse *response, NSError **pError) {
                if (response) {
                    return [o valueForKey:@"name"];
                }
                *pError = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:nil];
                return nil;
            }];
        });

        it(@"can be called with success", ^{
            NSError *error = nil;
            NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"."] statusCode:200 HTTPVersion:nil headerFields:nil];
            [subject callWith:@{@"name" : @"test"} response:response error:nil outError:&error] should equal(@"test");
            error should be_nil;
        });

        it(@"can fail", ^{
            NSError *error = nil;
            [subject callWith:@{@"name" : @"test"} response:nil error:nil outError:&error] should be_nil;
            error.code should equal(1);
        });

        it(@"can be called with failure", ^{
            NSError *error = nil;
            [subject callWith:nil response:nil error:[NSError errorWithDomain:NSCocoaErrorDomain code:2 userInfo:nil] outError:&error];
            error.code should equal(2);
        });

        it(@"does not invoke the block when called with failure ignoring errors", ^{
            [[PCKCompletionHandler completionHandlerWithBlock:^id(id o, NSURLResponse *response, NSError **pError) {
                return @2;
            }] callWith:@1 response:nil error:[NSError errorWithDomain:NSCocoaErrorDomain code:2 userInfo:nil] outError:NULL] should equal(@1);
        });

        describe(@"composing and invoking functions", ^{
            __block PCKCompletionHandler *composed;
            beforeEach(^{
                PCKCompletionHandler *other = [PCKCompletionHandler completionHandlerWithBlock:^id(id o, NSURLResponse *response, NSError **pError) {
                    return [NSJSONSerialization JSONObjectWithData:o options:0 error:pError];
                }];

               composed = [subject compose:other];
            });

            it(@"chains the calls, shortcutting on error", ^{
                NSError *error = nil;
                NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"."] statusCode:200 HTTPVersion:nil headerFields:nil];
                [composed callWith:[@"{\"name\":\"test\"}" dataUsingEncoding:NSUTF8StringEncoding] response:response error:nil outError:&error] should equal(@"test");
                error should be_nil;

                [composed callWith:[NSData data] response:response error:nil outError:&error] should be_nil;
                error.code should equal(3840);
            });
        });
    });
});

SPEC_END
