//
//  RaiN_VoucherDetailsVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "RaiN_LineXuXianView.h"
@interface RaiN_VoucherDetailsVC : THBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewToBottom;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *leftLittleView;
@property (weak, nonatomic) IBOutlet UIView *rightLittleView;
@property (weak, nonatomic) IBOutlet RaiN_LineXuXianView *xuxianLineView;


/**
 顶部
 */
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

/**
 中间
 */
@property (weak, nonatomic) IBOutlet UILabel *centerMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *useNowBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

/**
 底部
 */
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) NSInteger pushTag;//点击红包进入详情页不用传，其他方式进入传2
@property (nonatomic,copy)NSString *ticketid;//接口id
@property (nonatomic,strong)NSMutableArray *dataSource;
@end
