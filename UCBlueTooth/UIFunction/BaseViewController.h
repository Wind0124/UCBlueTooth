//
//  BaseViewController.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) BabyBluetooth *babyBluetooth;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *characteristicWrite;
@property (nonatomic, strong) CBCharacteristic *characteristicRead;

// 发送数据到蓝牙设备
- (void)sendDataToBlueTooth:(NSData *)sendData;
// 检验蓝牙设备
- (BOOL)checkBlueToothPeripheral;

// 显示提示信息方法
- (void)showMessage:(NSString *)message;
// 提示语弹窗
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;

@end
