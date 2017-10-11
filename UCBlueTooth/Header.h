//
//  Header.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#ifndef Header_h
#define Header_h

// Debug时打印Log，发布时禁止打印Log
//http://blog.csdn.net/win_mary/article/details/52813991
#ifdef DEBUG
#define NSLog(...)  NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

// APPID
#define APPID @"0123456789"

//---------------------------------------------
// 产品类型
#define PRODUCT_TYPE     @"ProductType"
// 蓝牙 服务 特征(写、读)
#define Data_Service            @"FFF0"
#define Data_Character_Write    @"FFF1"
#define Data_Character_Read     @"FFF2"
// 默认蓝牙设备名字
#define INIT_DEVICE_NAME @"BLEBLEBLE"
// 默认蓝牙初始化密码
#define INIT_DEVICE_PASSWORD @"123456"
// 上次连接蓝牙设备的UUID
#define DEVICE_LOCAL_UUID @"DEVICELOCALUUID"
// 上次连接蓝牙设备的名称
#define DEVICE_LOCAL_NAME @"DEVICELOCALNAME"
// 本地设备密码
#define DEVICE_LOCAL_PWD @"DEVICELOCALPWD"

//--------------------------------------------
// 系统通知中心Notification


//--------------------------------------------
// 颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
// 随机颜色
#define UCRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//#define MainColor RGB(255,255,255)
//描边
#define UCViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
//切圆角
#define UCViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//--------------------------------------------
// key Window
#define kWindow [UIApplication sharedApplication].keyWindow
// 设置屏幕宽度 高度
#define UC_SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define UC_SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
// 屏幕分辨率
// 320*480(5)  320*568(SE)
// 750*1334(7) 1125*2436(X) 1242*2208(7P)
#define WIDTH_RESOLUTION    (UC_SCREEN_WIDTH * ([UIScreen mainScreen].scale))
#define HEIGHT_RESOLUTION   (UC_SCREEN_HEIGHT * ([UIScreen mainScreen].scale))

#endif /* Header_h */

