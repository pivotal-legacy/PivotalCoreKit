#import "AppDelegate.h"
#import "Foundation+PivotalCore.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"================> %@", [@"this_string_was_originally_snake_cased" stringByCamelizing]);
    
    return YES;
}

@end
