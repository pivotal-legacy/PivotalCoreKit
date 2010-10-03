#import "PCKXMLParserDelegate.h"

@implementation PCKXMLParserDelegate

@synthesize didStartElement = didStartElement_, didEndElement = didEndElement_, didFindCharacters = didFindCharacters_;
@synthesize didEncounterError = didEncounterError_;

- (void)dealloc {
    self.didStartElement = nil;
    self.didEndElement = nil;
    self.didFindCharacters = nil;
    self.didEncounterError = nil;
    [super dealloc];
}

- (void)parser:(PCKXMLParser *)parser didStartElement:(const char *)elementName {
    if (self.didStartElement) {
        self.didStartElement(elementName);
    }
}

- (void)parser:(PCKXMLParser *)parser didEndElement:(const char *)elementName {
    if (self.didEndElement) {
        self.didEndElement(elementName);
    }
}

- (void)parser:(PCKXMLParser *)parser didFindCharacters:(const char *)characters {
    if (self.didFindCharacters) {
        self.didFindCharacters(characters);
    }
}

#pragma mark PCKParserDelegate
- (void)parser:(id<PCKParser>)parser didEncounterError:(NSError *)error {
    if (self.didEncounterError) {
        self.didEncounterError(error);
    }
}

@end
