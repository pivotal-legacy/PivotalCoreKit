#import "PSHKObserver.h"

static char PSHKObserverContextKey;

@interface PSHKObserver ()

@property (nonatomic) id mostRecentValue;

@end

@implementation PSHKObserver

+ (id)observerForObject:(id)object keyPath:(NSString *)keyPath {
    return [[self alloc] initWithObject:object keyPath:keyPath];
}

- (id)initWithObject:(id)object keyPath:(NSString *)keyPath {
    self = [super init];
    if (self) {
        [object addObserver:self
                 forKeyPath:keyPath
                    options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                    context:&PSHKObserverContextKey];
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (&PSHKObserverContextKey != context) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    self.mostRecentValue = change[NSKeyValueChangeNewKey];
}

@end
