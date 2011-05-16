#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "NSObject+Mocking.h"

@interface MyClass : NSObject
+ (id)aClassMethod;
+ (id)aDifferentClassMethod;
+ (id)aClassMethodWithString:(NSString *)stringParam andNumber:(NSInteger)number;
@end

@implementation MyClass
+ (id)aClassMethod {
    return @"aClassMethodReturnValue";
}
+ (id)aDifferentClassMethod {
    return @"AndNowForSomethingCompletelyDifferent";
}
+ (id)aClassMethodWithString:(NSString *)stringParam andNumber:(NSInteger)number {
    return @"CalledWithManyArguments";
}
@end

SPEC_BEGIN(NSObjectSpec_Mocking)

describe(@"resetAllStubbedMethods", ^{
    describe(@"when a method has been stubbed on a class", ^{
        it(@"should revert the method to its original implementation", ^{
            [MyClass stub:@selector(aClassMethod) andReturn:nil];

            [NSObject resetAllStubbedMethods];

            assertThat([MyClass aClassMethod], equalTo(@"aClassMethodReturnValue"));
        });
    });
});

describe(@"Stubbing the return value of a class method", ^{
    afterEach(^{
        [NSObject resetAllStubbedMethods];
    });

    it(@"should return the specified object value when the stubbed method is called", ^{
        NSString * expected_value = @"This is the stubbed return value";
        [MyClass stub:@selector(aClassMethod) andReturn:expected_value];
        assertThat([MyClass aClassMethod], sameInstance(expected_value));
    });

    it(@"should return the specified object value for each stubbed method", ^{
        NSString * expected_value_1 = @"This is the first stubbed return value";
        NSString * expected_value_2 = @"This is the second stubbed return value";
        [MyClass stub:@selector(aClassMethod) andReturn:expected_value_1];
        [MyClass stub:@selector(aDifferentClassMethod) andReturn:expected_value_2];

        assertThat([MyClass aClassMethod], sameInstance(expected_value_1));
        assertThat([MyClass aDifferentClassMethod], sameInstance(expected_value_2));
    });
});

describe(@"Providing a substitute implementation for a stubbed method", ^{
    it(@"should call the block", ^{
        id (^subtituteImplementation)() =  (id)^{ return @"substitution"; };
        [MyClass stub:@selector(aClassMethod) andDo:subtituteImplementation];

        assertThat([MyClass aClassMethod], equalTo(@"substitution"));
    });

    it(@"should call the block with the arguments passed to the stubbed method", ^{
        __block NSString * stringArgument;
        __block NSInteger integerArgument;
        id (^substituteImplementation)() =  (id)^(NSInvocation *inv) {
            NSString * tempString;
            NSInteger tempInteger;
            [inv getArgument:&tempString atIndex:2];
            [inv getArgument:&tempInteger atIndex:3];
            stringArgument = tempString;
            integerArgument = tempInteger;
            return @"substitution";
        };

        [MyClass stub:@selector(aClassMethodWithString:andNumber:) andDo:substituteImplementation];
        [MyClass aClassMethodWithString:@"foobar" andNumber:1234];

        assertThatInt(integerArgument, equalToInt(1234));
        assertThat(stringArgument, equalTo(@"foobar"));
    });
});

SPEC_END
