#import "PCKXMLParserDelegate.h"

@implementation PCKXMLParserDelegate

@synthesize didStartElement = didStartElement_, didEndElement = didEndElement_, didFindCharacters = didFindCharacters_;

- (void)dealloc {
    self.didStartElement = nil;
    self.didEndElement = nil;
    self.didFindCharacters = nil;
[super dealloc];
}

@end
