//
//  PCCItem.m
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCCItem.h"

@implementation PCCItem


- (id)copyWithZone:(nullable NSZone *)zone{
    PCCItem *item = [[[self class] allocWithZone:zone] init];
    
    item.title = self.title;
    item.itemDescription = self.itemDescription;
    item.mediaContentInfo = self.mediaContentInfo;
    item.link = self.link;
    item.publicationDate = self.publicationDate;
    return item;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<PCCItem: %@, Link:%@, Media%@, Desc: %@, PubDate: %@>",
            self.title, self.link, self.mediaContentInfo, self.itemDescription, self.publicationDate];
}

@end
