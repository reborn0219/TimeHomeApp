//
//  RaiN_FamilyAuthorizationListVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface RaiN_FamilyAuthorizationListVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnToBottom;
@property (nonatomic,copy)NSString *theID;

/**
 1.从房产详情过来
 */
@property (nonatomic, assign) NSInteger type;


@end
