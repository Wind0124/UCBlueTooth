//
//  BluetoothVC.m
//  UCBlueTooth
//
//  Created by Wind on 2017/10/11.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "BluetoothVC.h"
#import "BluetoothCell.h"
#import "PasswordComfirmView.h"

@interface BluetoothVC ()<UITableViewDelegate,UITableViewDataSource>
// tableview
@property (nonatomic, strong) UITableView *tableView;
// 蓝牙可变数组
@property (nonatomic, strong) NSMutableArray *bluetoothArray;
// 密码
@property (nonatomic, strong) NSString *passwordString;

@end

@implementation BluetoothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Connect";
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置蓝牙
    [self setupBluetooth];
}

#pragma mark - 设置蓝牙
- (void)setupBluetooth {
    // 已连接设备
    NSArray *bleArray = [[BabyBluetooth shareBabyBluetooth] findConnectedPeripherals];
    // 设置block
    [self setupBabyBluetoothDelegate];
    
    if (bleArray.count != 0) {
        // 此时蓝牙连接设备
        self.peripheral = [bleArray objectAtIndex:0];
        // 设置字典
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        
        [item setValue:self.peripheral forKey:@"peripheral"]; // 特征
        [item setValue:NULL forKey:@"RSSI"];
        [item setValue:NULL forKey:@"advertisementData"];
        // 添加到数组
        [self.bluetoothArray addObject:item];
        
        [self.peripheral discoverServices:@[[CBUUID UUIDWithString:Data_Service]]];
    } else {
        // 设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态，扫描设备
        self.babyBluetooth.scanForPeripherals().begin();
    }
}

- (void)setupBabyBluetoothDelegate {
    // 设置扫描到设备的委托
    __weak typeof(self) weakSelf = self;
    // 发现设备
    [self.babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        // 获取已加载的设备
        NSArray *peripheralArray = [weakSelf.bluetoothArray valueForKey:@"peripheral"];
        
        // 从UUID判断新设备是否已存在
        BOOL hasExist = NO;
        for (int i = 0; i < peripheralArray.count; i++) {
            CBPeripheral *p = peripheralArray[i];
            NSString *UUID = [p.identifier UUIDString];
            if ([[peripheral.identifier UUIDString] isEqualToString:UUID]) {
                hasExist = YES;
                break;
            }
        }
//        NSLog(@"新设备%@",peripheral);
        // 添加新设备到数组
        if (!hasExist) {
            // 添加到tableView最后一行
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.bluetoothArray.count inSection:0];
            [indexPaths addObject:indexPath];
            
            // 添加到数组
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            [item setValue:peripheral forKey:@"peripheral"];
            [item setValue:RSSI forKey:@"RSSI"];
            [item setValue:advertisementData forKey:@"advertisementData"];
            [weakSelf.bluetoothArray addObject:item];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    // 蓝牙连接成功 扫描服务
    [self.babyBluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"====蓝牙连接成功,%@", peripheral.name);
        // 发现服务
        [peripheral discoverServices:@[[CBUUID UUIDWithString:Data_Service]]];
    }];
    // 设置连接失败 接Peripherals失败的委托
    [self.babyBluetooth setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"====蓝牙连接失败,%@", peripheral.name);
    }];
    // 断开连接
    [self.babyBluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"====蓝牙连接断开");
    }];
    // 获取服务 设置查找服务回叫
    [self.babyBluetooth setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        // 遍历服务
        for (CBService *service in peripheral.services) {
            if ([service.UUID.UUIDString isEqual:Data_Service]) {
                // 设备发现特征
                [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:Data_Character_Write], [CBUUID UUIDWithString:Data_Character_Read]] forService:service];
            }
        }
    }];
    // 4.扫描特征 与蓝牙数据交互
    [self.babyBluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        // 遍历特征咯
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.UUIDString isEqual:Data_Character_Read]) {
                NSLog(@"扫描特征====FFF2 读出 通知");
                // 将特征赋值给读出特征
                weakSelf.characteristicRead = characteristic;
                // 订阅通知 FFF2
                [weakSelf.peripheral setNotifyValue:YES forCharacteristic:weakSelf.characteristicRead];
            }
            
            if ([characteristic.UUID.UUIDString isEqual:Data_Character_Write]) {
                NSLog(@"扫描特征====FFF1 写入 ");
                // 赋值
                weakSelf.characteristicWrite = characteristic;
                weakSelf.peripheral = peripheral;
                
                NSLog(@"写入特征 %@", weakSelf.characteristicWrite);
                // 写入密码
                NSLog(@"密码 %@", weakSelf.passwordString);
                
                if ([weakSelf.passwordString isEqual:NULL] || weakSelf.passwordString.length == 0) {
                    weakSelf.passwordString = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_LOCAL_PWD];
                }
                // 打开，发送密码数据
                NSData *sendData = [HandleTool sendCMD:0x08 contentString:weakSelf.passwordString];
                [weakSelf.peripheral writeValue:sendData forCharacteristic:weakSelf.characteristicWrite type:CBCharacteristicWriteWithoutResponse];
            }
        }
    }];
    // 5.订阅更新 接收指令
    [self.babyBluetooth setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (characteristic.value == NULL) {
            // 自动连接 重新连接～～
            NSLog(@"====自动重连");
            [weakSelf.peripheral autoContentAccessingProxy];
            return;
        }
        // 处理蓝牙指令返回的数据
        [weakSelf handlePeripheralResponseData:characteristic];
    }];
}

