//
//  PopListVC.h
//  TimeHomeApp
//
//  Created by us on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface PopListVC : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_TableHeigth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property(nonatomic,strong) NSMutableArray *listData;

///列表点击事件回调处理
@property(nonatomic,copy)CellEventBlock cellEventBlock;

///列表视图数据赋值
@property(nonatomic,copy)CellEventBlock cellViewBlock;


/**
 *  返回实例
 *
 *  @return return value description
 */
+(PopListVC *)getInstance;
///显示
-(void)showVC:(UIViewController *) parent;

///显示
-(void)showVC:(UIViewController *)parent listData:(NSArray *)data cellEvent:(CellEventBlock) cellEventBlock cellViewBlock:(CellEventBlock) cellViewBlock;

/**
 *  隐藏显示
 */
-(void)dismissVC;

@end
