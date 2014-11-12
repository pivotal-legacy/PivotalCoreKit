#import <Foundation/Foundation.h>


// This class only exists to silence a linker warning that appears when a
// static library only contains Objective-C categories.  It does nothing
// and should not be used by clients of PivotalCoreKit.
//
@interface __PCKSilenceLinkerWarnings : NSObject
@end


@implementation __PCKSilenceLinkerWarnings
@end
