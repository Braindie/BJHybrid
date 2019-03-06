//
//  WebViewJavascriptBridgeViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/10/25.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "WebViewJavascriptBridgeViewController.h"
#import "WebViewJavascriptBridge.h"//最新版>=6.0，之前导入的是5.0结果没反应，坑了大把时间，擦

@interface WebViewJavascriptBridgeViewController ()
/**
 *   bridge
 */
@property WebViewJavascriptBridge* bridge;
@end

@implementation WebViewJavascriptBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"WebViewJavascriptBridge";
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 60, 20);
    [rightBtn setTitle:@"OC->JS" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    //初始化  WebViewJavascriptBridge
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [self loadHTMLPage:webView];


    /* 关键代码 */
    //注册处理：注册完后JS如果有请求，Block块内就会有反应（Handler必须与JS中的保持一致，之前搞反了，坑了大把时间，擦）
//    registerAction
//    submitFromWeb
    [self.bridge registerHandler:@"registerAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        //log居然没反应，这里好像要用JS的语法
        NSLog(@"%@",data);
        [self logString:data];

        // responseCallback 给后台的回复
        responseCallback(@"来自OC的更新数据");
    }];

}

- (void)logString:(NSString *)string{
    NSLog(@"%@",string);
}


#pragma mark -
- (void)rightBtnAction:(UIButton *)sender{
    
    /* 关键代码 */

     /*
     含义：OC调用JS
     @param callHandler 商定的事件名称,用来调用网页里面相应的事件实现
     @param data id类型,相当于我们函数中的参数,向网页传递函数执行需要的参数
     注意，这里callHandler分3种，根据需不需要传参数和需不需要后台返回执行结果来决定用哪个
     */
//    NSString *json = nil;
//    NSDictionary *dictionary = @{@"amount":@"12.5",@"md5key":@"fasdjf32kdfkslskkj",@"mid":@"111",@"orderId":@"201711031626",@"token":@"00fa92b4-9c5b-43e0-b5df-6709d2026cde",@"type":@"cashier"};
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
//    json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [_bridge callHandler:@"loginAction" data:@"我是OC给JS的参数" responseCallback:^(id responseData) {
        //处理JS回调的数据responseData
        NSString *str = [NSString stringWithFormat:@"%@",responseData];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"我是OC的提示框" message:str preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 初始化方法
- (void)loadHTMLPage:(UIWebView *)webView{
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://219.238.39.116:8901/wallet/"]];
//    [webView loadRequest:request];
}

@end
