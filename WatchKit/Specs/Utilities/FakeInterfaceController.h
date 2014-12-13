#import <Foundation/Foundation.h>


@interface FakeInterfaceController : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) id context;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithName:(NSString *)name
                     context:(id)context;

@end
