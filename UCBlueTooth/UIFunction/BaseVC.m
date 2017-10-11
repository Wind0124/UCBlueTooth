//
//  BaseVC.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - 蓝牙设备
// 发送数据到蓝牙设备
- (void)sendDataToBlueTooth:(NSData *)sendData {
    if (![self checkBlueToothPeripheral]) {
        return;
    }
    NSLog(@"发送到蓝牙的数据： %@", sendData);
    // 发送数据
    [self.peripheral writeValue:sendData forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithoutResponse];
    // 订阅通知
    [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristicRead];
}

// 检验蓝牙设备
- (BOOL)checkBlueToothPeripheral {
    if (self.peripheral == NULL) {
        NSLog(@"蓝牙设备 为空");
        return NO;
    }
    if (self.peripheral.state != CBPeripheralStateConnected) {
        NSLog(@"蓝牙设备未连接... ");
        return NO;
    }
    return YES;
}

#pragma mark - 弹窗
// 显示提示信息方法
- (void)showMessage:(NSString *)message {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:kWindow];
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtl addAction:confirmAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark - 实现UINavigationControllerDelegate方法 实现动态隐藏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowMainPage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowMainPage animated:YES];
}

#pragma mark - 懒加载
- (BabyBluetooth *)babyBluetooth {
    if (!_babyBluetooth) {
        _babyBluetooth = [BabyBluetooth shareBabyBluetooth];
    }
    return _babyBluetooth;
}

#pragma mark - 内存回收
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
