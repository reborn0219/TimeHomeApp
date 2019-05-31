//
//  RaiN_RedPacketDetails.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface RaiN_RedPacketDetails : THBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkMoreBtn;
@property (weak, nonatomic) IBOutlet UIView *topBg;
@property (weak, nonatomic) IBOutlet UIView *centerBg;

@property (weak, nonatomic) IBOutlet UIImageView *littleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *btnBorderView;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;

@property (weak, nonatomic) IBOutlet UILabel *moneylabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pushTag;//点击红包进入详情页不用传，其他方式进入传2
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (nonatomic,copy)NSString *ticketid;//接口id
@end
