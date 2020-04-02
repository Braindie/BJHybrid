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

@interface BJWKWebViewViewController ()<WKScriptMessageHandler>
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
    }
    return _wkWebView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 60, 20);
    [rightBtn setTitle:@"点我" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    
    [self.view addSubview:self.wkWebView];
    
    //JS调用OC的实现
    //会导致循环引用
    
    //约定接收消息的对象，OC与JS约定好name
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"bj"];
}

- (void)dealloc
{
    NSLog(@"销毁了");
}

#pragma mark - methods
- (void)rightBtnAction:(UIButton *)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSInteger x = arc4random();
        NSString *str = [NSString stringWithFormat:@"alertAction('%ld')", x];
        //OC->JS
        [self.wkWebView evaluateJavaScript:str completionHandler:^(id response, NSError *error) {
            // 回调
            NSLog(@"response == %@",response);
        }];
    });
}

#pragma mark - WKScriptMessageHandler
//JS->OC
//回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"bj"]) {
        NSString *cookiesStr = [NSString stringWithFormat:@"%@",message.body];
        NSLog(@"当前的cookie为： %@", cookiesStr);
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:cookiesStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
