//
//  ViewController.m
//  PCChallenege
//
//  Created by Kaushik on 1/6/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCChallengeItemsViewController.h"
#import "PCChallengeAPIManager.h"
#import "PCCCollectionViewCell.h"
#import "PCChallengeItemsDataSource.h"
#import "PCCDetailViewController.h"
#import "PCCImageService.h"
#import "PCCSectionHeaderView.h"
#import "PCConstants.h"

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPHONE     ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD       ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

#define IS_IPHONE5    ( !IS_IPAD && IS_WIDESCREEN )


@interface PCChallengeItemsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *itemsView;
@property (nonatomic, strong) PCChallengeItemsDataSource *dataSource;
@property (nonatomic, strong) PCCImageService *imageService;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PCChallengeItemsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [[PCChallengeItemsDataSource alloc]init];
        _imageService = [[PCCImageService alloc]init];
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
    }
    return self;
}

- (void)loadView{
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.itemsView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.itemsView setDelegate:self];
    [self.itemsView setDataSource:self];
    self.itemsView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.itemsView];
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setColor:[UIColor blackColor]];
    [self.view addSubview:self.activityIndicator];
    
    [self.itemsView registerClass:[PCCCollectionViewCell class] forCellWithReuseIdentifier:kItemCellReuseIdentifier];
    [self.itemsView registerClass:[PCCSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kItemHeaderReuseIdentifier];
    NSDictionary *viewsDictionary = @{@"itemsView":self.itemsView,@"activity":self.activityIndicator};
    self.itemsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.itemsView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.itemsView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemsView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[itemsView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary]];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightRefreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshFeed:)];
    [self.navigationItem setRightBarButtonItem:rightRefreshButton];
    self.title = kItemsListVCTitle;
    [self fetchItemsAndLoadView];
}

- (void)showActivity{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

- (void)hideActivity{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}

- (void)refreshFeed:(id)sender{
    [self fetchItemsAndLoadView];
}

- (void)fetchItemsAndLoadView {
    __weak PCChallengeItemsViewController *vc = self;
    [self showActivity];
    [self.dataSource fetchAllItems:^(BOOL completed, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc hideActivity];
            [vc.itemsView reloadData];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PCCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([self.dataSource totalNumberOfItems]) {
            [cell setCellType:kCellHeaderType forItem:[self.dataSource objectAtIndex:0]];
        }
        return cell;
    }
    if ([self.dataSource totalNumberOfItems] && indexPath.row+1 < [self.dataSource totalNumberOfItems]) {
        [cell setCellType:kCellItemType forItem:[self.dataSource objectAtIndex:indexPath.row+1]];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [self.dataSource totalNumberOfItems]-1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PCCDetailViewController *detailView = [[PCCDetailViewController alloc] init];
    if (indexPath.section == 0) {
        detailView.item = [self.dataSource objectAtIndex:0];

    }else if (indexPath.row+1<[self.dataSource totalNumberOfItems]){
        detailView.item = [self.dataSource objectAtIndex:indexPath.row+1];
    }
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        PCCSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kItemHeaderReuseIdentifier forIndexPath:indexPath];
        [headerView.title setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
        [headerView.title setText:@"Previous Articles"];
        reusableview = headerView;
    }
    
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        int height = 250;
        if (IS_IPAD) {
            height = 400;
        }
        return CGSizeMake(collectionView.frame.size.width, height);
    }
    int numberOfRows = 2;
    if (IS_IPAD) {
        numberOfRows = 3;
    }
    int width = collectionView.frame.size.width/numberOfRows - (22);
    return CGSizeMake(width, width - (width *0.10));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 14, 5, 14);
    }
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 16;
    }
    
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(collectionView.frame.size.width, 50);
    }
    
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}



@end
