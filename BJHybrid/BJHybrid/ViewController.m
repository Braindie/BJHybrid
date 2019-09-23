//
//  ViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 17/3/7.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "ViewController.h"
#import "BJWebViewController.h"
#import "WebViewJavascriptBridgeViewController.h"
#import "BJWVViewController.h"
#import "BJWKWebViewViewController.h"
#import "BJHybrid-Swift.h"

#import "BJWKWebViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testAction];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.numberOfLines = 0;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"JSPatch";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"NSURLProtocol";

    }else if (indexPath.row == 2){
        cell.textLabel.text = @"UIWebView（JavaScriptCore）";

    }else if (indexPath.row == 3){
        cell.textLabel.text = @"UIWebView（WebViewJavascriptBridge）";

    }else if (indexPath.row == 4){
        cell.textLabel.text = @"WKWebView（WebKit)";
        
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"WKWebView（WKWebViewJavascriptBridge）";

    }else if (indexPath.row == 6){
        cell.textLabel.text = @"WKWebView";
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {

    }else if (indexPath.row == 1){
        BJWVViewController *vc = [[BJWVViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 2){
        BJWebViewController *vc = [[BJWebViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 3){
        WebViewJavascriptBridgeViewController *vc = [[WebViewJavascriptBridgeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 4){
        BJWKWebViewViewController *vc = [[BJWKWebViewViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if (indexPath.row == 5){
        // Swift文件
        WKWebViewController *vc = [WKWebViewController new];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 6){
        BJWKWebViewController *vc = [[BJWKWebViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)testAction{
    NSLog(@"JSPatch");
//    self.bjLabel.text = @"初始值为0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
