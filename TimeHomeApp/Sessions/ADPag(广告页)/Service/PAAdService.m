//
//  SHAdService.m
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PAAdService.h"
#import "PAAdInfoRequest.h"

@implementation PAAdService

-(void)loadAdImage{
    
    PAAdInfoRequest *adinfoRequest = [[PAAdInfoRequest alloc]init];
    
    [adinfoRequest requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        PAAdInfoModel *adInfo = [PAAdInfoModel yy_modelWithJSON:responseModel.data];
        
        if(adInfo && self.successBlock){
            self.adInfo = adInfo;
            if(self.successBlock){
                self.successBlock(self);
            }
        }else{
            if (self.failedBlock) {
                self.failedBlock(self, @"广告数据解析失败");
            }
        }

    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        if (self.failedBlock) {
            self.failedBlock(self, error.description);
        }
    }];    
}

@end
