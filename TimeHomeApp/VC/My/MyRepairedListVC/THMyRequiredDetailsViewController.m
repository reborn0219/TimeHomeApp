//
//  THMyRequiredDetailsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRequiredDetailsViewController.h"
#import "THMyrequiredTVCStyle1.h"
#import "THMyRequiredTVCStyle2.h"
#import "THMyRequiredTVCStyle3.h"
#import "THMyRequiredTVCStyle4.h"
#import "MyRequiredSectionView.h"
#import "THMyrequiredTVCPicStyle1.h"

#import "THRequiredCommentViewController.h"
#import "OnlineServiceVC.h"
#import "SysPresenter.h"
#import "RegularUtils.h"
#import "RaiN_NewOnlineServiceVC.h"
@interface THMyRequiredDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  报修跟踪数据
     */
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomButton;

@end

@implementation THMyRequiredDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"报修详情";

    [self createTableView];
    
    [self createBottomButton];
    
    [self httpRequest];

}


/**
 *  底部按钮判断
 */
- (void)bottomButtonState {
    
    UserReserveLog *model = dataArray[0];

    switch (model.state.intValue) {

        case -1:
        {
            /**
             *  已驳回，物业因信息未填写完整将报修单驳回，显示“报修信息不完整，物业驳回”，屏幕显示“修改报修单”按钮，点击进入在线报修页面，将原信息带入；
             */
            _bottomButton.hidden = NO;
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)-42);
            [_bottomButton setTitle:@"修改报修单" forState:UIControlStateNormal];

        }
            break;

        case 2:
        {
            /**
             *  处理中，已分派维修人员，显示“XXX（手机号）正在处理”，屏幕底部显示“联系维修人员”，点击可直接拨打维修人员电话；
             */
            _bottomButton.hidden = NO;
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)-42);
            [_bottomButton setTitle:@"联系维修人员" forState:UIControlStateNormal];
        }
            break;

        case 3:
        {
            /**
             *  已完成，维修完成，显示“维修完成，等待评价”，屏幕底部显示“立即评价”按钮，点击进入评价页面；
             */
            _bottomButton.hidden = NO;
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)-42);
            [_bottomButton setTitle:@"立即评价" forState:UIControlStateNormal];
        }
            break;
        default:
        {
            _bottomButton.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height));
        }
            break;
    }

}
/**
 *  报修跟踪数据请求
 */
