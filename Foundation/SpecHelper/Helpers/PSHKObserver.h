#import <Foundation/Foundation.h>

@interface PSHKObserver : NSObject

@property (nonatomic, readonly) id mostRecentValue;

+ (id)observerForObject:(id)object keyPath:(NSString *)keyPath;
- (id)initWithObject:(id)object keyPath:(NSString *)keyPath;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
