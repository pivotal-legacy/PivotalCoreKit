#import "PCKXMLParser.h"
#import "PCKXMLParserDelegate.h"
#import <libxml/tree.h>

static xmlSAXHandler simpleSAXStruct;

@interface PCKXMLParser()

@property (nonatomic, assign) xmlParserCtxt *parserContext;

@end


@implementation PCKXMLParser

@synthesize delegate = delegate_, parserContext = parserContext_;

- (id)init {
    @throw @"Use initWithDelegate to create a PCKXMLParser.";
}

- (id)initWithDelegate:(PCKXMLParserDelegate *)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.parserContext = xmlCreatePushParserCtxt(&simpleSAXStruct, delegate, NULL, 0, NULL);
    }
    return self;
}

- (void)dealloc {
    xmlFreeParserCtxt(self.parserContext);
    [super dealloc];
}

- (void)parseChunk:(NSData *)chunk {
    xmlParseChunk(self.parserContext, [chunk bytes], [chunk length], 0);
}

@end

#pragma mark SAX Parsing Callbacks

static void parserStartElement(void *context, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI,
                               int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes) {
    PCKXMLParserDelegate *delegate = (PCKXMLParserDelegate *)context;
    if (delegate.didStartElement) {
        delegate.didStartElement((const char *)localname);
    }
}

static void	parserEndElement(void *context, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI) {
    PCKXMLParserDelegate *delegate = (PCKXMLParserDelegate *)context;
    if (delegate.didEndElement) {
        delegate.didEndElement((const char *)localname);
    }
}

static void	parserCharactersFound(void *context, const xmlChar *characters, int length) {
    PCKXMLParserDelegate *delegate = (PCKXMLParserDelegate *)context;

    if (delegate.didFindCharacters) {
        char buffer[length + 1];
        strncpy(buffer, (const char *)characters, length);
        buffer[length] = '\0';
        delegate.didFindCharacters(buffer);
    }
}

static void parserErrorEncountered(void *context, const char *message, ...) {
    @throw @"Handle errors!";
}

static xmlSAXHandler simpleSAXStruct = {
    NULL,                       /* internalSubset */
    NULL,                       /* isStandalone   */
    NULL,                       /* hasInternalSubset */
    NULL,                       /* hasExternalSubset */
    NULL,                       /* resolveEntity */
    NULL,                       /* getEntity */
    NULL,                       /* entityDecl */
    NULL,                       /* notationDecl */
    NULL,                       /* attributeDecl */
    NULL,                       /* elementDecl */
    NULL,                       /* unparsedEntityDecl */
    NULL,                       /* setDocumentLocator */
    NULL,                       /* startDocument */
    NULL,                       /* endDocument */
    NULL,                       /* startElement*/
    NULL,                       /* endElement */
    NULL,                       /* reference */
    parserCharactersFound,      /* characters */
    NULL,                       /* ignorableWhitespace */
    NULL,                       /* processingInstruction */
    NULL,                       /* comment */
    NULL,                       /* warning */
    parserErrorEncountered,     /* error */
    NULL,                       /* fatalError //: unused error() get all the errors */
    NULL,                       /* getParameterEntity */
    NULL,                       /* cdataBlock */
    NULL,                       /* externalSubset */
    XML_SAX2_MAGIC,             //
    NULL,
    parserStartElement,         /* startElementNs */
    parserEndElement,           /* endElementNs */
    NULL,                       /* serror */
};
