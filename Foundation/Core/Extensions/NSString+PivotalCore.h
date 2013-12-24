#import <Foundation/NSString.h>

@interface NSString (PivotalCore)

+ (id)stringWithBase64EncodedData:(NSData *)data;
- (id)initWithBase64EncodedData:(NSData *)data;
- (NSString *)stringByCamelizing;
- (BOOL)endsWith:(NSString *)ending;
- (BOOL)isBlank;
- (BOOL)isValidEmailAddress;

/*
 Overrides the framework version of stringbyAddingPercentEscapesUsingEncoding,
 because the framework version does not escape several characters.  See the blog
 post at http://simonwoodside.com/weblog/2009/4/22/how_to_really_url_encode/ for
 details.
 */
- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding includeAll:(BOOL)includeAll;

@end
