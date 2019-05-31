//
//  rightPushCarNumber.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSY_RightCarListModel.h"
#import "LS_CarInfoModel.h"
#import "ZSY_carListModel.h"
@interface rightPushCarNumber : UIView<UITableViewDataSource,UITableViewDelegate>

/** collectionView */
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)BOOL shadowHidden;
//@property (nonatomic,strong)LS_CarInfoModel *carList;
@property (nonatomic,strong)ZSY_carListModel *carList;
@end
