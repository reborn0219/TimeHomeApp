//
//  LiftUpRodBluetoothPresenter.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/9/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface LiftUpRodBluetoothPresenter : BasePresenters<CBCentralManagerDelegate,CBPeripheralDelegate>//,CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBCentralManager      *centralManager;//主设中心
@property (strong, nonatomic) CBPeripheralManager    *peripheralManager;//从设中心
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;//发现的设备
@property (strong, nonatomic) NSDictionary *dataDict;

@property (strong, nonatomic) NSData *wirteData;

///蓝牙处理回调
@property(nonatomic,copy)BluetoothEventBlock blueToothBlock;

///开始扫描
- (void)startScanPeripherals;
///断开连接
-(void)discconnection;

-(BOOL)writeChar:(NSData *)data;

@end
