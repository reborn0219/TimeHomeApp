//
//  PerfectInforVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  注册后完善用户资料界面
 */
#import "BaseViewController.h"


@interface PerfectInforVC : THBaseViewController


/**
 从哪个界面进来 1==从任务版界面进来完善资料
 */
@property (nonatomic, assign) NSInteger fromVCType;

/**
 从第三方绑定进来
 */
@property (nonatomic, assign) BOOL isFromThirdBinding;

/**
 第三方类型
 */
@property (nonatomic,copy)NSString *type;
/**
 第三方昵称
 */
@property (nonatomic,copy)NSString *thirdName;
/**
 第三方令牌
 */
@property (nonatomic,copy)NSString *thirdToken;
/**
 第三方ID
 */
@property (nonatomic,copy)NSString *thirdID;

/**
 小区名字
 */
@property (nonatomic,copy)NSString *theCommunityName;

/**
 小区ID
 */
@property (nonatomic,copy)NSString *theCommunityID;

@end
