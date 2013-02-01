#import <Foundation/Foundation.h>


@interface Target : NSObject

@property (nonatomic) BOOL wasCalled;

- (void)callMe;

@end

