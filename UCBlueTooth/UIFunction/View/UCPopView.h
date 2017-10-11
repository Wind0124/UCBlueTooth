//
//  UCPopView.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCPopView : UIView

// 是否显示
@property (nonatomic, readonly) BOOL isShowing;

- (void)show;
- (void)dismiss;

/**
 *  设置消失的block
 */
- (void)setOnDismissBlock:(void (^)(void))onDismissBlock;

@end
