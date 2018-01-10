//
//  PCCDetailViewController.m
//  PCChallenege
//
//  Created by Kaushik on 1/8/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

#import "PCCDetailViewController.h"

@interface PCCDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *detailView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PCCDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _item = [[PCCItem alloc]init];
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    }
    return self;
}
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    _detailView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.detailView setDelegate:self];
    [self.view addSubview:_detailView];
    
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator setColor:[UIColor blackColor]];
    [self.view addSubview:self.activityIndicator];
    
    NSDictionary *viewsDictionary = @{@"webview":self.detailView,@"activity":self.activityIndicator};
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;

    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.detailView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.detailView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webview]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[webview]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
}


- (void)loadViewFor:(PCCItem *)item{
    self.title = self.item.title;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?displayMobileNavigation=0",[item.link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
    [self.detailView loadRequest:[NSURLRequest requestWithURL:url]];
    [self showActivity];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadViewFor:self.item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showActivity{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

- (void)hideActivity{
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideActivity];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivity];
}


@end
