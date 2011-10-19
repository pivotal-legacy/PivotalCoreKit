#import "PCKXMLParserDelegate.h"

#define ATTRIBUTE_SIZE 5
#define ATTRIBUTE_START_OFFSET 3
#define ATTRIBUTE_END_OFFSET 4

@implementation PCKXMLParserDelegate

@synthesize didStartElementWithAttributes = didStartElementWithAttributes_, didStartElement = didStartElement_, didEndElement = didEndElement_, didFindCharacters = didFindCharacters_;
@synthesize didEncounterError = didEncounterError_;

- (void)dealloc {
    self.didStartElement = nil;
    self.didEndElement = nil;
    self.didFindCharacters = nil;
    self.didEncounterError = nil;
    [super dealloc];
}

- (void)parser:(PCKXMLParser *)parser didStartElement:(const char *)elementName attributeCount:(int)numAttributes attributeData:(const char**)attributes {
    if (self.didStartElementWithAttributes) {
        NSMutableDictionary * attributesDictionary = [NSMutableDictionary dictionary];
        for (int i = 0; i < (numAttributes * ATTRIBUTE_SIZE); i += ATTRIBUTE_SIZE) {
            NSString * attributeName = [NSString stringWithCString:attributes[i] encoding:NSUTF8StringEncoding];
            const char * startAttributeValue = attributes[i + ATTRIBUTE_START_OFFSET];
            const char * endAttributeValue = attributes[i + ATTRIBUTE_END_OFFSET];

            ptrdiff_t attributeBytes = endAttributeValue - startAttributeValue;
            char * attributeValue = (char *)malloc((size_t)attributeBytes + 1);
            attributeValue[attributeBytes] = 0;
            strncpy(attributeValue, startAttributeValue, attributeBytes);
            [attributesDictionary setValue:[NSString stringWithCString:attributeValue encoding:NSUTF8StringEncoding] forKey:attributeName];
            free(attributeValue);
        }
        self.didStartElementWithAttributes(elementName, attributesDictionary);
    }
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
