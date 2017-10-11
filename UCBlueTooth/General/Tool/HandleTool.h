//
//  HandleTool.h
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleTool : NSObject


+ (NSData *)sendCMD:(Byte)cmd contentString:(NSString *)contentString;
+ (NSData *)sendCMD:(Byte)cmd contentData:(NSData *)contentData;
// 将十进制数字字符串转换成十六进制的byte数组
+ (NSData *)convertStringToHex:(NSString *)tmpid;
// bool值 转换成data
+ (NSData *)boolValueConvertToHex:(BOOL)boolValue;
// 求和校验
+ (NSData *)sendDataSumCheck:(NSData *)data;
// 十进制转二进制
+ (NSString *)intToBinary:(int)intValue;
// 发送本地通知
+ (void)sendLocalNotifi:(NSString *)message;

@end
