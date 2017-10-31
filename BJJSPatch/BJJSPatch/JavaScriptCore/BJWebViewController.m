//
//  BJWebViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/9/21.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "BJWebViewController.h"
#import <QuickLook/QuickLook.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "BJjsContext.h"
#import "JSObjDelegate.h"


@interface BJWebViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource,UIWebViewDelegate,JSObjDelegate>
/**
 *   webView
 */
@property (nonatomic, strong) UIWebView *myWebView;
/**
 *   jiaohu
 */
@property (nonatomic, strong) BJjsContext *jsContext;
@end

@implementation BJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self showQuickLook];
    

    
    
    
    
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
//JS调用OC的方法
- (void)callCamera{
    NSLog(@"调用摄像头");
    //OC调用JS方法
    JSValue *picCallBack = self.jsContext[@"picCallback"];
    [picCallBack callWithArguments:@[@"张文军"]];//传值
}

//JS调用OC的方法
- (void)share:(NSString *)shareInfo{
    NSLog(@"shareInfo===%@",shareInfo);
    //OC调用JS方法
    JSValue *shareCallBack = self.jsContext[@"shareCallback"];
    [shareCallBack callWithArguments:nil];
}

- (void)check:(NSString *)name{
    NSLog(@"js返回的name = %@",name);
    [self.navigationController popViewControllerAnimated:YES];
}





















- (void)showQuickLook{
    QLPreviewController * qlPreview = [[QLPreviewController alloc]init];
    qlPreview.dataSource = self; //需要打开的文件的信息要实现dataSource中的方法
    qlPreview.delegate = self;  //视图显示的控制
    [self presentViewController:qlPreview animated:YES completion:^{
        //需要用模态化的方式进行展示
    }];
}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 3; //需要显示的文件的个数
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    //返回要打开文件的地址，包括网络或者本地的地址
//    NSURL * url = [NSURL fileURLWithPath:@"http://cbt3.oss-cn-qingdao.aliyuncs.com/loan/700436_253069.pdf?Expires=1821234065&OSSAccessKeyId=vxvDfbmso9LsYzeK&Signature=Sk8riD3pbwTLQc4d2MkiUGq813A%3D"];
//    NSURL * url = [NSURL fileURLWithPath:@"http://cbt3.oss-cn-qingdao.aliyuncs.com/loan/700436_253069.pdf"];
    NSURL * url = [NSURL fileURLWithPath:@"http://www.baidu.com"];

    return url;
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
