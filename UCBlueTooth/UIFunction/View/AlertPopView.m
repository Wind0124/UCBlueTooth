//
//  AlertPopView.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "AlertPopView.h"

@interface AlertPopView()
// 蒙版
@property (nonatomic, strong) UIControl *overlayView;
// 背景图
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation AlertPopView

- (void)dealloc {
    
}

// 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAlartView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAlartView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupAlartView];
    }
    return self;
}

- (void)setupAlartView {
    [self initUISubViews];
    [self masonryLayoutSubViews];
}

- (void)setInfoString:(NSString *)infoString {
    if (_infoString != infoString) {
        _infoString = infoString;
    }
    self.infoLabel.text = self.infoString;
}

- (void)initUISubViews {
    self.overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds]; //初始化
    self.overlayView.backgroundColor = [UIColor colorWithRed:6.0f/255.0f green:6.0f/255.0f blue:6.0f/255.0f alpha:0.5f]; //背景颜色
    // 添加动作
    //[self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.overlayView];
    // 背景View
    self.backView = [[UIView alloc] init];
//    self.backView.layer.masksToBounds = YES;
//    self.backView.layer.cornerRadius  = 10;
//    self.backView.layer.borderWidth = 1;
//    self.backView.layer.borderColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0].CGColor; // 边框颜色
    UCViewBorderRadius(self.backView, 10.0, 1.0, [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0]);
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"Alert";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.titleLabel];
    // 内容Label
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.text = self.infoString;
    self.infoLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.infoLabel];
    
    // Close Button
    self.closeButton = [[UIButton alloc] init];
    self.closeButton.backgroundColor = [UIColor colorWithRed:137.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = 10.0f;
    [self.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.closeButton];
}

- (void)closeButtonAction:(UIButton *)button {
    self.alertPopViewBlock(YES);
    [self dismiss];
}

- (void)masonryLayoutSubViews {
    // 背景图
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.9); // 垂直居中
        make.left.equalTo(self.mas_left).offset(30.0f); // left
        make.right.equalTo(self.mas_right).offset(-30.0f); // right
        // 高度由最后一个控件的约束决定
    }];
    // 标题view
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(10); // 顶部距离backView
        make.left.equalTo(self.backView.mas_left).offset(0); //left
        make.right.equalTo(self.backView.mas_right).offset(0); //right
        make.height.offset(40.0f); // 高
    }];
    // 信息框
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30); // 顶部距离titleLabel
        make.centerX.equalTo(self.backView.mas_centerX).multipliedBy(1.0f); // 居中
    }];
    // 关闭button
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(30); // 顶部距离infoLabel
        make.centerX.equalTo(self.backView.mas_centerX).offset(0); // 水平居中
        make.bottom.equalTo(self.backView.mas_bottom).offset(-20.0f); // 底部距离backView
        make.width.offset(100);
        make.height.offset(40);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
