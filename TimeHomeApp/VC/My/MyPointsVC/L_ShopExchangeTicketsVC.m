//
//  L_ShopExchangeTicketsVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ShopExchangeTicketsVC.h"
#import "L_ShopTicketInfoVC.h"

#import "L_ShopTicketListTVC.h"
#import "WebViewVC.h"

#import "L_NewPointPresenters.h"

@interface L_ShopExchangeTicketsVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation L_ShopExchangeTicketsVC

#pragma mark - 网络请求

/**
 获得用户商城兑换券记录
 */
- (void)httpRequestForGetUserCouponList {
    
    [L_NewPointPresenters getUserCouponListUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                [_listArray removeAllObjects];
                [_listArray addObjectsFromArray:data];
                
                [_tableView reloadData];
                
                if (_listArray.count == 0) {
                    _tableView.hidden = YES;
                    
                    [self showNothingnessViewWithType:NoContentTypeShopExchange Msg:@"您还没有获得任何商城兑换券~" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        [self hiddenNothingnessView];
                        _tableView.hidden = NO;
                        [_tableView.mj_header beginRefreshing];
                        
                    }];
                    
                }
                
            }else if (resultCode == FailureCode) {
                
                _tableView.hidden = YES;
                [self showToastMsg:data Duration:3.0];
                
                [self showNothingnessViewWithType:NoContentTypeShopExchange Msg:@"您还没有获得任何商城兑换券~" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    [self hiddenNothingnessView];
                    _tableView.hidden = NO;
                    [_tableView.mj_header beginRefreshing];
                    
                }];

                
            }else if (resultCode == NONetWorkCode) {
                
                _tableView.hidden = YES;
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    [self hiddenNothingnessView];
                    _tableView.hidden = NO;
                    [_tableView.mj_header beginRefreshing];
                    
                }];
                
            }
            
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listArray = [[NSMutableArray alloc] init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;

    [_tableView registerNib:[UINib nibWithNibName:@"L_ShopTicketListTVC" bundle:nil] forCellReuseIdentifier:@"L_ShopTicketListTVC"];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetUserCouponList];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_ShopTicketListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_ShopTicketListTVC"];
    
    if (_listArray.count > 0) {
        L_CouponListModel *model = _listArray[indexPath.section];
        cell.model = model;
        
        cell.buttonsCallBack = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            //1.详情 2.去使用
            
            if (index == 1) {
                L_ShopTicketInfoVC *shopInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_ShopTicketInfoVC"];
                shopInfoVC.couponModel = model;
                [self.navigationController pushViewController:shopInfoVC animated:YES];
            }
            
            if (index == 2) {
                [self gotoExchangeInfoWithID:model.couponid];
            }
            
        };
        
    }
    
    return cell;
    
}

// MARK: - 详情入口
-(void)gotoExchangeInfoWithID:(NSString *)theid {
    
    AppDelegate *appDlgt = GetAppDelegates;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    NSString *url = [NSString stringWithFormat:@"%@/mobile/index.php?app=member&act=login&token=%@&userid=%@&allow=1&ret_url=%%2Fmobile%%2Findex.php%%3Fapp%%3Dgoods%%26coupon_id%%3D",kShopSEVER_URL,appDlgt.userData.token,appDlgt.userData.userID];
    url = [url stringByAppendingString:theid];
    
    webVc.url = url;
    
    webVc.isNoRefresh = YES;
    webVc.isHiddenBar = YES;
    webVc.talkingName = JiFenShangCheng;
    
    webVc.shopCallBack = ^() {
        NSLog(@"回调");
        [_tableView.mj_header beginRefreshing];
    };
    
    webVc.title=@"商城";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

@end
