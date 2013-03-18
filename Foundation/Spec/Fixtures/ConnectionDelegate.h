#import <Foundation/Foundation.h>

@interface ConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, assign) BOOL cancelRequestWhenResponseIsReceived;

- (NSString *)dataAsString;

@end
