//
//  ViewController.m
//  WebViewDemo
//
//  Created by Chen Yiliang on 2020/3/6.
//  Copyright © 2020 cyl. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showWebViewController:(id)sender {
    WebViewController *viewController = [[WebViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
