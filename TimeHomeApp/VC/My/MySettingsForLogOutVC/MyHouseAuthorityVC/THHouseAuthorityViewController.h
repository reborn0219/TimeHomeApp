//
//  THHouseAuthorityViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的房产授权授权界面
 */
#import "BaseViewController.h"
#import "OwnerResidence.h"
typedef void (^CallBack) (void);
@interface THHouseAuthorityViewController : THBaseViewController
/**
 *  回调
 */
@property (nonatomic, copy) CallBack callBack;
/**
 *  业主授权房产信息
 */
@property (nonatomic, strong) OwnerResidence *owner;

@end
