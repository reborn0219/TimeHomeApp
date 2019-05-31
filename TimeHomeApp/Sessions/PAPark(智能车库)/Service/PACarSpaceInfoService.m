//
//  PAParkingSpaceInfoService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceInfoService.h"
#import "PACarSpaceInfoRequest.h"

@implementation PACarSpaceInfoService

/**
 加载车位详情
 
 @param parkingId parkingId 车位ID
 @param success success 成功回调
 @param failure failure 失败回调
 */
- (void)loadParkingSpaceInfo:(NSString *)parkingId Success:(void(^)(id data))success failure:(void(^)(NSError *error))failure{
    PACarSpaceInfoRequest * req = [[PACarSpaceInfoRequest alloc]initWithParkingSpaceId:parkingId];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSDictionary * responseDictionary = responseModel.data;
        
        self.parkingSpaceInfo = [PACarSpaceInfoModel yy_modelWithDictionary:responseDictionary];
        
        self.parkingInfoArray = @[].mutableCopy;
        if (self.parkingSpace.type != 3 ) {
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.type == 0 ?@"业主自用":@"业主出租" ] ;
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.inLibCarNo?:@""];
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.inTime?:@""];
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.inSpace?:@""];
        } else {
            [self.parkingInfoArray addObject:@"租用" ] ;
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.ownerName];
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.inLibCarNo?:@""];
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.inTime?:@""];
            [self.parkingInfoArray addObject:self.parkingSpaceInfo.inSpace?:@""];
            [self.parkingInfoArray addObject:self.parkingSpace.useEndDate?:@""];
            
        }

        if ([self.delegate respondsToSelector:@selector(loadDataSuccess)]) {
            [self.delegate loadDataSuccess];
        }
        success(self.parkingSpaceInfo);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(error);
    }];
}
- (NSArray *)titleArray{
    
    if (self.parkingSpace.type != 3 ) {
        _titleArray = @[@"使用状态: ",@"入库车辆: ",@"入库时间: ",@"入库位置: "];
    } else {
        _titleArray = @[@"使用状态: ",@"出租人: ",@"入库车辆: ",@"入库时间: ",@"入库位置: ",@"到期时间: "];
    }
    return _titleArray;
}


@end
