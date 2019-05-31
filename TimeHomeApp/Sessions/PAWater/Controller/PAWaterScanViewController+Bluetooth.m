//
//  PAWaterScanViewController+Bluetooth.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/16.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterScanViewController+Bluetooth.h"

@implementation PAWaterScanViewController (Bluetooth)

- (void)createBluetoothManager{
    self.bluetoothManager = [PAWaterBluetoothManager sharedPAWaterBluetoothManager];
    @weakify(self);
    self.bluetoothManager.blueToothBlock = ^(id  _Nullable data, PAWaterResponseType bluetoothCode) {
        @strongify(self)
        self.waitLabel.hidden = YES;
        if (bluetoothCode == PAWaterFindDeviceTimeOut) {
            //搜索蓝牙超时
            self.failView.hidden = NO;
        }if (bluetoothCode == PAWaterLinkSuccess) {
            //连接成功 可进行下一步
            PAWaterDispenserController *vc = [[PAWaterDispenserController alloc]init];
            vc.QrCode = self.qrCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(bluetoothCode == PAWaterLinkException){
            //连接成功 出水未完成无法进行下步消费
            PAAlertViewManager *alert = [PAAlertViewManager sharedPAAlertViewManager];
            [alert showOneButtonAlertWithTitle:@"提示" content:@"设备正在运行，请稍后重试" buttonContent:@"确定" buttonBgColor:@"#007AFF" buttonBlock:^{
                NSLog(@"设备正在运行，请稍后重试");
                [self.bluetoothManager clearPeripherals];
                [self.scanView startScanning];
            }];
        }else if(bluetoothCode == PAWaterLinkFail){
            //连接失败
            self.failView.hidden = NO;
        }else if(bluetoothCode == PAWaterBluetoothException){
            PAAlertViewManager *alert = [PAAlertViewManager sharedPAAlertViewManager];
            [alert showOneButtonAlertWithTitle:@"提示" content:@"请打开蓝牙" buttonContent:@"确定" buttonBgColor:@"#007AFF" buttonBlock:^{
                self.waitLabel.hidden = YES;
                [self failToContinueScan];
            }];
        }
    };
}

- (void)failToContinueScan{
    self.failView.hidden = YES;
    if (self.bluetoothManager) {
        [self.bluetoothManager clearPeripherals];
    }
    [self.scanView startScanning];
}
@end
