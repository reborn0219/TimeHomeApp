//
//  L_NewPointCenterViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewPointCenterViewController.h"

#import "L_PointCenterHeaderView.h"
#import "L_PointSectionHeaderView.h"
#import "L_NewPointTVC.h"

/**
 * 用户积分请求
 */
#import "UserPointAndMoneyPresenters.h"

#import "L_PointRuleShowViewController.h"
#import "L_TaskBoardListViewController.h"
//#import "L_MyExchangeListViewController.h"
#import "WebViewVC.h"

@interface L_NewPointCenterViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger sectionButtonIndex;//1.全部 2.收入 3.支出
    AppDelegate *appDlgt;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) L_PointSectionHeaderView *sectionHeaderView;

@property (nonatomic, strong) L_PointCenterHeaderView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray *dataArray;//全部
@property (nonatomic, strong) NSMutableArray *addCountArray;//收入
@property (nonatomic, strong) NSMutableArray *minusCountArray;//支出

@property (nonatomic, assign) NSInteger page;

@property(nonatomic,strong) NothingnessView * nothingView;

@end

@implementation L_NewPointCenterViewController

// MARK: - 积分请求
/**
 积分请求

 @param refresh 是否是刷新
 */
- (void)httpRequestPullToRefreshOrNot:(BOOL)refresh {
    
    if (refresh) {
        _page = 1;
    }else {
        _page  = _page + 1;
    }
    //type =0支出 1收入
    /**
     *  积分日志请求
     */
    [UserPointAndMoneyPresenters getIntegralLogPage:[NSString stringWithFormat:@"%ld",(long)_page] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if(resultCode == SucceedCode)
            {
                if (refresh) {
                    
                    [_dataArray removeAllObjects];
                    [_minusCountArray removeAllObjects];
                    [_addCountArray removeAllObjects];
                    
                    _tableHeaderView.pointLabel.text = [XYString isBlankString:appDlgt.userData.integral] ? @"0" : appDlgt.userData.integral;

                }else {
                    if (((NSArray *)data).count == 0) {
                        _page --;
                    }
                }
                
                if (((NSArray *)data).count > 0) {

                    [_dataArray addObjectsFromArray:data];
                    
                    for (UserIntergralLog *model in data) {
                        
                        NSString *intergralString = [NSString stringWithFormat:@"%@",model.integral];
                        
                        if (intergralString.floatValue < 0) {

                            [_minusCountArray addObject:model];
                            
                        }else {

                            [_addCountArray addObject:model];
                        }
                        
                    }
                    
                    [_tableView reloadData];
                
                }

                if (sectionButtonIndex == 1) {
                    
                    if (_dataArray.count == 0) {
                        [self showNothingViewEventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {}];
                    }else {
                        [self hiddenNothingView];
                    }
                    
                }else if (sectionButtonIndex == 2) {
                    
                    if (_addCountArray.count == 0) {
                        [self showNothingViewEventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {}];
                    }else {
                        [self hiddenNothingView];
                    }
                    
                }else {
                    
                    if (_minusCountArray.count == 0) {
                        [self showNothingViewEventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {}];
                    }else {
                        [self hiddenNothingView];
                    }
                    
                }
                
            }else {
                
                if (refresh) {
                    
                    _tableHeaderView.pointLabel.text = [XYString isBlankString:appDlgt.userData.integral] ? @"0" : appDlgt.userData.integral;

                    _page = 1;
                    
                }else {
                    _page --;
                }
                
            }
        });
        
    }];
    if (refresh) {
        [self getUserIntergelAndAccount];
    }
}
/**
 *  获得用户的积分和余额
 */
- (void)getUserIntergelAndAccount {
    
    [UserPointAndMoneyPresenters getIntegralBalanceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                _tableHeaderView.pointLabel.text = [XYString isBlankString:appDlgt.userData.integral] ? @"0" : appDlgt.userData.integral;
            }
            
        });
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
//    [TalkingData trackPageBegin:@"jifen"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:JiFen];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"jifen"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":JiFen}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    appDlgt = GetAppDelegates;
    
    _dataArray = [[NSMutableArray alloc] init];
    _addCountArray = [[NSMutableArray alloc] init];
    _minusCountArray = [[NSMutableArray alloc] init];
    
    _page = 1;
    
    sectionButtonIndex = 1;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewPointTVC" bundle:nil] forCellReuseIdentifier:@"L_NewPointTVC"];

    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestPullToRefreshOrNot:YES];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestPullToRefreshOrNot:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
    [_tableView.mj_header beginRefreshing];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_tableHeaderView) {
        _tableHeaderView = [L_PointCenterHeaderView getInstance];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 225);
        _tableView.tableHeaderView = _tableHeaderView;
        
        _tableHeaderView.pointLabel.text = [XYString isBlankString:appDlgt.userData.integral] ? @"0" : appDlgt.userData.integral;
        
        @WeakObj(self)
        _tableHeaderView.allButtonDidTouchBlock = ^(NSInteger buttonIndex) {
            
            //1.我的兑换 2.赚积分 3.花积分
            NSLog(@"%ld",(long)buttonIndex);
            
//            if (buttonIndex == 1) {
//                L_MyExchangeListViewController *exchangeVC = [selfWeak.storyboard instantiateViewControllerWithIdentifier:@"L_MyExchangeListViewController"];
//                [selfWeak.navigationController pushViewController:exchangeVC animated:YES];
//            }
            
            if (buttonIndex == 2) {
                L_TaskBoardListViewController *taskVC = [selfWeak.storyboard instantiateViewControllerWithIdentifier:@"L_TaskBoardListViewController"];
                [selfWeak.navigationController pushViewController:taskVC animated:YES];
            }
            
            if (buttonIndex == 3) {
                [selfWeak comeingoodsWithCallBack:nil];
            }
        };
    }

}

