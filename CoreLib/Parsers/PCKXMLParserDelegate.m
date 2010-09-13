#import "PCKXMLParserDelegate.h"

@implementation PCKXMLParserDelegate

@synthesize didStartElement = didStartElement_, didEndElement = didEndElement_, didFindCharacters = didFindCharacters_;

- (void)dealloc {
    self.didStartElement = nil;
    self.didEndElement = nil;
    self.didFindCharacters = nil;
    [super dealloc];
}

- (void)didStartElement:(const char *)elementName {
    if (self.didStartElement) {
        self.didStartElement(elementName);
    }
}

- (void)didEndElement:(const char *)elementName {
    if (self.didEndElement) {
        self.didEndElement(elementName);
    }
}

- (void)didFindCharacters:(const char *)characters {
    if (self.didFindCharacters) {
        self.didFindCharacters(characters);
    }
}

@end
