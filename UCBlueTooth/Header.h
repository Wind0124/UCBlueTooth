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

// 设置屏幕宽度 高度
#define DEVICE_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH     [[UIScreen mainScreen] bounds].size.width

#endif /* Header_h */