// MARK: - 右上角按钮
- (IBAction)rightBarButtonDidTouch:(UIBarButtonItem *)sender {
    
    L_PointRuleShowViewController *pointRuleShowVC = [L_PointRuleShowViewController getInstance];
    [pointRuleShowVC showVC:self withString:@"积分获取\n您可以通过任务版查看每日获取积分的途径\n\n积分兑换\n1.部分优惠券有兑换时间,请在规定时间内兑换商品。\n2.兑换的部分商品有使用期限,请您在有效期内使用,过期不退不换。\n3.部分商品会有数量限制,手快有手慢无。\n4.积分商城所兑换商品,除质量问题,一律不退不换。\n\n积分商城所有规则最终解释权由优思科技所有\n如有疑问请联系电话：400-655-5110"];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionButtonIndex == 1) {
        return _dataArray.count;
    }else if (sectionButtonIndex == 2) {
        return _addCountArray.count;
    }else {
        return _minusCountArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_sectionHeaderView) {
        _sectionHeaderView = [L_PointSectionHeaderView getInstance];
        
        @WeakObj(self)
        _sectionHeaderView.sectionButtonDidTouchBlock = ^(NSInteger buttonIndex) {
            //1.全部 2.收入 3.支出
            sectionButtonIndex = buttonIndex;
            NSLog(@"buttonIndex==%ld",(long)buttonIndex);

            [selfWeak.tableView reloadData];
            if (selfWeak.tableView.contentOffset.y >= 220) {

                [selfWeak.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            if (buttonIndex == 1) {
                
                if (_dataArray.count == 0) {
                    [selfWeak showNothingViewEventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {}];
                }else {
                    [selfWeak hiddenNothingView];
                }
                
            }else if (buttonIndex == 2) {
                
                if (_addCountArray.count == 0) {
                    [selfWeak showNothingViewEventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {}];
                }else {
                    [selfWeak hiddenNothingView];
                }
                
            }else {
                
                if (_minusCountArray.count == 0) {
                    [selfWeak showNothingViewEventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {}];
                }else {
                    [selfWeak hiddenNothingView];
                }
                
            }

        };

    }
    
    return _sectionHeaderView;
}
// MARK: - 显示无数据视图
- (void)showNothingViewEventCallBack:(ViewsEventBlock) callBack{
    if(self.nothingView==nil)
    {
        self.nothingView=[NothingnessView getInstanceView];
        self.nothingView.frame = CGRectMake(0, 220, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height));
//        self.nothingView.frame = self.tableView.frame;
    }
    self.nothingView.view_SubBg.hidden=YES;
    [self.tableView addSubview:self.nothingView];
    [self.tableView bringSubviewToFront:self.nothingView];
    [self.nothingView.img_ErrorIcon setImage:[UIImage imageNamed:@"暂无数据"]];
    self.nothingView.lab_Clues.text = @"暂无数据  ";
    self.nothingView.eventCallBack  = callBack;
}
// MARK: - 隐藏无数据视图
-(void)hiddenNothingView {
    [self.nothingView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sectionButtonIndex == 1) {
        UserIntergralLog *model = _dataArray[indexPath.row];
        return model.height;
    }else if (sectionButtonIndex == 2) {
        UserIntergralLog *model = _addCountArray[indexPath.row];
        return model.height;
    }else {
        UserIntergralLog *model = _minusCountArray[indexPath.row];
        return model.height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_NewPointTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewPointTVC"];
    
    if (sectionButtonIndex == 1) {
        
        UserIntergralLog *model = _dataArray[indexPath.row];
        cell.model = model;
        
    }else if (sectionButtonIndex == 2) {
        
        UserIntergralLog *model = _addCountArray[indexPath.row];
        cell.model = model;
        
    }else {
        
        UserIntergralLog *model = _minusCountArray[indexPath.row];
        cell.model = model;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 16;
    
    if (sectionButtonIndex == 1) {
        if (indexPath.row == _dataArray.count -1) {
            width = SCREEN_WIDTH/2.;
        }
    }else if (sectionButtonIndex == 2) {
        if (indexPath.row == _addCountArray.count-1) {
            width = SCREEN_WIDTH/2.;
        }
    }else if (sectionButtonIndex == 3) {
        if (indexPath.row == _minusCountArray.count-1) {
            width = SCREEN_WIDTH/2.;
        }
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
