//
//  ChangCityVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  切换城市
 */
#import "BaseViewController.h"

@interface ChangCityVC : THBaseViewController
///选择城市后的回调
@property(nonatomic,copy)ViewsEventBlock selectEventBlock;

@property(nonatomic,copy)NSString *type;


@end
