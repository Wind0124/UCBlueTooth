//
//  HandleTool.m
//  BlazerBLE
//
//  Created by SongMenglong on 2017/6/8.
//  Copyright © 2017年 SongMengLong. All rights reserved.
//

#import "HandleTool.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> // 铃声和振动
#import <AVFoundation/AVFoundation.h> // 音频文件
#import <UserNotifications/UserNotifications.h> // iOS10.0 本地通知

@interface HandleTool()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation HandleTool

#pragma mark - 发送命令格式
+ (NSData *)sendCMD:(Byte)cmd contentString:(NSString *)contentString {
    NSMutableData *sendData = [NSMutableData data];
    // 指令
    NSData *cmdData = [NSData dataWithBytes:&cmd length:sizeof(cmd)];
    // 指令添加识别命令
    [sendData appendData:cmdData];
    // 内容 Data
    NSData *contentData = [NSData data];
    
    if (cmd == 0x05 || cmd == 0x06) {
        // 十进制 转码 十六进制
        contentData = [HandleTool convertStringToHex:contentString];
    } else if (cmd == 0x09) {
        // 改变 蓝牙名字
        Byte cmdByte[] = {0x00};
        NSMutableData *contentDataFix = [[NSMutableData alloc] init];
        [contentDataFix appendData:[contentString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"发送更改蓝牙数据...: %@", contentDataFix);
        NSLog(@"%@", [[NSString alloc] initWithData:contentDataFix encoding:NSUTF8StringEncoding]);
        NSInteger addZeroNum = 10 - contentString.length;
        for (int i = 0; i < addZeroNum; i++) {
            [contentDataFix appendData:[NSData dataWithBytes:cmdByte length:sizeof(cmdByte)]];
        }
        NSLog(@"发送更改蓝牙数据...: %@", contentDataFix);
        NSLog(@"%@", [[NSString alloc] initWithData:contentDataFix encoding:NSUTF8StringEncoding]);
        contentData = [NSData dataWithData:contentDataFix];
    } else {
        contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding]; // 转码
    }
    
    // 指令添加内容数据
    [sendData appendData:contentData];
    // 求和 校验
    NSData *sumData = [HandleTool sendDataSumCheck:sendData];
    // 添加到发送命令内
    [sendData appendData:sumData];
    return sendData;
}

#pragma mark - 发送命令～
+ (NSData *)sendCMD:(Byte)cmd contentData:(NSData *)contentData {
    NSMutableData *sendData = [NSMutableData data];
    // 指令
    NSData *cmdData = [NSData dataWithBytes:&cmd length:sizeof(cmd)];
    // 指令添加识别命令
    [sendData appendData:cmdData];
    // 指令添加内容数据
    [sendData appendData:contentData];
    // 求和 校验
    NSData *sumData = [HandleTool sendDataSumCheck:sendData];
    // 添加到发送命令内
    [sendData appendData:sumData];
    return sendData;
}

#pragma mark - 所有字节求和 返回NSData：校验和
+ (NSData *)sendDataSumCheck:(NSData *)data {
    Byte chksum = 0;
    Byte *byte = (Byte *)[data bytes];
    for (NSUInteger i = 0; i < [data length]; i++) {
        chksum += byte[i];
    }
    return [NSData dataWithBytes:&chksum length:sizeof(chksum)];
}

