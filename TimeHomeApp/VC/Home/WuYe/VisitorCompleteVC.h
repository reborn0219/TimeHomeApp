//
//  VisitorCompleteVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  访客通行完成申请页
 */
#import "BaseViewController.h"

@interface VisitorCompleteVC : THBaseViewController<UITableViewDelegate>

///访客通行记录ID
@property(nonatomic,strong)NSString * ID;
///分享地址
@property(nonatomic,strong)NSString * goToUrl;

@end
