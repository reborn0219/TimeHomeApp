//
//  PAMyRedBagVcoucherViewController.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, MYREDBAG_TABLE_TYPE) {
    MYREDBAG_TABLE_TYPE_REDBAG = 0,//红包
    MYREDBAG_TABLE_TYPE_VOUCHER//优惠券
};


@interface PAMyRedBagVoucherViewController : THBaseViewController

@property (assign,nonatomic) MYREDBAG_TABLE_TYPE tableType;

@end