- (void)httpRequest {
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [ReservePresenter getReserveLogForReserveid:_userInfo.theID upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode) {
                
                dataArray = [[NSMutableArray alloc]init];
                [dataArray addObjectsFromArray:data];
                [self bottomButtonState];
                [selfWeak.tableView reloadData];
                
            }else {
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            
        });
        
    }];

}
- (void)createBottomButton {

    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.hidden = YES;
    _bottomButton.backgroundColor = kNewRedColor;
    [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bottomButton.titleLabel.font = DEFAULT_BOLDFONT(16);
    [self.view addSubview:_bottomButton];
    _bottomButton.frame = CGRectMake(0, SCREEN_HEIGHT-42-(44+statuBar_Height), SCREEN_WIDTH, 42);
    [_bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)bottomButtonClick:(UIButton *)button {
    
    UserReserveLog *model = dataArray[0];
    switch (model.state.intValue) {
            
        case -1:
        {
            /**
             *  已驳回，物业因信息未填写完整将报修单驳回，显示“报修信息不完整，物业驳回”，屏幕显示“修改报修单”按钮，点击进入在线报修页面，将原信息带入；
             */
            
            ///家用设施
            if ([_userInfo.type integerValue] == 0) {
                RaiN_NewOnlineServiceVC *newOnline = [[RaiN_NewOnlineServiceVC alloc] init];
                newOnline.hidesBottomBarWhenPushed = YES;
                newOnline.fromType = @"1";
                newOnline.jmpCode = 1;
                newOnline.userInfo = _userInfo;
                newOnline.isFormMy = _isFormMy;
                [self.navigationController pushViewController:newOnline animated:YES];
            }else {
                RaiN_NewOnlineServiceVC *newOnline = [[RaiN_NewOnlineServiceVC alloc] init];
                newOnline.hidesBottomBarWhenPushed = YES;
                newOnline.fromType = @"0";
                newOnline.jmpCode = 1;
                newOnline.userInfo = _userInfo;
                newOnline.isFormMy = _isFormMy;
                [self.navigationController pushViewController:newOnline animated:YES];
            }
        }
            break;
        case 2:
        {
            /**
             *  处理中，已分派维修人员，显示“XXX（手机号）正在处理”，屏幕底部显示“联系维修人员”，点击可直接拨打维修人员电话；
             */
            NSString * phone = _userInfo.visitlinkphone;
            if ([RegularUtils isPhoneNum:phone]) {
//                SysPresenter * sysPresenter=[SysPresenter new];
//                [sysPresenter callMobileNum:phone superview:self.view];
                [SysPresenter callPhoneStr:phone withVC:self];
                
            }else {
                [self showToastMsg:@"该维修人员手机号不正确" Duration:2.0];
            }
            
        }
            break;
            
        case 3:
        {
            /**
             *  已完成，维修完成，显示“维修完成，等待评价”，屏幕底部显示“立即评价”按钮，点击进入评价页面；
             */
            //去评价
            THRequiredCommentViewController *commentVC = [[THRequiredCommentViewController alloc]init];
            commentVC.userInfo = _userInfo;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        default:
            break;
    }
    

    
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerClass:[THMyrequiredTVCStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyrequiredTVCStyle1 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle2 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle2 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle3 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle3 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle4 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle4 class])];
    [_tableView registerClass:[THMyrequiredTVCPicStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyrequiredTVCPicStyle1 class])];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    
    if (section == 1) {
        MyRequiredSectionView *sectionView = [[MyRequiredSectionView alloc]initWithFrame:CGRectMake(10, 0, 160, 60)];
        [view addSubview:sectionView];
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [THMyrequiredTVCStyle1 class];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            currentClass = [THMyRequiredTVCStyle2 class];
        }
        if (indexPath.row == 2) {
            
            currentClass = [THMyrequiredTVCPicStyle1 class];

//            currentClass = [THMyRequiredTVCStyle3 class];
        }
        return [_tableView cellHeightForIndexPath:indexPath model:_userInfo keyPath:@"userInfo" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];

    }else {
        UserReserveLog *model = dataArray[indexPath.row];
        currentClass = [THMyRequiredTVCStyle4 class];
        if ([model.state intValue] == 4 && ![XYString isBlankString:_userInfo.evaluate]) {
            
            CGSize size = [_userInfo.evaluate boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 169, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:DEFAULT_FONT(14)} context:nil].size;

//            return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"userInfo" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
            return size.height+80;


        }
        return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"userInfo" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [THMyrequiredTVCStyle1 class];
    THMyrequiredTVCStyle1 *cell = nil;

    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            currentClass = [THMyRequiredTVCStyle2 class];
        }
        if (indexPath.row == 2) {
            
            currentClass = [THMyrequiredTVCPicStyle1 class];

//            currentClass = [THMyRequiredTVCStyle3 class];
        }
        
    }else {
        currentClass = [THMyRequiredTVCStyle4 class];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.userInfo = _userInfo;
    }else {
        UserReserveLog *model = dataArray[indexPath.row];
        
        if (_userInfo.state.intValue == 4) {
            
            if (indexPath.row == 0) {
                UserReserveLog *model = dataArray[0];
                
                ((THMyRequiredTVCStyle4 *)cell).model = _userInfo;
                ((THMyRequiredTVCStyle4 *)cell).isCompleted = YES;
                ((THMyRequiredTVCStyle4 *)cell).userInfo = model;
            }else {
                ((THMyRequiredTVCStyle4 *)cell).isCompleted = NO;
                ((THMyRequiredTVCStyle4 *)cell).userInfo = model;
            }
            

            
        }else {
            ((THMyRequiredTVCStyle4 *)cell).isCompleted = NO;
            ((THMyRequiredTVCStyle4 *)cell).userInfo = model;
            
        }
        

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    CGFloat rightWidth = 13;

    if (indexPath.section == 1) {
        width = 30;
        rightWidth = 17;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, rightWidth)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, rightWidth)];
    }
}




@end
