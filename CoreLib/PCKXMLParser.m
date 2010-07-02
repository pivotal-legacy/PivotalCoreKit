#import "PCKXMLParser.h"

@implementation PCKXMLParser

@end

#if 0
static xmlSAXHandler simpleSAXStruct;
xmlParserCtxt * context = xmlCreatePushParserCtxt(&simpleSAXStruct, self, NULL, 0, NULL);

#pragma mark SAX Parsing Callbacks

static void parserStartElement(void *context, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI,
                               int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes) {

    ConnectionXMLParser *parser = ((ConnectionXMLParser*)context);

    NSMutableString *elementName = [NSMutableString stringWithCString:(const char *)localname encoding:NSUTF8StringEncoding];

    if ([parser.modelClassName isEqual:elementName]) {
        [parser.delegate newModel];
    } else {
        parser.currentElement = elementName;
        parser.currentValue = [NSMutableString string];
    }
}

static void	parserEndElement(void *context, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI) {

    ConnectionXMLParser *parser = ((ConnectionXMLParser*)context);
    NSObject *delegate = parser.delegate;

    if (parser.currentValue && parser.currentElement && [parser.currentElement isEqualToString:[NSString stringWithCString:(const char *)localname encoding:NSUTF8StringEncoding]]) {
        [delegate setValue:parser.currentValue forKey:parser.currentElement];

        parser.currentElement = nil;
        parser.currentValue = nil;
    }
}

static void	parserCharactersFound(void *context, const xmlChar *characters, int length) {

    ConnectionXMLParser *parser = ((ConnectionXMLParser*)context);

    char buffer[length + 1];
    strncpy(buffer, (const char *)characters, length);
    buffer[length] = '\0';
    [parser.currentValue appendString:[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding]];
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
#endif
