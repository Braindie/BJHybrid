//
//  BJWKWebViewViewController.m
//  BJHybrid
//
//  Created by zhangwenjun on 2019/1/2.
//  Copyright © 2019 zhangwenjun. All rights reserved.
//

#import "BJWKWebViewViewController.h"
#import <WebKit/WebKit.h>

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface BJWKWebViewViewController ()<WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation BJWKWebViewViewController

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        //内容交互控制类，自己注入JS代码及JS调用原生方法注册，在delloc时需要移除注入
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight) configuration:configuration];
        
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"index.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [_wkWebView loadRequest:request];
        _wkWebView.navigationDelegate = self;
//        _wkWebView.UIDelegate = self;
        

    }
    return _wkWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildRightBtn];

    [self.view addSubview:self.wkWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //JS调用OC的实现
    //为userContentController添加ScriptMessageHandler，OC与JS约定好name
    //会导致循环引用
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"currentCookies"];
    
    
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

#pragma mark
- (void)rightBtnAction:(UIButton *)sender{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //OC调用JS的实现
        [self.wkWebView evaluateJavaScript:@"alertAction('OCmassage')" completionHandler:^(id response, NSError *error) {
            NSLog(@"response == %@",response);
        }];
    });
    
}

#pragma mark - KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"estimatedProgress = %f",self.wkWebView.estimatedProgress);
    }
}



#pragma mark - WKScriptMessageHandler
//JS->OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"currentCookies"]) {
        NSString *cookiesStr = [NSString stringWithFormat:@"%@",message.body];
        NSLog(@"当前的cookie为： %@", cookiesStr);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"我是OC提示框" message:cookiesStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //WKWebView的-evaluateJavaScript:completionHandler:方法可以执行JS代码。但只有在整个webView加载完成之后调用此方法才会有响应。比如：我们可以通过如下方式获取JS的标题。
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
        self.navigationItem.title = title;
    }];
}





#pragma mark -
- (void)buildRightBtn{
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 60, 20);
    [rightBtn setTitle:@"调JS" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}


@end
