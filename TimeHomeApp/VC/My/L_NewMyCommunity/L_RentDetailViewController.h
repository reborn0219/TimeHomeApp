//
//  L_RentDetailViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 租赁中
 */
@interface L_RentDetailViewController : THBaseViewController

/**
 租赁状态 1.添加家人 2.家人列表 3.已被添加家人
 */
@property (nonatomic, assign) NSInteger rentState;

@end
