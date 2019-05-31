//
//  PAParkingRentDetailViewController.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
@class PACarSpaceModel;

/**
 出租详情
 */
@interface PACarSpaceRentDetailViewController : THBaseViewController

@property(nonatomic, strong)PACarSpaceModel * parkingSpace;
@property(nonatomic, copy)  UpDateViewsBlock reloadParkingSpaceBlock;
@end
