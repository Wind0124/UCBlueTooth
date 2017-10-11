//
//  PasswordComfirmView.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "PasswordComfirmView.h"

@interface PasswordComfirmView()
// 蒙版
@property (nonatomic, strong) UIControl *overlayView;
// 背景图
@property (nonatomic, strong) UIView *backView;
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 提示信息
@property (nonatomic, strong) UILabel *infoLabel;
// 密码输入框
@property (nonatomic, strong) UITextField *inputPwdTF;
// 取消button
@property (nonatomic, strong) UIButton *cancelButton;
// 确认button
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation PasswordComfirmView

// 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupPasswordComfirmView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPasswordComfirmView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupPasswordComfirmView];
    }
    return self;
}

- (void)setupPasswordComfirmView {
    [self initUISubViews];
    [self masonryLayoutSubViews];
}

#pragma mark - 初始化子控件
- (void)initUISubViews {
    self.backgroundColor = [UIColor clearColor];
    // 蒙版
    self.overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds]; //初始化
    //self.overlayView.backgroundColor = [UIColor colorWithRed:6.0f/255.0f green:6.0f/255.0f blue:6.0f/255.0f alpha:0.5f]; //背景颜色
    // 添加动作
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.overlayView];
    // 背景图
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius  = 10;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0].CGColor; // 边框颜色
    [self addSubview:_backView];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"Password";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    [_backView addSubview:_titleLabel];
    
    // 提示信息Label
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"Please Enter The Correct Password";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [UIFont systemFontOfSize:12.0];
    [_backView addSubview:_infoLabel];
    
    // 输入密码TF
    _inputPwdTF = [[UITextField alloc] init];
    _inputPwdTF.layer.borderColor = [UIColor blackColor].CGColor;
    _inputPwdTF.layer.borderWidth = 1.0f;
    _inputPwdTF.borderStyle = UITextBorderStyleLine;
    _inputPwdTF.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
    [_inputPwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_backView addSubview:_inputPwdTF];
    
    // 取消button
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    _cancelButton.backgroundColor = [UIColor colorWithRed:137.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius  = 20;
    _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_cancelButton];
    
    // 确认button
    _enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_enterButton setTitle:@"Enter" forState:UIControlStateNormal];
    _enterButton.backgroundColor = [UIColor colorWithRed:137.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    _enterButton.layer.masksToBounds = YES;
    _enterButton.layer.cornerRadius  = 20;
    _enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_enterButton];
}

#pragma mark - 取消button动作方法
- (void)cancelButtonAction:(UIButton *)cancelButton {
    [self endEditing:YES];
    [self dismiss];
}

- (void)enterButtonAction:(UIButton *)cancelButton {
    // 消失
    [self endEditing:YES];
    if (_inputPwdTF.text.length == 6) {
        _passPasswordStringBlock(_inputPwdTF.text);
        [self dismiss];
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField.text.length < 6) {
        return;
    }
    if (theTextField.text.length == 6) {
        [self endEditing:YES];
    }
    if (theTextField.text.length > 6) {
        theTextField.text = NULL;
        //[self endEditing:YES];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"真的 结束输入");
    [self endEditing:YES];
}

#pragma mark - 代码约束布局
- (void)masonryLayoutSubViews {
    // 背景图
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.9);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
//        make.height.equalTo(self.mas_height).multipliedBy(0.35);
    }];
    // 标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.mas_top).offset(0); // top
        make.left.equalTo(_backView.mas_left).offset(0); // left
        make.right.equalTo(_backView.mas_right).offset(0); // right
        make.height.offset(40);
    }];
    // 提示信息Label
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_backView.mas_left).offset(30);
        make.right.equalTo(_backView.mas_right).offset(-30);
        make.height.offset(26);
    }];
    // 输入密码输入框
    [_inputPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoLabel.mas_bottom).offset(10);
        make.left.equalTo(_backView.mas_left).offset(30);
        make.right.equalTo(_backView.mas_right).offset(-30);
        make.height.offset(30);
    }];
    // 取消button
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputPwdTF.mas_bottom).offset(30);
        make.centerX.equalTo(_backView.mas_centerX).multipliedBy(0.5);
        make.width.equalTo(_backView.mas_width).multipliedBy(0.30); // 1/4
        make.height.offset(40);
        make.bottom.equalTo(_backView.mas_bottom).offset(-30); // bottom
    }];
    
    // 确认button
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputPwdTF.mas_bottom).offset(30);
        make.centerX.equalTo(_backView.mas_centerX).multipliedBy(1.5);
        make.width.equalTo(_backView.mas_width).multipliedBy(0.30);
        make.height.offset(40);
        make.bottom.equalTo(_backView.mas_bottom).offset(-30); // bottom
    }];
}


@end
