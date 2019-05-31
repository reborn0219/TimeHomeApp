//
//  PAVoucherTableViewController.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "PARedBagDetailModel.h"

@interface PAVoucherTableViewController : THBaseViewController

@property (strong,nonatomic) NSArray <PARedBagDetailModel *> *redBagArray;

@end