// 处理返回数据
- (void)handlePeripheralResponseData:(CBCharacteristic *)characteristic {
    Byte *bytes=(Byte *)[characteristic.value bytes];
    if (characteristic == NULL) {
        NSLog(@"特征 为空");
        return;
    }
    if (bytes == NULL) {
        NSLog(@"字节 为空");
        return;
    }
    // 根据协议处理 返回的数据
    // 假设 登录命令08，成功01，失败00
    if (bytes[0] == 0x08) {
        NSLog(@"蓝牙 返回 命令08");
        [self readBlueToothBackDataOfCMD08WithBytes:bytes];
    }
}

// 登录成功、失败
- (void)readBlueToothBackDataOfCMD08WithBytes:(Byte *)bytes {
    if (bytes[1] == 0x00) { // 判断修改
        // 密码登录失败
        NSLog(@"====密码登录 失败");
        [self showMessage:@"Wrong Password"];
        [self.babyBluetooth cancelPeripheralConnection:self.peripheral]; // 取消连接
        return;
    }
    NSLog(@"====密码登录 成功");
    
    // 蓝牙UUID
    [[NSUserDefaults standardUserDefaults] setObject:self.peripheral.identifier.UUIDString forKey:DEVICE_LOCAL_UUID];
    // 蓝牙名字
    [[NSUserDefaults standardUserDefaults] setObject:self.peripheral.name forKey:DEVICE_LOCAL_NAME];
    // 本地密码
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordString forKey:DEVICE_LOCAL_PWD];
    // 本地同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 停止扫描
    //[_babyBluetooth.centralManager stopScan];
    // 刷新tableview数据
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bluetoothArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BluetoothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BluetoothCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BluetoothCell" owner:self options:nil]lastObject];
    }
    NSDictionary *item = [self.bluetoothArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    cell.peripheral = peripheral;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.bluetoothArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    // 输密码
    [self inputCorrectPasswordComfirm:peripheral];
}

// 弹出密码框
- (void)inputCorrectPasswordComfirm:(CBPeripheral *)peripheral {
    // 初始化密码输入框
    PasswordComfirmView *inputPasswordPopView = [[PasswordComfirmView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [inputPasswordPopView show];
    // 密码输入框 block
    inputPasswordPopView.passPasswordStringBlock = ^(NSString *passwordStr) {
        NSLog(@"连接蓝牙设备");
        [self.babyBluetooth.centralManager connectPeripheral:peripheral options:nil];
        self.passwordString = passwordStr;
    };
}

#pragma mark - UI
- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // footerview 去除多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BluetoothCell" bundle:nil]
         forCellReuseIdentifier:@"BluetoothCell"];
    [self.view addSubview:self.tableView];
    // 添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    // 头部
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UC_SCREEN_WIDTH, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, UC_SCREEN_WIDTH, 40)];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    headerLabel.text = @"Equipment List";
    [headerView addSubview:headerLabel];
    self.tableView.tableHeaderView = headerView;

}

#pragma mark - 懒加载
- (NSMutableArray *)bluetoothArray {
    if (!_bluetoothArray) {
        _bluetoothArray = [NSMutableArray array];
    }
    return _bluetoothArray;
}

@end
