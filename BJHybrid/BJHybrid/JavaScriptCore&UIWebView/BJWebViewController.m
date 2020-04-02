//
//  BJWebViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/9/21.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "BJWebViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "JSObjDelegate.h"


@interface BJWebViewController ()<UIWebViewDelegate,JSObjDelegate>
/**
 *   webView
 */
@property (nonatomic, strong) UIWebView *myWebView;
/**
 *   jiaohu
 */
@property (nonatomic, strong) JSContext *jsContext;//一个 Context 就是一个 JavaScript 代码执行的环境，也叫作用域。
@end

@implementation BJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UIWebView";
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.delegate = self;
    
    [self.view addSubview:_myWebView];
 
    
//    [self loadLocalHTML];
    
    [self loadOriginHTML];
    
//    [self useStringByEvaluatingJavaScriptFromString];

}


#pragma mark - 加载本地HTML
- (void)loadLocalHTML {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"myWebView"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
    
}

#pragma mark - 加载远程HTML
- (void)loadOriginHTML {
//    NSURL *baseUrl = [NSURL URLWithString:@"https://entu.alta.elenet.me"];
    
    NSString *urlStr = @"http://localhost:8080/#/";
    [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *baseUrl = [NSURL URLWithString:urlStr];

//    NSURL *baseUrl = [NSURL URLWithString:@"https://m.xiaobu121.com/xbtest3/app/app/introDetail?tid=t5a03fd1d540eb37637"];
    NSURLRequest *request = [NSURLRequest requestWithURL:baseUrl];
    
    // 设置之前保存的cookie
//    NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookies"];
//    if (cookies.count >0) {
//        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
//        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
//        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
//        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
//        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
//    }
    
    [_myWebView loadRequest:request];
}

#pragma mark - 代码注入,获取web基本信息
- (void)useStringByEvaluatingJavaScriptFromString {
    //获取当前页面的的title
    NSString *titleString = [_myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%@", titleString);
    
    // 获取当前页面的url
    NSString *urlString = [_myWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"%@", urlString);
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 获取js的上下文环境
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 把当前控制器赋给环境中的‘WTK’
    self.jsContext[@"WTK"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *ex){
        context.exception = ex;
        NSLog(@"异常信息%@",ex);
    };
    
    
    // 获取并保持cookies
//    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    for (NSHTTPCookie *cookie in nCookies){
//        if ([cookie isKindOfClass:[NSHTTPCookie class]]){
//            if ([cookie.name isEqualToString:@"STARGATE_ACCESS_TOKEN"]) {
//                NSNumber *sessionOnly =[NSNumber numberWithBool:cookie.sessionOnly];
//                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
//                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
//                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookies"];
//                break;
//            }
//        }
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - JSObjDelegate
//JS->OC
- (void)callCamera{
    //回主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"我是OC的提示框" message:@"我监听到了JS的召唤，我将要给他发送：你好，JS大哥" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //OC->JS
            JSValue *picCallBack = self.jsContext[@"picCallback"];
            [picCallBack callWithArguments:@[@"你好，JS大哥"]];//传值
        }];
        [actionSheet addAction:action1];
        [self presentViewController:actionSheet animated:YES completion:nil];
    });

}

//JS->OC
- (void)check:(NSString *)name{
    NSLog(@"js返回的name = %@",name);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"我是OC的提示框" message:name preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [actionSheet addAction:action1];
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
}

//JS->OC
- (void)share:(NSString *)shareInfo{

    //收到JS传来的数据
    NSLog(@"shareInfo===%@",shareInfo);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"我是OC的提示框" message:[NSString stringWithFormat:@"JS发来消息说：%@",shareInfo] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"回答" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //JS->OC
            JSValue *shareCallBack = self.jsContext[@"shareCallback"];
            [shareCallBack callWithArguments:@[@"我叫Braindie"]];
            //JS是弱类型的，ObjectiveC是强类型的，JSValue被引入处理这种类型差异，在Objective-C 对象和 JavaScript 对象之间起转换作用
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
}























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
