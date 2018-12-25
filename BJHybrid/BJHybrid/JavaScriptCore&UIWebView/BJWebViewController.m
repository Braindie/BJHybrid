//
//  BJWebViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/9/21.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "BJWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BJjsContext.h"
#import "JSObjDelegate.h"


@interface BJWebViewController ()<UIWebViewDelegate,JSObjDelegate>
/**
 *   webView
 */
@property (nonatomic, strong) UIWebView *myWebView;
/**
 *   jiaohu
 */
@property (nonatomic, strong) BJjsContext *jsContext;//一个 Context 就是一个 JavaScript 代码执行的环境，也叫作用域。
@end

@implementation BJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"UIWebView";
    
    
    
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.delegate = self;
    
    [self.view addSubview:_myWebView];
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"myWebView"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
    
    
//    [_myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"CallBackFunction();"]];
//    NSString *str1 = @"acousticInteractionInitFun";
//    NSString *str2 = @"{\"mid\": \"商户号（00002020）\",\"token\": \"2019999002221111(交易token/用户token)\",\"md5key\": \"fasdjf32kdfkslskkj\",\"orderId\": \"201710231025\",\"amount\": \"12.5\",\"type\": \"cashier\"}";
//    NSString *str = [_myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"CallBackFunction('%@'，'%@');",str1,str2]];
//    NSLog(@"js返回值:%@",str);
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"WTK"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *ex){
        context.exception = ex;
        NSLog(@"异常信息%@",ex);
    };
}

#pragma mark - JSObjDelegate
//JS->OC
- (void)callCamera{
    //回主线程
    dispatch_sync(dispatch_get_main_queue(), ^{
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
    
    //不知道为啥，这个回主线程就崩溃了
//    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"我是OC的提示框" message:name preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [actionSheet addAction:action1];
        [self presentViewController:actionSheet animated:YES completion:nil];
//    });

}

#pragma mark -
//JS->OC
- (void)share:(NSString *)shareInfo{

    //收到JS传来的数据
    NSLog(@"shareInfo===%@",shareInfo);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
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
