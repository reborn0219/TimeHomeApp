//
//  PATrafficService.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/5/17.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PATrafficService.h"
#import "PATrafficSaveRequest.h"
@implementation PATrafficService

-(void)saveData:(NSDictionary *)trafficInfo success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    PATrafficSaveRequest * req = [[PATrafficSaveRequest alloc]initSaveTrafficInfo:trafficInfo];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        success(responseModel);
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(error);
    }] ;
    
}
@end
