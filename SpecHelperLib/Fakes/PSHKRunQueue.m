#import "PSHKRunQueue.h"
#import "PSHKTime.h"
#import <objc/runtime.h>

@interface RunJob : NSObject

@property (nonatomic, retain) id object;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) NSTimeInterval runTime;

- (id)initWithObject:(id)object selector:(SEL)selector runTime:(NSTimeInterval)runTime;

@end

@implementation RunJob

@synthesize object = object_, selector = selector_, runTime = runTime_;

- (id)initWithObject:(id)object selector:(SEL)selector runTime:(NSTimeInterval)runTime {
    if (self = [super init]) {
        self.object = object;
        self.selector = selector;
        self.runTime = runTime;
    }
    return self;
}

- (void)dealloc {
    [object_ release];
    [super dealloc];
}

@end


@interface PSHKRunQueue ()

@property (nonatomic, retain) NSMutableArray *jobs;

- (void)registerForTimeElapsedNotifications;

@end

@implementation PSHKRunQueue

@synthesize jobs = jobs_;

- (id)init {
    self = [super init];
    if (self) {
        self.jobs = [NSMutableArray array];
        [self registerForTimeElapsedNotifications];
    }


    return self;
}

- (void)dealloc {
    [jobs_ release];
    [super dealloc];
}

- (void)addJobForObject:(id)object selector:(SEL)selector delay:(NSTimeInterval)delay {
    RunJob *runJob = [[[RunJob alloc] initWithObject:object selector:selector runTime:[PSHKTime now] + delay] autorelease];
    [self.jobs addObject:runJob];
}

- (void)cancelJobForObject:(id)aTarget selector:(SEL)aSelector {

    unsigned int i;
    for (i=0; i < self.jobs.count; i++) {
        if (
            //(aTarget == [[self.jobs objectAtIndex:i] object]) &&
            sel_isEqual(aSelector, [[self.jobs objectAtIndex:i] selector])) {
            [self.jobs removeObjectAtIndex:i];
            i--;

        }
    }
}


- (void)registerForTimeElapsedNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:[PSHKTime notificationName] object:nil queue:nil usingBlock:^(NSNotification *note) {
        for (unsigned int i=0; i < self.jobs.count; i++) {
            RunJob *job = [self.jobs objectAtIndex:i];
            if ([PSHKTime now] >= job.runTime) {
                [job.object performSelector:job.selector];
                [self.jobs removeObjectAtIndex:i--];
            }
        }
    }];
}

@end
