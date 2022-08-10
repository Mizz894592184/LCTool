//
//  LCWebView.m
//  LCTool
//
//  Created by Joff on 2022/8/10.
//

#import "LCWebView.h"
#import "UIColor+LCColor.h"
#ifdef DEBUG
#define YS_DBG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define YS_DBG(format, ...) //NSLog(format, ## __VA_ARGS__)
#endif
@implementation LCWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame loadUrl:(nonnull NSURL *)url{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        _url = url;
    }
    return self;
}

#pragma mark -- 懒加载

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        _progressView.alpha = 0;
        _progressView.progressTintColor = [UIColor colorWithRGBHex:0xF02832];
    }
    return _progressView;
}

- (WKWebViewConfiguration *)config{
    if (!_config) {
        _config = [[WKWebViewConfiguration alloc]init];
        _config.userContentController = self.userCon;
    }
    return _config;
}

- (WKUserContentController *)userCon{
    if (!_userCon) {
        _userCon = [[WKUserContentController alloc]init];
    }
    return _userCon;
}

- (WKWebView *)webview{
    if (!_webview) {
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 2, self.frame.size.width, self.frame.size.height-2) configuration:self.config];
        _webview.navigationDelegate = self;
        _webview.UIDelegate = self;
//        _webview.scrollView.delegate = self;
//        _webview.allowsBackForwardNavigationGestures = YES;
    }
    return _webview;
}

#pragma mark -- Dealloc
- (void)dealloc
{
    [self.webview removeObserver:self forKeyPath:@"loading"];
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark --Action

- (void)createView{
    [self addSubview:self.progressView];
    [self addSubview:self.webview];
    
    //添加KVO监听
    [self.webview addObserver:self
                     forKeyPath:@"loading"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.webview addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)loadUrl{
    [self.webview loadRequest:[NSURLRequest requestWithURL:_url]];
}

#pragma mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    YS_DBG(@"加载完成");
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    YS_DBG(@"开始加载");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    YS_DBG(@"加载失败");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    YS_DBG(@"网页加载内容进程终止");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    YS_DBG(@"开始接受网页内容");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    YS_DBG(@"跳转到其他的服务器");
}


#pragma mark - KVO监听函数
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"loading"]){
        YS_DBG(@"loading");
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]){
        //estimatedProgress取值范围是0-1;
        //estimatedProgress取值范围是0-1;
        CGFloat process = self.webview.estimatedProgress < 0.2 ?0.2:self.webview.estimatedProgress;
        [self.progressView setProgress:process animated:YES];
    }
    
    if (!self.webview.loading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        
//        self.title = self.wkWebview.title;
    }
    
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    YS_DBG(@"%@",message.body);
    if ([self.delegate respondsToSelector:@selector(jsToOcMessage:)]) {
        [self.delegate jsToOcMessage:message];
    }
    
}



#pragma mark -- 外部方法
-(void)addScriptMessageName:(NSString *)name{
//    NSLog(@"--webview:%@---",self.webview);
    [self.userCon addScriptMessageHandler:self name:name];
}

- (void)sendJS:(NSString *)jsString{
    [self.webview evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@ - %@",result, [result class]);
    }];
}
@end
