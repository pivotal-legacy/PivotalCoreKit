#import <Foundation/Foundation.h>

@interface ConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic) NSURLResponse *response;
@property (nonatomic) NSMutableData *data;
@property (nonatomic) NSError *error;
@property (nonatomic) BOOL cancelRequestWhenResponseIsReceived;

- (NSString *)dataAsString;

@end
