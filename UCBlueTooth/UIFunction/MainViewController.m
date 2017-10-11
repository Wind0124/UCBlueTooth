//
//  MainViewController.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 打开，隐藏tabbar
    self.navigationController.delegate = self;
    NSLog(@"abc");
//    NSLog(@"%@",self.babyBluetooth);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
