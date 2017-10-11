//
//  CUPopView.m
//
//  Created by Wind on 2017/10/10.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "CUPopView.h"

@interface CUPopView ()

@property (nonatomic, copy) void (^dismissBlock)(void);

@end

@implementation CUPopView

- (void)dealloc {
    self.onDismissBlock = nil;
}

// 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)show {
    _isShowing = YES;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    // 将overlayView添加到最外面
    [keywindow addSubview:self];
    [keywindow endEditing:YES];
    
    self.center = CGPointMake(keywindow.bounds.size.width / 2.0f, keywindow.bounds.size.height / 2.0f);
    
    [self fadeIn];
}

- (void)dismiss {
    _isShowing = NO;
    [self fadeOut];
}

- (void)setOnDismissBlock:(void (^)(void))onDismissBlock {
    self.dismissBlock = onDismissBlock;
}

#pragma mark - animations
- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            
            if (_dismissBlock) {
                _dismissBlock();
            }
        }
    }];
}

#define mark - UITouch
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [super pointInside:point withEvent:event];
}

@end
