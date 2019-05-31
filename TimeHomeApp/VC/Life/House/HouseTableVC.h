//
//  HouseTableVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  房屋租售列表显示
 */
#import "BaseViewController.h"

@interface HouseTableVC : THBaseViewController
@property(nonatomic,assign)int jmpCode;//0.出租 1.出售 2.二手物品
///是否是从发布页过来的 YES 是
@property(nonatomic,assign) BOOL isFromeRelease;
///返回到那个界面 0.默认 1.返回到二手市场
@property(nonatomic,assign)int fromeJmp;
@end
