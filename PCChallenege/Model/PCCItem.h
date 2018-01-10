//
//  PCCItem.h
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PCCItem : NSObject<NSCopying>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, strong) NSDictionary *mediaContentInfo;
@property (nonatomic, copy) NSString *publicationDate;
@property (nonatomic, copy) NSString *link;
@end
