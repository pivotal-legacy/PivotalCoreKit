#import "NSUserDefaults+Spec.h"
#import "NSObject+MethodRedirection.h"

@interface NSUserDefaults (Spec_Private)
-(void)setUnswizzledObject:(id)obj forKey:(NSString *)key;
-(void)setUnswizzledURL:(NSURL *)url forKey:(NSString *)key;
-(void)setUnswizzledFloat:(float)theFloat forKey:(NSString *)key;
-(void)setUnswizzledBool:(BOOL)theBool forKey:(NSString *)key;
-(void)setUnswizzledInteger:(NSInteger)theInt forKey:(NSString *)key;
-(void)setUnswizzledDouble:(double)theDouble forKey:(NSString *)key;
@end

@implementation NSUserDefaults (Spec)

static NSMutableArray *keys;
+(void)load {
    keys = [[NSMutableArray alloc] init];


    [NSUserDefaults redirectSelector:@selector(setObject:forKey:)
                                  to:@selector(setSnoopedObject:forKey:)
                       andRenameItTo:@selector(setUnswizzledObject:forKey:)];

    [NSUserDefaults redirectSelector:@selector(setURL:forKey:)
                                  to:@selector(setSnoopedURL:forKey:)
                       andRenameItTo:@selector(setUnswizzledURL:forKey:)];

    [NSUserDefaults redirectSelector:@selector(setFloat:forKey:)
                                  to:@selector(setSnoopedFloat:forKey:)
                       andRenameItTo:@selector(setUnswizzledFloat:forKey:)];

    [NSUserDefaults redirectSelector:@selector(setBool:forKey:)
                                  to:@selector(setSnoopedBool:forKey:)
                       andRenameItTo:@selector(setUnswizzledBool:forKey:)];

    [NSUserDefaults redirectSelector:@selector(setInteger:forKey:)
                                  to:@selector(setSnoopedInteger:forKey:)
                       andRenameItTo:@selector(setUnswizzledInteger:forKey:)];

    [NSUserDefaults redirectSelector:@selector(setDouble:forKey:)
                                  to:@selector(setSnoopedDouble:forKey:)
                       andRenameItTo:@selector(setUnswizzledDouble:forKey:)];

}

#pragma mark - Cedar beforeEach helper
+(void)beforeEach {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *keysCopy = [keys copy];

    [keysCopy enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL *stop) {
        [defaults removeObjectForKey:key];
    }];

    keys = [[NSMutableArray alloc] init];
}

#pragma mark - swizzled methods
-(void)setSnoopedObject:(id)obj forKey:(NSString *)key {
    [keys addObject:key];
    [self setUnswizzledObject:obj forKey:key];
}

-(void)setSnoopedURL:(NSURL *)url forKey:(NSString *)key {
    [keys addObject:key];
    [self setUnswizzledURL:url forKey:key];
}

-(void)setSnoopedFloat:(float)theFloat forKey:(NSString *)key {
    [keys addObject:key];
    [self setUnswizzledFloat:theFloat forKey:key];
}

-(void)setSnoopedBool:(BOOL)theBool forKey:(NSString *)key {
    [keys addObject:key];
    [self setUnswizzledBool:theBool forKey:key];
}

-(void)setSnoopedInteger:(NSInteger)theInt forKey:(NSString *)key {
    [keys addObject:key];
    [self setUnswizzledInteger:theInt forKey:key];
}

-(void)setSnoopedDouble:(double)theDouble forKey:(NSString *)key {
    [keys addObject:key];
    [self setUnswizzledDouble:theDouble forKey:key];
}

@end
