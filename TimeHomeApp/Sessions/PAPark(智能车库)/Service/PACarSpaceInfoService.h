//
//  PAParkingSpaceInfoService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PABaseRequestService.h"
#import "PACarSpaceInfoModel.h"
#import "PACarSpaceModel.h"
@interface PACarSpaceInfoService : PABaseRequestService

/**
 区分租用是否为租用状态
 */
@property (nonatomic, strong)PACarSpaceModel *parkingSpace; // 传入车位model
@property (nonatomic, strong)NSArray <NSString *> *titleArray; // 车位详情 布局 title array
@property (nonatomic, strong)NSMutableArray <NSString *> *parkingInfoArray; //车位详情 content array;
@property (nonatomic, strong)PACarSpaceInfoModel *parkingSpaceInfo; // 请求成功 回调模型


/**
 加载车位详情
 
 @param parkingId parkingId 车位ID
 @param success success 成功回调
 @param failure failure 失败回调
 */
- (void)loadParkingSpaceInfo:(NSString *)parkingId Success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

@end
