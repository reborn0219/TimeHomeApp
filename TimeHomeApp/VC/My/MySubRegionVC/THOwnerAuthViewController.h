//
//  THOwnerAuthViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的小区业主认证界面
 */
#import "BaseViewController.h"
#import "UserCommunity.h"

@interface THOwnerAuthViewController : THBaseViewController
/**
 *  我的小区业主认证model
 */
@property (nonatomic, strong) UserCommunity *user;
@property (nonatomic, copy) NSString *IDStr;

@end
