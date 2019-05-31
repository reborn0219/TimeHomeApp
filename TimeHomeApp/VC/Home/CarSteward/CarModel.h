//
//  CarModel.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 *车辆型号
 **/
#import <UIKit/UIKit.h>

@interface CarModel : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *tableViewDataSource;

@property (nonatomic,strong)UIViewController *controller;
- (void)clickWithController:(UIViewController *)controller;
- (instancetype)initWithFrame:(CGRect)frame andController:(UIViewController *)controller;

@end
