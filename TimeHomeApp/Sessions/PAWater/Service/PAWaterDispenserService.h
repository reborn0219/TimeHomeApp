//
//  PAWaterDispenserService.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
@class PAWaterDispenserModel;
@interface PAWaterDispenserService : PABaseRequestService

@property (nonatomic,strong) PAWaterDispenserModel *deviceInfoModel;

//加载设备信息
- (void)loadWaterDeviceInfoWithQRCode:(NSString *)deviceQrCode
                              success:(ServiceSuccessBlock)success
                              failure:(ServiceFailedBlock)failure;
@end
