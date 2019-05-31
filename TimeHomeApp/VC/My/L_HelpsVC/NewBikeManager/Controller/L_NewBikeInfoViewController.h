//
//  L_NewBikeInfoViewController.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

#import "L_BikeListModel.h"

@interface L_NewBikeInfoViewController : THBaseViewController

/**
 自行车id
 */
@property (nonatomic, strong) NSString *theID;

/**
 请求接口的自行车id
 */
@property (nonatomic, strong) NSString *bikeID;


@property (nonatomic, strong) NSString *bikeListType;//0是二轮车报警记录 1是我的二轮车
@end
