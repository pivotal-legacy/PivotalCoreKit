#import "PCKJSONParserDelegate.h"

@implementation PCKJSONParserDelegate

@synthesize didStartDictionary = didStartDictionary_, didEndDictionary = didEndDictionary_;
@synthesize didStartArray = didStartArray_, didEndArray = didEndArray_;
@synthesize didFindKey = didFindKey_, didFindValue = didFindValue_;
@synthesize didEncounterError = didEncounterError_;

- (void)dealloc {
    self.didStartDictionary = nil;
    self.didEndDictionary = nil;
    self.didStartArray = nil;
    self.didEndArray = nil;
    self.didFindKey = nil;
    self.didFindValue = nil;
    self.didEncounterError = nil;
    [super dealloc];
}

- (void)parserDidStartDictionary:(PCKJSONParser *)parser {
    if (self.didStartDictionary) {
        self.didStartDictionary();
    }
}

- (void)parserDidEndDictionary:(PCKJSONParser *)parser {
    if (self.didEndDictionary) {
        self.didEndDictionary();
    }
}

- (void)parserDidStartArray:(PCKJSONParser *)parser {
    if (self.didStartArray) {
        self.didStartArray();
    }
}

- (void)parserDidEndArray:(PCKJSONParser *)parser {
    if (self.didEndArray) {
        self.didEndArray();
    }
}

- (void)parser:(PCKJSONParser *)parser didFindKey:(NSString *)key {
    if (self.didFindKey) {
        self.didFindKey(key);
    }
}

- (void)parser:(PCKJSONParser *)parser didFindValue:(id)value {
    if (self.didFindValue) {
        self.didFindValue(value);
    }
}

#pragma mark PCKParserDelegate
- (void)parser:(id<PCKParser>)parser didEncounterError:(NSError *)error {
    if (self.didEncounterError) {
        self.didEncounterError(error);
    }
}

@end
