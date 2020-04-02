//
//  ViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 17/3/7.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "ViewController.h"

#import "BJWVViewController.h"

#import "BJUIWebViewController.h"

#import "BJWebViewController.h"
#import "WebViewJavascriptBridgeViewController.h"
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


#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 3;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.numberOfLines = 0;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"JSPatch";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"NSURLProtocol";
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"UIWebView";

        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"UIWebView（JavaScriptCore）";

        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"UIWebView（WebViewJavascriptBridge）";

        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"WKWebView";

        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"WKWebView（WebKit)";

        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"WKWebView（WKWebViewJavascriptBridge）";

        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {

        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            BJWVViewController *vc = [[BJWVViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            BJUIWebViewController *vc = [[BJUIWebViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            BJWebViewController *vc = [[BJWebViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            WebViewJavascriptBridgeViewController *vc = [[WebViewJavascriptBridgeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            BJWKWebViewController *vc = [[BJWKWebViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            BJWKWebViewViewController *vc = [[BJWKWebViewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            // Swift文件（插件）
            WKWebViewController *vc = [WKWebViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

#pragma mark - methods
- (void)testAction{
    NSLog(@"JSPatch");
//    self.bjLabel.text = @"初始值为0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
