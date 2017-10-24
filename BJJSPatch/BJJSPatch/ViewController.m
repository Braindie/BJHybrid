//
//  ViewController.m
//  BJJSPatch
//
//  Created by zhangwenjun on 17/3/7.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "ViewController.h"
#import "BJWebViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bjLabel;
@property (weak, nonatomic) IBOutlet UIButton *jpushBtn;
@property (weak, nonatomic) IBOutlet UIButton *webBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testAction];
    
    
    [self.jpushBtn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.webBtn addTarget:self action:@selector(webBtn:) forControlEvents:UIControlEventTouchUpInside];

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

- (void)testAction{
    self.bjLabel.text = @"初始值为0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
