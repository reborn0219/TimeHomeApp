//
//  L_MyExchangeListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyExchangeListViewController.h"
#import "L_ExchangeListTVC.h"
#import "L_ButtonListTVC.h"

#import "L_MyFailListViewController.h"
#import "L_NewPointPresenters.h"
#import "WebViewVC.h"
#import "L_MyNewFirstOrderTVC.h"
#import "L_GivenPeopleListViewController.h"

@interface L_MyExchangeListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isHaveOverTime;//是否有已失效
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation L_MyExchangeListViewController

- (void)backButtonClick {
    
    if (_isFromPush) {
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else {
        [super backButtonClick];
    }
    
}

// MARK: - 获得用户兑换的所有的兑换券
/**
 获得用户兑换的所有的兑换券 0为已兑换但是没有使用的 -1过期
 */
- (void)httpRequestForGetGoodsLogList {
    
    _tableView.hidden = NO;
    [L_NewPointPresenters getGoodsLoglistWithState:@"0" isexchange:0 updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                if ([data[@"map"][@"ishaveovertime"] integerValue] == 0) {
                    isHaveOverTime = NO;
                }else {
                    isHaveOverTime = YES;
                }

                [_dataArray removeAllObjects];
                NSArray *array = [L_ExchangeModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
                [_dataArray addObjectsFromArray:array];
                [_tableView reloadData];
                
                if (_dataArray.count == 0) {
                    
                    _tableView.hidden = YES;
                    @WeakObj(self)
                     [self showNothingnessViewWithType:NoContentTypeShopExchange Msg:@"您还没有兑换任何商品，赶快去积分商城兑换吧" SubMsg:@"" btnTitle:@"马上兑换" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                         
                         if (index == 0) {
                             [selfWeak comeingoodsWithCallBack:^{
                                 [_tableView.mj_header beginRefreshing];
                             }];
                         }
                         
                     }];

                    self.nothingnessView.hidden = NO;
                    [self.view sendSubviewToBack:self.nothingnessView];
                    
                    if (isHaveOverTime) {
                        /** 查看已失效券按钮 */
                        self.nothingnessView.checkButton.hidden = NO;
                        self.nothingnessView.checkButtonCallBack = ^(){
                          
                            [selfWeak gotoFailListVC];
                            
                        };
                    }else {
                        self.nothingnessView.checkButton.hidden = YES;
                    }
                    
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
    [appDlgt markStatistics:WoDeDingDan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":WoDeDingDan}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHaveOverTime = NO;
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyNewFirstOrderTVC" bundle:nil] forCellReuseIdentifier:@"L_MyNewFirstOrderTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_ButtonListTVC" bundle:nil] forCellReuseIdentifier:@"L_ButtonListTVC"];
    
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
    if (isHaveOverTime) {
        return _dataArray.count + 1;
    }else {
        return _dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _dataArray.count) {
        return 60;
    }else {
        L_ExchangeModel *model = _dataArray[indexPath.section];
        return model.height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == _dataArray.count) {
        
        L_ButtonListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_ButtonListTVC"];
        
        cell.buttonDidBlock = ^(){
            
            [self gotoFailListVC];
            
        };
        
        return cell;
        
    }else {
        
        L_MyNewFirstOrderTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyNewFirstOrderTVC"];
        
        L_ExchangeModel *model = _dataArray[indexPath.section];
        cell.model = model;
        
        cell.givenButtonDidTouchBlock = ^(){
          
            NSLog(@"赠予");
            L_GivenPeopleListViewController *givenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_GivenPeopleListViewController"];
            givenVC.theid = model.theID;
            givenVC.givenSuccessBlock = ^() {
              
                [_tableView.mj_header beginRefreshing];
                
            };
            [self.navigationController pushViewController:givenVC animated:YES];
            
        };
        
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < _dataArray.count) {
        L_ExchangeModel *model = _dataArray[indexPath.section];
        [self gotoExchangeInfoWithID:model.convertid];
    }
    
}
// MARK: - 已失效券入口
- (void)gotoFailListVC {
    L_MyFailListViewController *failVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyFailListViewController"];
    [self.navigationController pushViewController:failVC animated:YES];
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
