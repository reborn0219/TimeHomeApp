//
//  LS_PersonalNoticeVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "UserNoticeCountModel.h"

@interface LS_PersonalNoticeVC : THBaseViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic,copy)ViewsEventBlock block;/** 第一条消息回调 */

@end
