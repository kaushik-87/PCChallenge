//
//  PCCSectionHeaderView.m
//  PCChallenege
//
//  Created by Kaushik on 1/9/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCCSectionHeaderView.h"

@implementation PCCSectionHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.title];
}
@end
