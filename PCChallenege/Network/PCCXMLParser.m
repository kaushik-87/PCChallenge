//
//  PCCXMLParser.m
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCCXMLParser.h"
#import "PCCItem.h"
#import "PCConstants.h"


@interface PCCXMLParser()
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *element;
@property (nonatomic, strong) PCCItem *item;
@property (nonatomic, strong) NSMutableString *title;
@property (nonatomic, strong) NSMutableString *publicationDate;
@property (nonatomic, strong) NSDictionary  *mediaContentDictionary;
@property (nonatomic, strong) NSMutableString  *link;
@property (nonatomic, strong) NSMutableString  *itemDescription;
@property (nonatomic, strong) NSMutableData     *descriptionData;
@end

@implementation PCCXMLParser

- (void)parseData:(NSData *)data completionBlock:(MyCompletionBlock)completion
{
    self.completion = completion;
    _parser = [[NSXMLParser alloc]initWithData:data];
    _items = [[NSMutableArray alloc]init];
    [self.parser setDelegate:self];
    [self.parser parse];
    
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    _element = elementName;
    if ([_element isEqualToString:kItemKey]) {
        _item    = [[PCCItem alloc] init];
    }
    
    if ([_element isEqualToString:kItemTitleKey]) {
        _title    = [[NSMutableString alloc] init];
    }

    if ([_element isEqualToString:kItemPublishDateKey]) {
        _publicationDate    = [[NSMutableString alloc] init];
    }
    
    if ([_element isEqualToString:kItemLinkKey]) {
        _link    = [[NSMutableString alloc] init];
    }
    
    if ([_element isEqualToString:kItemDescriptionKey]) {
        _itemDescription    = [[NSMutableString alloc] init];
        _descriptionData    = [[NSMutableData alloc] init];
    }
    
    if ([_element isEqualToString:kItemMediaKey]) {
        _mediaContentDictionary    = [[NSDictionary alloc] initWithDictionary:attributeDict];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([_element isEqualToString:kItemTitleKey]) {
        [self.title appendString:string];
    }
    if ([_element isEqualToString:kItemPublishDateKey]) {
        [self.publicationDate appendString:string];
    }
    if ([_element isEqualToString:kItemLinkKey]) {
        [self.link appendString:string];
    }
    if ([_element isEqualToString:kItemDescriptionKey]) {
        [self.itemDescription appendString:string];
    }

}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
    [self.descriptionData appendData:CDATABlock];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kItemKey]) {
        [self.items addObject:[self.item copy]];
    }
    
    if ([elementName isEqualToString:kItemTitleKey]) {
        self.item.title = self.title;
    }
    
    if ([elementName isEqualToString:kItemPublishDateKey]) {
        self.item.publicationDate = self.publicationDate;
    }
    
    if ([elementName isEqualToString:kItemLinkKey]) {
        self.item.link = [self.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if ([elementName isEqualToString:kItemDescriptionKey]) {
        NSString *description = [[NSString alloc]initWithData:self.descriptionData encoding:NSUTF8StringEncoding];
        self.item.itemDescription = description;
    }
    
    if ([elementName isEqualToString:kItemMediaKey]) {
        self.item.mediaContentInfo = self.mediaContentDictionary;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (self.completion) {
        self.completion(self.items, nil);
    }
    
}
@end
