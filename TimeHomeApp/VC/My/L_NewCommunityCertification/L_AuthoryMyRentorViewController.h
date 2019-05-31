//
//  L_AuthoryMyRentorViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface L_AuthoryMyRentorViewController : THBaseViewController

/**
 是否需要温馨提示
 */
@property (nonatomic, assign) BOOL isNeedMsg;

/**
 房产id
 */
@property (nonatomic, copy) NSString *theID;

@property (nonatomic, copy) ViewsEventBlock callBack;

/**
 1.从房产详情过来
 */
@property (nonatomic, assign) NSInteger type;

@end
