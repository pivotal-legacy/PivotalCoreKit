#import <Foundation/NSString.h>

@interface NSString (PivotalCore)

// use NSData's NSDataBase64Encoding methods instead, such as -base64EncodedStringWithOptions:
// or, in pre-iOS 7 or pre-Mavericks runtimes, use -[NSData base64Encoding]
+ (id)stringWithBase64EncodedData:(NSData *)data DEPRECATED_ATTRIBUTE;
- (id)initWithBase64EncodedData:(NSData *)data DEPRECATED_ATTRIBUTE;

- (NSString *)stringByCamelizing;
- (BOOL)isBlank;
- (BOOL)isValidEmailAddress;

/*
 Overrides the framework version of stringbyAddingPercentEscapesUsingEncoding,
 because the framework version does not escape several characters.  See the blog
 post at http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/ for
 details.
 */
- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding includeAll:(BOOL)includeAll DEPRECATED_ATTRIBUTE;

@end
