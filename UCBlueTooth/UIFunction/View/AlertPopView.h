//
//  AlertPopView.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "UCPopView.h"

@interface AlertPopView : UCPopView

// 返回block
typedef void (^ AlertPopViewBlock)(BOOL isClosed);
// block属性
@property (nonatomic, copy) AlertPopViewBlock alertPopViewBlock;
// 警告信息
@property (nonatomic, strong) NSString *infoString;

@end
