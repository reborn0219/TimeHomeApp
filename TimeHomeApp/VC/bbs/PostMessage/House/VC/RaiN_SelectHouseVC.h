//
//  RaiN_SelectHouseVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface RaiN_SelectHouseVC : THBaseViewController

/**
 判断是房产还是车位
 0房产 1车位
 */
@property(nonatomic,copy)NSString *isHouse;
@property(copy,nonatomic) CellEventBlock eventCallBack;
@end
