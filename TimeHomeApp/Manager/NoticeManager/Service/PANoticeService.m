//
//  PANoticeService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANoticeService.h"
#import "PANoticeRequest.h"
#import <JMessage/JMessage.h>
#import "PANoticeUnBindRequest.h"
@implementation PANoticeService

/**
 保存设备信息
 
 @param success success description
 @param failure failure description
 */
+ (void) saveDeviceInfoSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    PANoticeRequest * req = [[PANoticeRequest alloc]init];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSLog(@"%@",responseModel);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"%@",error);
    }];
}

/**
 解绑设备信息
 
 @param success 成功
 @param failure 失败
 */
+ (void) unbindDeviceSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANoticeUnBindRequest * req = [[PANoticeUnBindRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSLog(@"%@",responseModel.data);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"%@",error);
    }];
}


@end
