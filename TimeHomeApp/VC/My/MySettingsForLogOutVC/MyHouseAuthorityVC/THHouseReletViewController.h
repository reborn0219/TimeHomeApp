//
//  THHouseReletViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的房产授权续租界面
 */
#import "BaseViewController.h"

typedef void(^ CallBack)(void);

@interface THHouseReletViewController : THBaseViewController
/**
 *  住宅id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  租用开始日期
 */
@property (nonatomic, strong) NSString *rentbegindate;
/**
 *  租用结束日期
 */
@property (nonatomic, strong) NSString *rentenddate;
/**
 *  租期完成后回调刷新数据
 */
@property (nonatomic, copy) CallBack callBack;
/**
 *  类型：0-房产，1-车位
 */
@property (nonatomic, assign) NSInteger type;

@end
