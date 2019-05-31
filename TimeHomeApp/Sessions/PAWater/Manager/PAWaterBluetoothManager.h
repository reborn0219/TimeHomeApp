//
//  PAWaterBluetoothManager.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAWaterBluetoothManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(PAWaterBluetoothManager)

// 蓝牙4.0设备名
@property (nonatomic,copy) NSString *kBlePeripheralName;

///蓝牙处理回调
@property(nonatomic,copy)PAWaterBluetoothEventBlock blueToothBlock;

// 支付金额
- (void)payWaterMoney:(float )money andPayTimes:(NSInteger)payTimes andOrderId:(NSString *)orderId;

// 扫描设备
- (void)scanForPeripherals;

//写数据
- (void)writeDataWithString:(NSString *)dataString;

// 清空设备
- (void)clearPeripherals;
@end
