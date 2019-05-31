//
//  PAddVehicleInformationViewController.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "PACarManagementModel.h"
#import "PACarSpaceModel.h"

typedef NS_ENUM(NSUInteger, AddCarInfoControllerJumpType) {
    AddCarInfoControllerJumpTypeRelation,//关联车牌列表
    AddCarInfoControllerJumpTypeUpdate,//修改
    AddCarInfoControllerJumpTypeBatchUpdate,//批量修改
};

@interface PAAddCarInfoViewController : THBaseViewController

@property (nonatomic, assign) AddCarInfoControllerJumpType type;
@property (nonatomic, strong) PACarManagementModel *vehicleModel;
@property (nonatomic, strong) PACarSpaceModel *spaceModel;
@property (nonatomic, copy) UpDateViewsBlock block;

@end
