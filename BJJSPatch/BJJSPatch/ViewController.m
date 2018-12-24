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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *bjLabel;
@property (weak, nonatomic) IBOutlet UIButton *jpushBtn;
@property (weak, nonatomic) IBOutlet UIButton *webBtn;
@property (weak, nonatomic) IBOutlet UIButton *bridgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testAction];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    
    [self.jpushBtn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.webBtn addTarget:self action:@selector(webBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.bridgeBtn addTarget:self action:@selector(bridgeBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.protocolBtn addTarget:self action:@selector(protocalBtn:) forControlEvents:UIControlEventTouchUpInside];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.numberOfLines = 0;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"JSPatch";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"NSURLProtocol";

    }else if (indexPath.row == 2){
        cell.textLabel.text = @"JavaScriptCore";

    }else if (indexPath.row == 3){
        cell.textLabel.text = @"WebViewJavascriptBridge";

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//使用JSPatch完成跳转
- (void)handleBtn:(id)sender{
    //http://www.jspatch.com/Apps/patch/id/24381
}


//跳转到下一个界面
- (void)webBtn:(id)sender{
    BJWebViewController *vc = [[BJWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到下一个界面
- (void)bridgeBtn:(id)sender{
    
    WebViewJavascriptBridgeViewController *vc = [[WebViewJavascriptBridgeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到下一个界面
- (void)protocalBtn:(id)sender{
    
    BJWVViewController *vc = [[BJWVViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testAction{
    self.bjLabel.text = @"初始值为0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
