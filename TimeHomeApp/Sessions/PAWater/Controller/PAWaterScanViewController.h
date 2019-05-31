//
//  PAWaterViewController.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "PAWaterBluetoothManager.h"
#import "PAWaterScanView.h"
#import "PAWaterNotFoundView.h"
#import "PAWaterDispenserController.h"
@interface PAWaterScanViewController : THBaseViewController
@property (nonatomic,strong) PAWaterScanView *scanView;
@property (nonatomic,strong) UILabel *showMsgLabel;
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UILabel *waitLabel;
@property (nonatomic,strong) PAWaterNotFoundView *failView;
@property (nonatomic,copy) NSString *qrCode;
@property (nonatomic,strong) PAWaterBluetoothManager *bluetoothManager;
@end
