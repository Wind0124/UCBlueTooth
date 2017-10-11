//
//  MainVC.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "MainVC.h"
#import "AlertPopView.h"

@interface MainVC ()<UINavigationControllerDelegate>

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 打开，隐藏tabbar
    self.navigationController.delegate = self;
    NSLog(@"abc");
//    NSLog(@"%@",self.babyBluetooth);
    
}

- (IBAction)show:(UIButton *)sender {
    AlertPopView * popView = [[AlertPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    popView.infoString = @"Default Message";
    [popView show];
    popView.alertPopViewBlock = ^(BOOL isClosed) {
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
