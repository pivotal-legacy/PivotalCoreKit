#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import "SpecHelper.h"
#else
#import <Cedar/SpecHelper.h>
#endif

#import "NSUserDefaults+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSUserDefaultsSpec_Spec)

describe(@"NSUserDefaults", ^{
    NSUInteger countOfKeysBeforeTestRan = [[[[NSUserDefaults standardUserDefaults]
                                          dictionaryRepresentation] allKeys] count];

    // given that we cannot control which order these tests run in
    // we need to run this test twice in order to ensure that
    // the allKeys.count should equal(0) assertion is tested correctly
    it(@"should allow you to store some user defaults", ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [[[userDefaults dictionaryRepresentation] allKeys] count] should equal(countOfKeysBeforeTestRan);

        NSURL *arnyURL = [NSURL URLWithString:@"http://www.schwarzenegger.com/"];

        [userDefaults setObject:@"DO IT NOW" forKey:@"GET TO TEH CHOPPAH"];
        [userDefaults setURL:arnyURL forKey:@"Arnold"];
        [userDefaults setFloat:12323.23 forKey:@"lbsBenched"];
        [userDefaults setBool:YES forKey:@"i'll be back"];
        [userDefaults setInteger:800 forKey:@"Terminator model number"];
        [userDefaults setDouble:1000 forKey:@"Liquid Terminator model number"];

        // assert that these values are set (because these methods are swizzled)
        [userDefaults objectForKey:@"GET TO TEH CHOPPAH"] should equal(@"DO IT NOW");
        [userDefaults URLForKey:@"Arnold"] should equal(arnyURL);
        [userDefaults floatForKey:@"lbsBenched"] should be_close_to(12323.23);
        [userDefaults boolForKey:@"i'll be back"] should be_truthy;
        [userDefaults integerForKey:@"Terminator model number"] should equal(800);
        [userDefaults doubleForKey:@"Liquid Terminator model number"] should equal(1000);
    });

    it(@"should not pollute your tests", ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [[[userDefaults dictionaryRepresentation] allKeys] count] should equal(countOfKeysBeforeTestRan);

        [userDefaults setObject:@"DO IT NOW" forKey:@"GET TO TEH CHOPPAH"];
        [userDefaults setURL:[NSURL URLWithString:@"http://www.schwarzenegger.com/"] forKey:@"Arnold"];
        [userDefaults setFloat:12323.23 forKey:@"lbsBenched"];
        [userDefaults setBool:YES forKey:@"i'll be back"];
        [userDefaults setInteger:800 forKey:@"Terminator model number"];
        [userDefaults setDouble:1000 forKey:@"Liquid Terminator model number"];
    });
});

SPEC_END
