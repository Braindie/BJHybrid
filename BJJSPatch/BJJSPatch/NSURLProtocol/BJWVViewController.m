//
//  BJWVViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/10/28.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "BJWVViewController.h"

@interface BJWVViewController ()<UIWebViewDelegate>
/**
 *   webView
 */
@property (nonatomic, strong) UIWebView *myWebView;
@end

@implementation BJWVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://219.238.39.116:443/wallet/#/entryLink/"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://219.238.39.116:8901/wallet/"]];
    [_myWebView loadRequest:request];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{

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
