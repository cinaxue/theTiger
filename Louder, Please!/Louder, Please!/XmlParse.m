//
//  XmlParse.m
//  TestAppstoreRss
//
//  Created by Hepburn on 11-10-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XmlParse.h"
#import "Constants.h"

#define REPLACECHA @"[[iHope]]"

@implementation XmlParse

@synthesize delegate, OnParseXML, mArray, mDict;

- (void)XmlParseData:(NSMutableData *)data {
    //NSString *theXML = [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
//    NSString *theXML = [[NSString alloc]initWithData:data
//                                             encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"要解析的文件：%@", theXML);
//    NSMutableString *strxml = [NSMutableString stringWithString:theXML];
//    [strxml replaceOccurrencesOfString:@"&" withString:REPLACECHA options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strxml length])];
//    NSData *data1 = [strxml dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    xmlParser.delegate = self;
    [xmlParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    [mArray removeAllObjects];
    [mArray2 removeAllObjects];
	[mDict removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict {    
    [todoString setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[todoString appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	//NSLog(@"didEndElement:%@:%@", elementName, todoString);
    if ([elementName isEqualToString:@"ns1:ArrayOfString"]) {
        [mArray addObject:[NSArray arrayWithArray:mArray2]];
       // [mArray arrayByAddingObjectsFromArray:mArray2];
        //mArray = [[NSMutableArray alloc]initWithArray:mArray2];
        [mArray2 removeAllObjects];
    }
    else if ([elementName isEqualToString:@"ns1:string"] || [elementName isEqualToString:@"ns1:out"]) {
        NSMutableString *sValue = [NSMutableString stringWithString:todoString];
        [sValue replaceOccurrencesOfString:REPLACECHA withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [sValue length])];
        //NSLog(@"%@",sValue);
        [mArray2 addObject:sValue];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (delegate && OnParseXML) {
        if ([mArray2 count]>0 && [mArray count]==0) {
            mArray = [mArray2 retain];
        }
        [delegate performSelector:OnParseXML withObject:self];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        mArray = [[NSMutableArray alloc] init];
        mArray2 = [[NSMutableArray alloc] init];
        mDict = [[NSMutableDictionary alloc] init];
        todoString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc {
	[todoString release];
	[mDict release];
    [mArray release];
    [mArray2 release];
	
    [super dealloc];
}

@end
