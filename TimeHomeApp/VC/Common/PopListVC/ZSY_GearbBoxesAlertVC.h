//
//  ZSY_GearbBoxesAlertVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface ZSY_GearbBoxesAlertVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIView *bgView;

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
+(ZSY_GearbBoxesAlertVC *)getInstance;
///显示
-(void)showVC:(UIViewController *) parent;

///显示
-(void)showVC:(UIViewController *)parent listData:(NSArray *)data cellEvent:(CellEventBlock) cellEventBlock cellViewBlock:(CellEventBlock) cellViewBlock;

/**
 *  隐藏显示
 */
-(void)dismissVC;

@end
