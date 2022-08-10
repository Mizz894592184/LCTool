//
//  LCViewController.m
//  LCTool
//
//  Created by Joff on 08/02/2022.
//  Copyright (c) 2022 Joff. All rights reserved.
//

#import "LCViewController.h"
//#import "UIView+TransitionColor.h"
//#import "LCWebView.h"
#import "LCTool.h"
@interface LCViewController ()<LCWebViewDelegate>

@end

@implementation LCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createView];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)createView{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
//    [view addTransitionTopColor:UIColor.redColor endBottomColor:UIColor.yellowColor];
//    [self.view addSubview:view];
    LCWebView *webView = [[LCWebView alloc]initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-30) loadUrl:[NSURL URLWithString:@"http://cms.clovsoft.com:10001/app"]];
    [webView addScriptMessageName:@"scanOrcodeIOS"];
    webView.progressView.hidden= YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jsToOcMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"--name:%@---body:%@--",message.name,message.body);
}


@end
