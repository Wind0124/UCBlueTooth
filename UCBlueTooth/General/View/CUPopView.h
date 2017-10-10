//
//  CUPopView.h
//  BlazerBLE
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUPopView : UIView

// 是否显示
@property (nonatomic, readonly) BOOL isShowing;

- (void)show;
- (void)dismiss;

/**
 *  设置消失的block
 */
- (void)setOnDismissBlock:(void (^)(void))onDismissBlock;

@end
