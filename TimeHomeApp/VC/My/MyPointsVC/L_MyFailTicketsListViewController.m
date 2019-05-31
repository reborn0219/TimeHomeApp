//
//  L_MyFailTicketsListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyFailTicketsListViewController.h"
#import "L_NewPointPresenters.h"
#import "WebViewVC.h"
#import "L_MyNewFistOutdateOrderTVC.h"
#import "L_OrderTimeTVC.h"

@interface L_MyFailTicketsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation L_MyFailTicketsListViewController

// MARK: - 获得用户兑换的所有的兑换券
/**
 获得用户兑换的所有的兑换券 0为已兑换但是没有使用的 -1过期
 */
- (void)httpRequestForGetGoodsLogList {
    
    _tableView.hidden = NO;
    [L_NewPointPresenters getGoodsLoglistWithState:@"-1" isexchange:1 updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                [_dataArray removeAllObjects];
                NSArray *array = [L_ExchangeModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
                [_dataArray addObjectsFromArray:array];
                [_tableView reloadData];
                
                if (_dataArray.count == 0) {
                    
                    _tableView.hidden = YES;
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据，点击刷新" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        _tableView.hidden = NO;
                        self.nothingnessView.hidden = YES;
                        [_tableView.mj_header beginRefreshing];
                        
                    }];

                    self.nothingnessView.hidden = NO;
                    [self.view sendSubviewToBack:self.nothingnessView];
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
                
                _tableView.hidden = YES;
                
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"加载失败，点击刷新" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    _tableView.hidden = NO;
                    self.nothingnessView.hidden = YES;
                    [_tableView.mj_header beginRefreshing];
                    
                }];

                self.nothingnessView.hidden = NO;
                [self.view sendSubviewToBack:self.nothingnessView];
                
            }
            
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt markStatistics:WoDePiaoQuan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":WoDePiaoQuan}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyNewFistOutdateOrderTVC" bundle:nil] forCellReuseIdentifier:@"L_MyNewFistOutdateOrderTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_OrderTimeTVC" bundle:nil] forCellReuseIdentifier:@"L_OrderTimeTVC"];
    
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetGoodsLogList];
        
    }];

    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        L_ExchangeModel *model = _dataArray[indexPath.section];
        return model.height;
    }else {
        return 34;
    }
        
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        L_MyNewFistOutdateOrderTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyNewFistOutdateOrderTVC"];
        
        cell.bottomLineView.hidden = NO;

        L_ExchangeModel *model = _dataArray[indexPath.section];
        cell.model = model;
        
        return cell;
        
    }else {
        
        L_OrderTimeTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_OrderTimeTVC"];
        
        cell.timeLabel.textColor = TEXT_COLOR;
        
        L_ExchangeModel *model = _dataArray[indexPath.section];
        cell.model = model;
        
        return cell;
        
    }
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_ExchangeModel *model = _dataArray[indexPath.section];
    [self gotoExchangeInfoWithID:model.convertid];
    
}

// MARK: - 详情入口
-(void)gotoExchangeInfoWithID:(NSString *)theid {
    
    AppDelegate *appDlgt = GetAppDelegates;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    NSString *url = [NSString stringWithFormat:@"%@/mobile/index.php?app=member&act=login&token=%@&userid=%@&allow=1&ret_url=%%2Fmobile%%2Findex.php%%3Fapp%%3Dbuyer_order%%26act%%3Dview%%26order_id%%3D",kShopSEVER_URL,appDlgt.userData.token,appDlgt.userData.userID];
    url = [url stringByAppendingString:theid];
    
    webVc.url = url;
    
    webVc.isNoRefresh = YES;
    webVc.isHiddenBar = YES;
    webVc.talkingName = JiFenShangCheng;

    webVc.shopCallBack = ^() {
        
        [_tableView.mj_header beginRefreshing];
    };
    
    webVc.title=@"商城";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

@end
