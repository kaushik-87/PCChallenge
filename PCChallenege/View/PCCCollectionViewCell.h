//
//  PCCCollectionViewCell.h
//  PCChallenege
//
//  Created by Kaushik on 1/7/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCItem.h"

typedef NS_ENUM(NSUInteger, PCCCollectionViewCellType){
    kCellHeaderType,
    kCellItemType
};
@interface PCCCollectionViewCell : UICollectionViewCell
/*
 Allows to set the cell type based on the section.
 */
- (void)setCellType:(PCCCollectionViewCellType)type forItem:(PCCItem *)item;
@end
