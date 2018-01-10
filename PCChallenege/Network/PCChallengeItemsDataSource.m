//
//  PCChallengeItemsDataSource.m
//  PCChallenege
//
//  Created by Kaushik on 1/7/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCChallengeItemsDataSource.h"
#import "PCChallengeAPIManager.h"
#import "PCCXMLParser.h"
#import "PCConstants.h"

@interface PCChallengeItemsDataSource()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation PCChallengeItemsDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];

    }
    return self;
}

//fetches the Items from the server with the completionBlock;
- (void)fetchAllItems:(void(^)(BOOL completed, NSError *error))completionBlock{
    [self.items removeAllObjects];
    __weak PCChallengeItemsDataSource *weakDataSource = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PCChallengeAPIManager *apiManager = [PCChallengeAPIManager sharedManager];
        [apiManager loadRequestWithPath:kItemsListURL completion:^(id data, NSError *error) {
            
            if (data) {
                PCCXMLParser *parser = [[PCCXMLParser alloc]init];
                [parser parseData:data completionBlock:^(NSArray *items, NSError *error) {
                    [weakDataSource.items addObjectsFromArray:items];
                }];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
        }];
    });

    
}

//objectAtIndex returns the object at the index.
- (PCCItem *)objectAtIndex:(NSUInteger)index{
    return [self.items objectAtIndex:index];
}
//Returns total number of items in the data source.
- (NSUInteger)totalNumberOfItems{
    return self.items.count;
}

@end
