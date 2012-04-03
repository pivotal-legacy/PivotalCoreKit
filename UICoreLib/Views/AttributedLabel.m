#import "AttributedLabel.h"
#import <CoreText/CoreText.h>

@interface AttributedLabel ()
@property (nonatomic, assign) CTFramesetterRef framesetter;
@end

@implementation AttributedLabel

@synthesize attributedString = attributedString_, framesetter = framesetter_;

- (void)dealloc {
    self.attributedString = nil;
    if (self.framesetter != nil) {
        CFRelease(self.framesetter);
    }
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    if (self.attributedString == nil) return;

    CGMutablePathRef layoutPath = CGPathCreateMutable();
    CGPathAddRect(layoutPath, NULL, self.bounds);
    CTFrameRef layoutFrame = CTFramesetterCreateFrame(self.framesetter,
                                                      CFRangeMake(0, 0),
                                                      layoutPath, NULL);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CTFrameDraw(layoutFrame, context);

    CFRelease(layoutFrame);
    CGPathRelease(layoutPath);
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    if (attributedString_ == attributedString) return;
    [attributedString_ autorelease];
    attributedString_ = [attributedString retain];
    if (self.framesetter != nil) {
        CFRelease(self.framesetter);
    }
    self.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);

    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CFRange rangeThatFits;
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(self.framesetter,
                                                                  CFRangeMake(0, 0),
                                                                  NULL,
                                                                  size,
                                                                  &rangeThatFits);
    return fitSize;

}

@end
