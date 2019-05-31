//
//  ZSY_ gearBoxVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface ZSY__gearBoxVC : THBaseViewController

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titlesLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;


/**
 *  获取实例
 *
 *  @return return value description
 */
+(ZSY__gearBoxVC *)getInstance;

+(instancetype)gearBoxVC;
@property (nonatomic,copy)CellEventBlock block;


-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andDataSource:(NSMutableArray *)dataSource;
-(void)dismiss;


@end
