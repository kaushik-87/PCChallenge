//
//  PCChallengeItemsDataSource.h
//  PCChallenege
//
//  Created by Kaushik on 1/7/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCCItem.h"

@interface PCChallengeItemsDataSource : NSObject
//fetches the Items from the server with the completionBlock;
- (void)fetchAllItems:(void(^)(BOOL completed, NSError *error))completionBlock;

//objectAtIndex returns the object at the index.
- (PCCItem *)objectAtIndex:(NSUInteger)index;
//Returns total number of items in the data source.
- (NSUInteger)totalNumberOfItems;
@end
