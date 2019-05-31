//
//  THMyRequiredDetailsViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修详情界面
 */
#import "THBaseViewController.h"
/**
 *  网络请求
 */
#import "ReservePresenter.h"

@interface THMyRequiredDetailsViewController : THBaseViewController

/**
 *  用户报修信息
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;
@property (nonatomic,copy)NSString *isFormMy;//0否1是
@end
