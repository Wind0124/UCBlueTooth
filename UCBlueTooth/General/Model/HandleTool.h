//
//  HandleTool.h
//  BlazerBLE
//
//  Created by SongMenglong on 2017/6/8.
//  Copyright © 2017年 SongMengLong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleTool : NSObject


+ (NSData *)sendCMD:(Byte)cmd contentString:(NSString *)contentString;

+ (NSData *)convertStringToHex:(NSString *)tmpid;

// 转换button的ID到十六进制
+ (NSData *)convertButtonTagToHex:(NSInteger)buttontag;

+ (NSData *)sendCMD:(Byte)cmd contentData:(NSData *)contentData;
// bool值 转换成data
+ (NSData *)boolValueConvertToHex:(BOOL)boolValue;
// 求和校验
+ (NSData *)sendDataSumCheck:(NSData *)data;
// 十进制转二进制
+ (NSString *)intToBinary:(int)intValue;
// 发送本地通知
+ (void)sendLocalNotifi:(NSString *)message;

@end
