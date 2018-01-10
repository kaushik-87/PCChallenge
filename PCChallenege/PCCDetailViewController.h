//
//  PCCDetailViewController.h
//  PCChallenege
//
//  Created by Kaushik on 1/8/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCItem.h"
@interface PCCDetailViewController : UIViewController
@property (nonatomic, strong) PCCItem *item;
- (void)loadViewFor:(PCCItem*)item;

@end
