#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE && !TARGET_OS_TV
#import "CDRSpecHelper.h"
#else
#import <Cedar/CDRSpecHelper.h>
#endif

#import "NSObject+MethodRedirection.h"

using namespace Cedar::Matchers;

@interface Redirectable : NSObject

+ (int)embiggen:(int)number;
- (NSString *)cheekify:(NSString *)string;

@end

@interface Redirectable (redirected_methods)

+ (int)embiggen_original:(int)number;
- (NSString *)cheekify_original:(NSString *)string;
- (NSString *)cheekify_other:(NSString *)string;

@end

@implementation Redirectable

+ (int)embiggen:(int)number {
    return number + 1;
}

+ (int)embiggen_new:(int)number {
    return [self embiggen_original:number] + 1;
}

- (NSString *)cheekify:(NSString *)string {
    return [NSString stringWithFormat:@"%@ is so cheeky", string];
}

- (NSString *)cheekify_new:(NSString *)string {
    return [NSString stringWithFormat:@"No, really, %@", [self cheekify_original:string]];
}

- (NSString *)stodgify:(NSString *)string
{
    return [NSString stringWithFormat:@"%@ is so stodgy", string];
}

@end

SPEC_BEGIN(NSObject_MethodRedirectionSpec)

describe(@"NSObject_MethodRedirection", ^{
    __block Redirectable *redirectable;

    beforeEach(^{
        redirectable = [[Redirectable alloc] init];
    });

    describe(@"redirecting instance methods", ^{
        it(@"should redirect calls to the original selector to the new implementation, and expose the original implementation via a renamed selector", ^{
            [redirectable cheekify:@"Herman"] should equal(@"Herman is so cheeky");

            [Redirectable redirectSelector:@selector(cheekify:) to:@selector(cheekify_new:) andRenameItTo:@selector(cheekify_original:)];

            [redirectable cheekify:@"Herman"] should equal(@"No, really, Herman is so cheeky");
            
            [Redirectable redirectSelector:@selector(cheekify:) to:@selector(cheekify_original:) andRenameItTo:@selector(cheekify_other:)];
        });

        it(@"should do nothing when the new selector name (i.e. the argumen to andRenameItTo:) already exists", ^{
            [Redirectable redirectSelector:@selector(cheekify:) to:@selector(cheekify_new:) andRenameItTo:@selector(stodgify:)];

            [redirectable stodgify:@"Herman"] should equal(@"Herman is so stodgy");
            [redirectable cheekify:@"Herman"] should equal(@"Herman is so cheeky");
        });
    });

    describe(@"redirecting class methods", ^{
        it(@"should redirect calls to the original selector to the new implementation, and expose the original implementation via a renamed selector", ^{
            [Redirectable embiggen:1] should equal(2);

            [Redirectable redirectClassSelector:@selector(embiggen:) to:@selector(embiggen_new:) andRenameItTo:@selector(embiggen_original:)];

            [Redirectable embiggen:1] should equal(3);
        });
    });
});

SPEC_END
