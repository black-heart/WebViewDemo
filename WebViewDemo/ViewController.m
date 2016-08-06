//
//  ViewController.m
//  WebViewDemo
//
//  Created by lll on 16/8/6.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import "ViewController.h"
#import "WebPageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -80, self.view.frame.size.height/2, 160, 30)];
    button.titleLabel.text      = @"点击进入";
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:@"点击进入" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonPressed {

    WebPageViewController *vc = [[WebPageViewController alloc] init];
    [vc setPageNoHeaderWithUrl:@"http://www.baidu.com/"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
