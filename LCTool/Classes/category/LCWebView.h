//
//  LCWebView.h
//  LCTool
//
//  Created by Joff on 2022/8/10.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol LCWebViewDelegate <NSObject>

-(void)jsToOcMessage:(WKScriptMessage *)message;

@end

@interface LCWebView : UIView<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>{
    NSURL *_url;
}
@property(nonatomic, strong)WKWebView *webview;
//进度条
@property(nonatomic,strong)UIProgressView *progressView;

@property(nonatomic, strong)WKWebViewConfiguration *config;

@property(nonatomic, strong)WKUserContentController *userCon;

@property (nonatomic, weak) id<LCWebViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame loadUrl:(NSURL *)url;

-(void)addScriptMessageName:(NSString *)name;

- (void)loadUrl;

- (void)sendJS:(NSString *)jsString;

@end

NS_ASSUME_NONNULL_END
