#import "WKAlertAction.h"

@interface WKAlertAction ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic) WKAlertActionStyle style;
@property (nonatomic, copy) WKAlertActionHandler handler;
@end

@implementation WKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(WKAlertActionStyle)style handler:(WKAlertActionHandler)handler {
    WKAlertAction *action = [WKAlertAction new];
    action.title = title;
    action.style = style;
    action.handler = handler;

    return action;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) { return NO; }
    WKAlertAction *other = object;

    return [self.title isEqual:other.title] && self.style == other.style;
}

- (NSUInteger)hash {
    return [self.title hash] * self.style+1;
}

@end
