//
//  BaseViewController.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 显示提示信息方法
- (void)showMessage:(NSString *)message {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.0f];
    hud.detailsLabel.text = message;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0f];
}

// 提示语弹窗
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
    [alertCtl addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:confirmAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
