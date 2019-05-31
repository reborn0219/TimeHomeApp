//
//  BaseViewController+RedBag.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/1.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "PARedBagModel.h"

@interface BaseViewController (RedBag)

- (void)showRedBag:(PARedBagModel*)redBag;
- (void)openRedBag:(PARedBagModel*)redBag;

@end
