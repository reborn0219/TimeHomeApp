//
//  PAWaterOrderService.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
@class PAWaterOrderModel;

@interface PAWaterOrderService : PABaseRequestService

@property (nonatomic,strong) PAWaterOrderModel *waterOrderData;

@property (nonatomic,strong)  NSMutableArray <PAWaterOrderModel *>*orderDataArray;

//查询订单
- (void)loadWaterOrderInfoWithWaterStatus:(NSInteger)takeWaterStatus
                                  success:(ServiceSuccessBlock)success
                                  failure:(ServiceFailedBlock)failure;

//查询未完成订单
- (void)queryUnfinishedOrderWithQrCode:(NSString *)qrCodeNum
                               success:(ServiceSuccessBlock)success
                               failure:(ServiceFailedBlock)failure;
//更新订单状态
- (void)updateOrderWithMerOrderId:(NSString *)merOrderId
                          success:(ServiceSuccessBlock)success
                          failure:(ServiceFailedBlock)failure;
//查询订单状态
- (void)queryOrderPayWithMerOrderId:(NSString *)merOrderId
                            success:(ServiceSuccessBlock)success
                            failure:(ServiceFailedBlock)failure;
@end
