#import <Cedar/SpecHelper.h>

#import "NSObject+Mocking.h"

using namespace Cedar::Matchers;

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

            NSString *classMethodResult = [MyClass aClassMethod];
            expect(classMethodResult).to(equal(@"aClassMethodReturnValue"));
        });
    });
});

describe(@"Stubbing the return value of a class method", ^{
    it(@"should return the specified object value when the stubbed method is called", ^{
        NSString * expectedValue = @"This is the stubbed return value";
        [MyClass stub:@selector(aClassMethod) andReturn:expectedValue];

        NSString *classMethodResult = [MyClass aClassMethod];
        expect(classMethodResult).to(be_same_instance_as(expectedValue));
    });

    it(@"should return the specified object value for each stubbed method", ^{
        NSString * expectedValue1 = @"This is the first stubbed return value";
        NSString * expectedValue2 = @"This is the second stubbed return value";
        [MyClass stub:@selector(aClassMethod) andReturn:expectedValue1];
        [MyClass stub:@selector(aDifferentClassMethod) andReturn:expectedValue2];

        NSString *classMethodResult = [MyClass aClassMethod];
        expect(classMethodResult).to(be_same_instance_as(expectedValue1));

        classMethodResult = [MyClass aDifferentClassMethod];
        expect(classMethodResult).to(be_same_instance_as(expectedValue2));
    });
});

describe(@"Providing a substitute implementation for a stubbed method", ^{
    it(@"should call the block", ^{
        id (^subtituteImplementation)(NSInvocation *) = (id)^(NSInvocation *invocation) { return @"substitution"; };
        [MyClass stub:@selector(aClassMethod) andDo:subtituteImplementation];

        NSString *classMethodResult = [MyClass aClassMethod];
        expect(classMethodResult).to(equal(@"substitution"));
    });

    it(@"should call the block with the arguments passed to the stubbed method", ^{
        __block NSString * stringArgument;
        __block NSInteger integerArgument;
        id (^substituteImplementation)(NSInvocation *) =  (id)^(NSInvocation *invocation) {
            NSString * tempString;
            NSInteger tempInteger;
            [invocation getArgument:&tempString atIndex:2];
            [invocation getArgument:&tempInteger atIndex:3];
            stringArgument = tempString;
            integerArgument = tempInteger;
            return @"substitution";
        };

        [MyClass stub:@selector(aClassMethodWithString:andNumber:) andDo:substituteImplementation];
        [MyClass aClassMethodWithString:@"foobar" andNumber:1234];

        expect(integerArgument).to(equal(1234));
        expect(stringArgument).to(equal(@"foobar"));
    });
});

SPEC_END
