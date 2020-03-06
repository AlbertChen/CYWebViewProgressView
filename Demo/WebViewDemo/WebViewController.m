//
//  WebViewController.m
//  WebViewDemo
//
//  Created by Chen Yiliang on 2020/3/6.
//  Copyright © 2020 cyl. All rights reserved.
//

#import "WebViewController.h"
#import "CYWebViewProgressView.h"

@interface WebViewController () <WKUIDelegate>

@property (nonatomic, weak) IBOutlet WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
    CYWebViewProgressView *progressView = [[CYWebViewProgressView alloc] initWithFrame:frame];
    [self.webView setProgressView:progressView];
    
    self.webView.allowsBackForwardNavigationGestures = YES;
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WKUIDelegate

@end
