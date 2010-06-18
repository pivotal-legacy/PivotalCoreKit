#import <Foundation/NSString.h>

@class NSData;

@interface NSString (PivotalCore)
+ (id)stringWithBase64EncodedData:(NSData *)data;
- (id)initWithBase64EncodedData:(NSData *)data;
@end
