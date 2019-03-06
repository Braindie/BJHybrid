//
//  BJWKWebViewController.m
//  BJHybrid
//
//  Created by zhangwenjun on 2019/3/6.
//  Copyright © 2019 zhangwenjun. All rights reserved.
//

#import "BJWKWebViewController.h"

#import <WebKit/WebKit.h>

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface BJWKWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation BJWKWebViewController

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //内容交互控制类，自己注入JS代码及JS调用原生方法注册，在delloc时需要移除注入
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight) configuration:configuration];
        _wkWebView.navigationDelegate = self;
//        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.wkWebView];
    
//        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"index.html"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.wkWebView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //使用KVO监听estimatedProgress属性，获取网页加载进度
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"currentCookies"];
}

- (void)dealloc
{
    NSLog(@"销毁了");
}

#pragma mark - KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"estimatedProgress = %f",self.wkWebView.estimatedProgress);
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    //WKWebView的-evaluateJavaScript:completionHandler:方法可以执行JS代码。但只有在整个webView加载完成之后调用此方法才会有响应。比如：我们可以通过如下方式获取JS的标题。
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
        self.navigationItem.title = title;
    }];
}

@end
