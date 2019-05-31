//
//  PACarportDetailViewController.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
@class PACarSpaceModel;
@interface PACarSpaceDetailViewController : THBaseViewController

@property(nonatomic, assign)int limitapp; // 是否限制车牌号添加
@property(nonatomic, strong)PACarSpaceModel * parkingSpace;  ///车位model
@property(nonatomic, copy) UpDateViewsBlock rentSuccessBlock; ///出租成功后数据刷新回调


@end
