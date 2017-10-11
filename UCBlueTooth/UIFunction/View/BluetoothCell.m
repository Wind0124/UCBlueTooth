//
//  BluetoothCell.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "BluetoothCell.h"

@interface BluetoothCell()
// 设备名称
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
// 状态 Connect、NotConnect
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
// 状态图片
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end

@implementation BluetoothCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    NSString *peripheralName;
    if (peripheral.name.length > 0) {
        peripheralName = peripheral.name;
    } else {
        peripheralName = @"No Name";
    }
    // Label显示名字
    self.deviceNameLabel.text = peripheralName;
    // 根据连接状态显示图片和连接状态
    if (peripheral.state == CBPeripheralStateConnected) {
        // 连接状态  设置文字 设置图片
        self.statusLabel.text = @"";
        self.statusImageView.highlighted = YES;
    } else {
        // 非连接状态 设置文字 设置图片
        self.statusLabel.text = @"Not Connected";
        self.statusImageView.highlighted = NO;
    }
}
@end
