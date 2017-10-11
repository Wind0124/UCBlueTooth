//
//  PasswordComfirmView.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "UCPopView.h"

@interface PasswordComfirmView : UCPopView

typedef void (^ PassPasswordStringBlock)(NSString *passwordStr);
// block 传出输入的值
@property (nonatomic, copy) PassPasswordStringBlock passPasswordStringBlock;

@end
