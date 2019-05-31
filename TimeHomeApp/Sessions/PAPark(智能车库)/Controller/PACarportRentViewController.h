//
//  PACarportRentViewController.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
@class PACarSpaceModel;

typedef NS_ENUM(NSUInteger, PAParkingSpaceRentType) {
    PAParkingSpaceRent, // 出租
    PAParkingSpaceRenew // 续租
};

@interface PACarportRentViewController : THBaseViewController

/**
 车位模型
 */
@property (nonatomic, strong)PACarSpaceModel * spaceModel;

/**
 出租完成后block回调
 */
@property (nonatomic, copy)UpDateViewsBlock rentSuccessBlock;

/**
 出租状态  0=出租  1=续租
 */
@property (nonatomic, assign)PAParkingSpaceRentType rentType;

@end
