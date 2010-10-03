#import "PCKJSONParser.h"
#import "PCKJSONParserDelegate.h"

@interface PCKJSONParser ()
@property (nonatomic, assign) PCKJSONParserDelegate *delegate;
@property (nonatomic, retain) YAJLParser *parser;
@end

@implementation PCKJSONParser

@synthesize delegate = delegate_, parser = parser_;

- (id)init {
    @throw @"Use initWithDelegate to create a PCKJSONParser.";
}

- (id)initWithDelegate:(PCKJSONParserDelegate *)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        parser_ = [[YAJLParser alloc] init];
        self.parser.delegate = self;
    }
    return self;
}

- (void)dealloc {
    [parser_ release];
    [super dealloc];
}

- (void)parseChunk:(NSData *)chunk {
    YAJLParserStatus status = [self.parser parse:chunk];

    if (YAJLParserStatusInsufficientData != status && YAJLParserStatusOK != status) {
        [self.delegate parser:self didEncounterError:self.parser.parserError];
    }
}

#pragma mark YAJLParserDelegate
- (void)parserDidStartDictionary:(YAJLParser *)parser {
    [self.delegate parserDidStartDictionary:self];
}
- (void)parserDidEndDictionary:(YAJLParser *)parser {
    [self.delegate parserDidEndDictionary:self];
}

- (void)parserDidStartArray:(YAJLParser *)parser {
    [self.delegate parserDidStartArray:self];
}
- (void)parserDidEndArray:(YAJLParser *)parser {
    [self.delegate parserDidEndArray:self];
}

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key {
    [self.delegate parser:self didFindKey:key];
}
- (void)parser:(YAJLParser *)parser didAdd:(id)value {
    [self.delegate parser:self didFindValue:value];
}


@end
