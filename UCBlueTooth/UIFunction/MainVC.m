//
//  MainVC.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "MainVC.h"
#import "AlertPopView.h"
#import "BluetoothVC.h"

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

// 默认基本弹窗类型
- (IBAction)show:(UIButton *)sender {
    AlertPopView * popView = [[AlertPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    popView.infoString = @"Default Message";
    [popView show];
    popView.alertPopViewBlock = ^(BOOL isClosed) {
        
    };
}

// 进入蓝牙搜索页面
- (IBAction)BluetoothListAction:(UIButton *)sender {
    BluetoothVC *bluetoothVC = [[BluetoothVC alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:bluetoothVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
