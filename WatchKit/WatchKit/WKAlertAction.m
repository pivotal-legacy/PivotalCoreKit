

#import "WKAlertAction.h"

@implementation WKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(WKAlertActionStyle)style
                        handler:(WKAlertActionHandler)handler {
    return [super actionWithTitle:title style:style handler:handler];
}

@end
