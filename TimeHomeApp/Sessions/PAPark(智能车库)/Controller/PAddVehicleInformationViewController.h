//
//  PAddVehicleInformationViewController.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "PAVehicleManagementModel.h"
#import "PAParkingSpaceModel.h"
//enum JumpeType

@interface PAAddCarInfoViewController : THBaseViewController
///绑定 1  关联车牌列表 0 修改 2为关联车库车牌修改  3为 未入库车辆车牌修改
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) PAVehicleManagementModel *vehicleModel;
@property (nonatomic, strong) PAParkingSpaceModel *spaceModel;
@property (nonatomic, copy) UpDateViewsBlock block;

@end
