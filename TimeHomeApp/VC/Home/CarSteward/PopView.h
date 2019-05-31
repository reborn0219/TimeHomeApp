//
//  PopView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 *  用于展示对应车款的view
 **/

#import <UIKit/UIKit.h>

@interface PopView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UIViewController *controller;
- (void)clickWithController:(UIViewController *)controller;
- (instancetype)initWithFrame:(CGRect)frame andController:(UIViewController *)controller;
@end
