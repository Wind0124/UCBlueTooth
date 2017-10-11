//
//  BluetoothCell.h
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"

@interface BluetoothCell : UITableViewCell

@property (nonatomic, strong) CBPeripheral *peripheral;

@end
