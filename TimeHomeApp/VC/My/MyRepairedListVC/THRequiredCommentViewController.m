//
//  THRequiredCommentViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THRequiredCommentViewController.h"
#import "THMyrequiredTVCStyle1.h"
#import "THMyRequiredTVCStyle2.h"
#import "THMyRequiredTVCStyle5.h"
#import "THMyRepairedListsViewController.h"

@interface THRequiredCommentViewController () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  评价等级
     */
    NSString *level;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THRequiredCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"维修评价";
    level = @"1";

    [self createTableView];
}



- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THMyrequiredTVCStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyrequiredTVCStyle1 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle2 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle2 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle5 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle5 class])];

}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2) {

        Class currentClass = [THMyrequiredTVCStyle1 class];
        if (indexPath.row == 1) {
            currentClass = [THMyRequiredTVCStyle2 class];
        }
//        if (indexPath.row == 0) {
            return [_tableView cellHeightForIndexPath:indexPath model:_userInfo keyPath:@"userInfo" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
//        }else {
//            return [_tableView cellHeightForIndexPath:indexPath model:_userInfo keyPath:@"userInfo" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
//        }
    }else {
        return 60+135+30;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;

    UIButton *fbpjButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbpjButton setBackgroundColor:kNewRedColor];
    [fbpjButton setTitle:@"发 表 评 价" forState:UIControlStateNormal];
    fbpjButton.titleLabel.font = DEFAULT_BOLDFONT(14);
    [fbpjButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:fbpjButton];
    [fbpjButton addTarget:self action:@selector(fbpjButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [fbpjButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(20);
        make.width.equalTo(@(WidthSpace(584)));
        make.height.equalTo(@(WidthSpace(80)));
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    return view;
    
}

- (void)fbpjButtonClick {
    
    //发表评价
    @WeakObj(self);
    
    THMyRequiredTVCStyle5 *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell.signsView.signTextView resignFirstResponder];

    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [ReservePresenter evaluateReserveForReserveid:_userInfo.theID evaluatelevel:level evaluate:cell.signsView.signTextView.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                for (THMyRepairedListsViewController *repairedListVC in selfWeak.navigationController.viewControllers) {
                    if ([repairedListVC isKindOfClass:[THMyRepairedListsViewController class]]) {
                        [selfWeak.navigationController popToViewController:repairedListVC animated:YES];
                        break;
                    }
                }
            }
            else
            {
                [selfWeak showToastMsg:data Duration:2.0];
            }
            
        });
        
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2) {
        Class currentClass = [THMyrequiredTVCStyle1 class];
        THMyrequiredTVCStyle1 *cell = nil;

        if (indexPath.row == 1) {
            currentClass = [THMyRequiredTVCStyle2 class];
        }
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

        cell.userInfo = _userInfo;


        return cell;
    }else {
        
        THMyRequiredTVCStyle5 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMyRequiredTVCStyle5 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.buttonSelectEventBlock = ^(id _Nullable data,UIView *_Nullable view,NSInteger selectIndex){
            
            if (selectIndex == 1) {
                //非常满意
                level = @"1";
            }
            if (selectIndex == 2) {
                //满意
                level = @"2";
            }
            if (selectIndex == 3) {
                //不满意
                level = @"3";
            }
            
        };
        
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.row == 2) {
        width = SCREEN_WIDTH/2-7;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
}



@end
