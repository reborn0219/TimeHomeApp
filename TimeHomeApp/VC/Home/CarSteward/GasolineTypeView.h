//
//  GasolineTypeView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 * 燃油类型
 **/

#import <UIKit/UIKit.h>

@interface GasolineTypeView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic,assign)BOOL shadowHidden;
@end
