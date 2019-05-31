//
//  PAWaterOrderService.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterOrderService.h"
#import "PAWaterOrderModel.h"
#import "PAWaterOrderQueryRequest.h"
#import "PAWaterOrderUpdateRequest.h"
#import "PAWaterPayQueryRequest.h"
#import "PAWaterOrderUnfinishedRequest.h"

@implementation PAWaterOrderService

-(NSMutableArray<PAWaterOrderModel *> *)orderDataArray{
    if (!_orderDataArray) {
        _orderDataArray = [NSMutableArray array];
    }
    return _orderDataArray;
}

-(PAWaterOrderModel *)waterOrderData{
    if (!_waterOrderData) {
        _waterOrderData = [[PAWaterOrderModel alloc]init];
    }
    return _waterOrderData;
}

//查询订单
- (void)loadWaterOrderInfoWithWaterStatus:(NSInteger)takeWaterStatus
                              success:(ServiceSuccessBlock)success
                              failure:(ServiceFailedBlock)failure{
    PAWaterOrderQueryRequest *req = [[PAWaterOrderQueryRequest alloc]initWithTakeWaterStatus:takeWaterStatus];
    self.orderDataArray = [NSMutableArray array];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSArray *dataArray = responseModel.data;
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PAWaterOrderModel *orderModel = [PAWaterOrderModel yy_modelWithJSON:obj];
            [self.orderDataArray addObject:orderModel];
        }];
        self.waterOrderData = self.orderDataArray.lastObject;
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}

//查询未完成订单
- (void)queryUnfinishedOrderWithQrCode:(NSString *)qrCodeNum
                               success:(ServiceSuccessBlock)success
                               failure:(ServiceFailedBlock)failure{
    PAWaterOrderUnfinishedRequest *req = [[PAWaterOrderUnfinishedRequest alloc]initWithQrCodeNum:qrCodeNum];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSDictionary *dataDict = responseModel.data;
        PAWaterOrderModel *orderModel = [PAWaterOrderModel yy_modelWithJSON:dataDict];
        self.waterOrderData = orderModel;
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}

//更新订单状态
- (void)updateOrderWithMerOrderId:(NSString *)merOrderId
                          success:(ServiceSuccessBlock)success
                          failure:(ServiceFailedBlock)failure{
    PAWaterOrderUpdateRequest *req = [[PAWaterOrderUpdateRequest alloc]initWithMerOrderId:merOrderId];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}

//查询订单状态
- (void)queryOrderPayWithMerOrderId:(NSString *)merOrderId
                            success:(ServiceSuccessBlock)success
                            failure:(ServiceFailedBlock)failure{
    PAWaterPayQueryRequest *req = [[PAWaterPayQueryRequest alloc]initWithMerOrderId:merOrderId];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSDictionary *dict = responseModel.data;
        self.waterOrderData.orderId = [NSString stringWithFormat:@"%@",dict[@"orderId"]];
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}



@end
