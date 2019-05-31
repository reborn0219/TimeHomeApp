//
//  OnlineServiceVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  在线报修
 */
#import "BaseViewController.h"
#import "UserReserveInfo.h"

@interface OnlineServiceVC : THBaseViewController
/// 0. 新发布 1.驳回的维修进行修改，带数据
@property(nonatomic,assign) int jmpCode;

/**
 *  用户报修信息model
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;

/**
 *  myType=1 表示从我的界面中点击按钮进来的
 */
//@property (nonatomic, assign) int myType;

@end
