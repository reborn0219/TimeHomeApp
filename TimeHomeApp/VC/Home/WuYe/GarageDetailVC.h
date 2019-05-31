//
//  GarageDetailVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "IntelligentGarageModel.h"
#import "ParkingModel.h"
@interface GarageDetailVC : THBaseViewController<UITableViewDelegate,UITableViewDataSource>

/**
 *  列表视图，展示详情数据
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,strong) ParkingModel * parkingModle;

//判断是否允许修改车牌
@property(nonatomic,strong) NSString * limitapp;

@end
