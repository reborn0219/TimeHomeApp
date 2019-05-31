//
//  ContactServiceVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  联系物业客服
 */
#import "BaseViewController.h"

@interface ContactServiceVC : THBaseViewController

/**
 从二轮车信息页跳转 我的房产联系物业
 */
@property (nonatomic, assign) BOOL isFromBikeInfo;
/**
 小区id
 */
@property (nonatomic, strong) NSString *communityID;

/**
  1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
 */
@property (nonatomic, assign) NSInteger fromType;

@end