#pragma mark - 将十进制转换成十六进制的byte数组
+ (NSData *)convertStringToHex:(NSString *)tmpid {
    // 将十进制转化为十六进制
    //http://www.jianshu.com/p/a5e25206df39
    //http://blog.csdn.net/weasleyqi/article/details/8048918
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid.intValue % 16;
        tmpid = [NSString stringWithFormat:@"%d", (tmpid.intValue) / 16];
        switch (ttmpig) {
            case 10:
                nLetterValue =@"A"; break;
            case 11:
                nLetterValue =@"B"; break;
            case 12:
                nLetterValue =@"C"; break;
            case 13:
                nLetterValue =@"D"; break;
            case 14:
                nLetterValue =@"E"; break;
            case 15:
                nLetterValue =@"F"; break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid.intValue == 0) {
            break;
        }
    }
    // 不够一个字节凑0
    if(str.length == 1) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    // 转换成data
    // Objective-C NSString NSData Byte等转换
    //http://blog.csdn.net/jjunjoe/article/details/7546790
    const char *buf = [str UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf) {
        unsigned long len = strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2) {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) ) {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp)length:1];
            } else {
                break;
            }
        }
    }
    //data
    return data;
}

#pragma mark - 十进制转二进制
// 转换整数到二进制 NSString  http://www.oschina.net/translate/convert-integer-to-binary-nsstring
+ (NSString *)intToBinary:(int)intValue {
    int byteBlock = 2,
    totalBits = (sizeof(int)) * byteBlock,
    binaryDigit = totalBits;
    char ndigit[totalBits + 1];
    while (binaryDigit-- > 0) {
        ndigit[binaryDigit] = (intValue & 1) ? '1' : '0';
        intValue >>= 1;
    }
    ndigit[totalBits] = 0;
    return [NSString stringWithUTF8String:ndigit];
}

+ (NSData *)convertButtonTagToHex:(NSInteger)buttontag {
    if (buttontag == 0) {
        return NULL;
    }
    // 创建一个字节
    Byte buttonTagByte;
    switch (buttontag) {
        case 407:
            buttonTagByte = 0x07;
            break;
        case 401:
            buttonTagByte = 0x01;
            break;
        case 406:
            buttonTagByte = 0x06;
            break;
        case 405:
            buttonTagByte = 0x05;
            break;
        /*
        case 408:
            buttonTagByte = 0x08;
            break;
        case 404:
            buttonTagByte = 0x04;
            break;
        case 403:
            buttonTagByte = 0x03;
            break;
        case 402:
            buttonTagByte = 0x02;
            break;
        */
        default:
            break;
    }
    // 返回Data
    return [NSData dataWithBytes:&buttonTagByte length:sizeof(buttonTagByte)];
}

// 布尔值返回 十六进制
+ (NSData *)boolValueConvertToHex:(BOOL)boolValue {
    Byte boolValueByte;
    if (boolValue == YES) {
        boolValueByte = 0x01; // on
    } else {
        boolValueByte = 0x00; //off
    }
    
    return [NSData dataWithBytes:&boolValueByte length:sizeof(boolValueByte)];
}

#pragma mark - 发送通知
+ (void)sendLocalNotifi:(NSString *)message {
    /*
     在iOS10.3上 第二种发送通知方法不好用 关于为什么 有待考证
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 ||
        [[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        // 本地通知
        // 1.创建一个本地通知
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        // 1.1.设置通知发出的时间
        localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        // 1.2.设置通知内容
        localNote.alertBody = message;
        // 1.3.设置锁屏时,字体下方显示的一个文字
        //localNote.alertAction = @"看我";
        //localNote.hasAction = YES;
        // 1.5.设置通过到来的声音
        localNote.soundName = UILocalNotificationDefaultSoundName;
        // 1.7.设置一些额外的信息
        //localNote.userInfo = @{@"hello" : @"how are you", @"msg" : @"success"};
        
        // 2.执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    }
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        // iOS10以后的本地通知
//        // 使用 UNUserNotificationCenter 来管理通知
//        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//
//        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
//        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
//        content.title = [NSString localizedUserNotificationStringForKey:message arguments:nil];
//        content.sound = [UNNotificationSound defaultSound];
//        // 在 设定时间 后推送本地推送
//        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
//                                                      triggerWithTimeInterval:1 repeats:NO];
//        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
//                                                                              content:content trigger:trigger];
//        //添加推送成功后的处理！
//        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//
//        }];
//    }
}

@end
