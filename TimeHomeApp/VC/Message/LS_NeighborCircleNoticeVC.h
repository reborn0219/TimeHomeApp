//
//  LS_NeighborCircleNoticeVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "UserNoticeCountModel.h"


@interface LS_NeighborCircleNoticeVC : THBaseViewController

@property (nonatomic,strong) UserNoticeCountModel *UNCML;
@property (nonatomic,copy)ViewsEventBlock block;
@end
