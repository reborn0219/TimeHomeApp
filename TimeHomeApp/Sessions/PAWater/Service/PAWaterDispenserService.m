//
//  PAWaterDispenserService.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterDispenserService.h"
#import "PAWaterDispenserRequest.h"
#import "PAWaterDispenserModel.h"
@implementation PAWaterDispenserService

- (void)loadWaterDeviceInfoWithQRCode:(NSString *)deviceQrCode
                              success:(ServiceSuccessBlock)success
                              failure:(ServiceFailedBlock)failure{
    
    PAWaterDispenserRequest *req = [[PAWaterDispenserRequest alloc]initWithQrCodeNum:deviceQrCode];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSDictionary *responseDict = responseModel.data;
        self.deviceInfoModel = [PAWaterDispenserModel yy_modelWithJSON:responseDict];
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}

@end
