//
//  GarageAddCarVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///添加车牌视图
#import "BaseViewController.h"
#import "ParkingModel.h"
@interface GarageAddCarVC : THBaseViewController
///车位数据
@property(nonatomic,strong) ParkingModel * parkingModle;
///本车位下的车牌
@property(nonatomic,strong) NSMutableArray * carArray;
@end
