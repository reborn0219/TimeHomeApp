//
//  THRequiredCommentViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的维修评价界面
 */
#import "THBaseViewController.h"
/**
 *  网络请求
 */
#import "ReservePresenter.h"

@interface THRequiredCommentViewController : THBaseViewController

/**
 *  用户报修信息
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;


@end
