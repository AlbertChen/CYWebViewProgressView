//
//  WebViewController.m
//  WebViewDemo
//
//  Created by Chen Yiliang on 2020/3/6.
//  Copyright © 2020 cyl. All rights reserved.
//

#import "WebViewController.h"
#import "CYWebViewProgressView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebViewController () <WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)dealloc {
    WKUserContentController *contentController = self.webView.configuration.userContentController;
    [contentController removeScriptMessageHandlerForName:@"getCookies"];
    [contentController removeScriptMessageHandlerForName:@"nativeShare"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    configuration.userContentController = contentController;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
    CYWebViewProgressView *progressView = [[CYWebViewProgressView alloc] initWithFrame:frame];
    [self.webView setProgressView:progressView];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    // Add cookie
    WKUserScript *newCookieScript = [[WKUserScript alloc] initWithSource:@"document.cookie = 'token=123abc;'" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [contentController addUserScript:newCookieScript];
    
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:@"alert(document.cookie);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [contentController addUserScript:cookieScript];
    
    // Add JSSDK
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jssdk" ofType:@"js"];
    NSString *jssdkString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *jssdkScript = [[WKUserScript alloc] initWithSource:jssdkString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [contentController addUserScript:jssdkScript];
    
    // Add script message handler
    [contentController addScriptMessageHandler:self name:@"getCookies"];
    [contentController addScriptMessageHandler:self name:@"nativeShare"];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"getCookies"]) {
        NSLog(@"get cookies: %@", message.body);
    } else if ([message.name isEqualToString:@"nativeShare"]) {
        NSLog(@"share content: %@", message.body);
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"requst url: %@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"web view did start loading");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"web view did finished loading");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"web view did fail provisional loading");
}

@end
