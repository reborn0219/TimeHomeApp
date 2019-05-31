//
//  LifeSelectListVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  发布时，显示选择列表
 */
#import "BaseViewController.h"

@interface LifeSelectListVC : THBaseViewController
/**
 *  列表数据
 */
@property(nonatomic,strong)NSMutableArray * listData;
/**
 *  选中索引
 */
@property(nonatomic,assign) NSInteger indexSelected;


///列表点击事件回调处理
@property(nonatomic,copy)CellEventBlock cellEventBlock;

///列表视图数据赋值
@property(nonatomic,copy)CellEventBlock cellViewBlock;

@end
