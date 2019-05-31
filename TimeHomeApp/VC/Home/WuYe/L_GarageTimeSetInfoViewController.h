//
//  L_GarageTimeSetInfoViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "ParkingCarModel.h"

@interface L_GarageTimeSetInfoViewController : THBaseViewController

/**
 是否从自行车界面过来 YES二轮车界面过来 NO汽车管理界面过来
 */
@property (nonatomic, assign) BOOL isFromBike;
@property (nonatomic, strong) NSString *bikeID;

@property (nonatomic, strong) ParkingCarModel *carModel;
@property (nonatomic, strong) NSNumber *lockstate;

@end
