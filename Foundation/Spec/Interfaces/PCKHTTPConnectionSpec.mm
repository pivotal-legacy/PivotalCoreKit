#import <Foundation/Foundation.h>
#import "CDRSpecHelper.h"
#import "Foundation+PivotalSpecHelper.h"

#import "PCKHTTPConnection.h"
#import "PCKHTTPInterface.h"
#import "FakeConnectionDelegate.h"
#import "PSHKWeakObjectWrapper.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PCKHTTPConnectionSpec)

describe(@"PCKHTTPConnection", ^{

    it(@"should release its delegate when deallocated", ^{
        PSHKWeakObjectWrapper *wrapper = [[PSHKWeakObjectWrapper alloc] init];
        @autoreleasepool {
            PCKHTTPInterface<CedarDouble> *fakeInterface = fake_for([PCKHTTPInterface class]);
            NSURLRequest<CedarDouble> *fakeRequest = fake_for([NSURLRequest class]);
            FakeConnectionDelegate *delegate = [[FakeConnectionDelegate alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            PCKHTTPConnection *connection = [[PCKHTTPConnection alloc] initWithHTTPInterface:fakeInterface forRequest:fakeRequest andDelegate:delegate];
#pragma clang diagnostic pop

            wrapper.target = delegate;
            [NSURLConnection resetAll];
        }
        wrapper.target should be_nil;
    });
});

SPEC_END
