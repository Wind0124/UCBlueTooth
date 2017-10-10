//
//  BaseViewController.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

// 显示提示信息方法
- (void)showMessage:(NSString *)message;
// 提示语弹窗
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;

@end
