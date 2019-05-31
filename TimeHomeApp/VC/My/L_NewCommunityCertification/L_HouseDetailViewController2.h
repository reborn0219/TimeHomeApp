//
//  L_HouseDetailViewController2.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface L_HouseDetailViewController2 : THBaseViewController

/**
 1.出租 2.共享
 */
@property (nonatomic, assign) int type;

/**
 房产id
 */
@property (nonatomic, copy) NSString *theID;

@end
