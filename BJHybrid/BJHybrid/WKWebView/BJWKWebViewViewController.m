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
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight) configuration:configuration];
        
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"index.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [_wkWebView loadRequest:request];
//        _wkWebView.navigationDelegate = self;
//        _wkWebView.UIDelegate = self;
        
        [userContentController addScriptMessageHandler:self name:@"currentCookies"];
    }
    return _wkWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.wkWebView];
}

#pragma mark - WKScriptMessageHandler
//JS->OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"currentCookies"]) {
        NSString *cookiesStr = [NSString stringWithFormat:@"%@",message.body];
        NSLog(@"当前的cookie为： %@", cookiesStr);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:cookiesStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



@end
