//
//  L_MyMoneyViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyMoneyViewController.h"
//TVC
#import "L_MoneyDetailTVC.h"
//VC
#import "L_WithdrawMoneyViewController.h"

#import "L_NewMinePresenters.h"
#import "MySettingAndOtherLogin.h"
//Model
#import "GetMyBinding.h"

#import "VehicleAlertVC.h"
#import "L_GuideAttentionVC.h"

#import <ShareSDK/ShareSDK.h>

#import "UserPointAndMoneyPresenters.h"

@interface L_MyMoneyViewController () <UITableViewDelegate, UITableViewDataSource>
{
    AppDelegate *appdelegate;
    NSInteger page;
    NSInteger pagesize;
    NSMutableArray *dataArray;
    GetMyBinding *WXBindingModel;
    NSString * unionid;    
}

/**
 余额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 是否绑定微信
 */
@property (nonatomic, assign) BOOL isBindingWeChat;

/**
 *  我的信息model
 */
@property (nonatomic, strong) UserData *userData;

@end

@implementation L_MyMoneyViewController

- (void)backButtonClick {
    
    if (_isFromPush) {
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else {
        [super backButtonClick];
    }
    
}

/**
 分页获得我的余额记录

 @param isRefresh 是否是刷新
 */
- (void)httpRequestForGetbalancelistRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    [L_NewMinePresenters getBalanceListWithPage:page pagesize:pagesize UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                if (isRefresh) {
                    
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                    
                    L_BalanceListModel *model = dataArray[0];
                    NSString *balanceStr = [NSString stringWithFormat:@"%@",model.balance];
                    if (![XYString isBlankString:balanceStr]) {
                        appdelegate.userData.balance = balanceStr;
                        [appdelegate saveContext];
                    }
                    //余额
                    if (![XYString isBlankString:appdelegate.userData.balance]) {
                        _moneyLabel.text = [NSString stringWithFormat:@"%.2f",appdelegate.userData.balance.doubleValue];
                    }else {
                        _moneyLabel.text = @"0.00";
                    }
                    
                }else {
                    
                    if (((NSArray *)data).count == 0) {
                        page = page - 1;
                    }
                    
                    NSArray * tmparr = (NSArray *)data;
                    NSInteger count = dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [_tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:20];
                    for (int i = 0; i < tmparr.count; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [_tableView endUpdates];
                }

                
            }else {
                
                if (isRefresh) {
                }else {
                    page = page - 1;
                }


            }
            
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:@"yu e"];

    appdelegate = GetAppDelegates;
    _userData = appdelegate.userData;
    //余额
    if (![XYString isBlankString:_userData.balance]) {
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f",_userData.balance.floatValue];
    }else {
        _moneyLabel.text = @"0.00";
    }
    
    [_tableView.mj_header beginRefreshing];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt markStatistics:YuE];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"yu e"];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":YuE}];
    
}


#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    pagesize = 20;
    dataArray = [[NSMutableArray alloc] init];
    _isBindingWeChat = NO;

    
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"L_MoneyDetailTVC" bundle:nil] forCellReuseIdentifier:@"L_MoneyDetailTVC"];
    
    @WeakObj(self);

    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetbalancelistRefresh:YES];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetbalancelistRefresh:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
}

/**
 提现按钮点击

 @param sender 提现按钮
 */
- (IBAction)getMoneyButtonDidTouch:(UIBarButtonItem *)sender {
    
//    L_WithdrawMoneyViewController *withdrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_WithdrawMoneyViewController"];
//    [self.navigationController pushViewController:withdrawVC animated:YES];
//    return;
    
    NSLog(@"提现");
    @WeakObj(self);
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [MySettingAndOtherLogin getMyOtherBindingWithUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSDictionary *dict = (NSDictionary *)data;
                
                NSArray *array = [GetMyBinding mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"list"]];
                
                for (int i = 0; i < array.count; i++) {
                    GetMyBinding *model = array[i];
                    if ([model.type isEqualToString:@"2"]) {
                        if ([model.isbinding isEqualToString:@"1"]) {
                            _isBindingWeChat = YES;
                            unionid = model.unionid;
                            WXBindingModel = model;
                            break;
                        }
                    }
                }
                
                if (_isBindingWeChat) {
                    
                    ///判断用户是否关注公众号
                    [selfWeak whetherToFocusOn];
                    
                }else {
                    
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                    //提示框
                    
                    VehicleAlertVC *vc = [[VehicleAlertVC alloc] init];
                    [vc showithTitle:@"提示：\n您还未绑定微信，请先绑定微信后再进行提现" :self ShowCancelBtn:YES ISBinding: YES isLignt:YES];
                    [vc.confirmBtn setTitle:@"马上绑定" forState:UIControlStateNormal];
                    vc.confirmBtn.layer.borderWidth = 1;
                    vc.confirmBtn.layer.borderColor = kNewRedColor.CGColor;
                    [vc.confirmBtn setBackgroundColor:kNewRedColor];
                    [vc.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    @WeakObj(self);
                    vc.block = ^(NSInteger type)
                    {
                        if (type == 1) {
                            
                            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                            ///开关为关,拉取授权进行绑定
                            [ShareSDK getUserInfo : SSDKPlatformTypeWechat onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
                                
                                if (state == SSDKResponseStateSuccess ) {
                                    NSString *TokenStr = [XYString IsNotNull:user.credential.token];
 
                                    NSString *IDStr = [XYString IsNotNull:user.uid];

                                    NSString *nameStr = [XYString IsNotNull:user.nickname];
                                    
                                    //授权成功 请求接口
                                    NSLog ( @"uid=%@" ,user.uid );
                                    NSLog ( @"%@" ,user.credential );
                                    NSLog ( @"token=%@" ,user.credential.token );
                                    NSLog ( @"nickname=%@" ,user.nickname );
                                    unionid = [user.rawData objectForKey:@"unionid"];
                                    
                                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

                                    [MySettingAndOtherLogin addOtherBindingWithType:@"2" AndThifdToken:TokenStr AndPhone:_userData.phone AndPassword:@"" andThirdid:IDStr andAccount:nameStr AndVerificode:@"" AndUnionID:unionid AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                            
                                            if (resultCode == SucceedCode) {
                                                
                                                ///判断用户是否关注公众号
                                                [selfWeak whetherToFocusOn];
                                                
                                                
                                            }else {
                                                
                                                [self showToastMsg:(NSString *)data Duration:3.0];
                                                
                                            }
                                            
                                        });
                                        
                                    }];
                                    
                                }else if(state == SSDKResponseStateCancel) {
                                    
                                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                    
                                    [selfWeak showToastMsg:@"您已取消授权" Duration:3.0];
                                    
                                }else if (state == SSDKResponseStateFail) {
                                    
                                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                    
                                    [selfWeak showToastMsg:@"授权失败" Duration:3.0];
                                }
                                
                            }];

                        }
                    };

                }
                
            }else {
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                [self showToastMsg:(NSString *)data Duration:3.0];
                
            }
            
        });
        
    }];

}
#pragma mark - 判断用户是否关注公众账号

- (void)whetherToFocusOn {
    
    @WeakObj(self);
    [L_NewMinePresenters  whetherToFocusOn:unionid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if (resultCode == SucceedCode) {
                
                NSLog(@"----用户是否关注接口-----%@",data);
                NSDictionary * dic = data;
                NSString * isfollow = [dic objectForKey:@"isfollow"];
                if(isfollow.boolValue)
                {
                    
                    L_WithdrawMoneyViewController *withdrawVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_WithdrawMoneyViewController"];
                    [self.navigationController pushViewController:withdrawVC animated:YES];

                    
                }else{
                
                    L_GuideAttentionVC * lgaVC = [[L_GuideAttentionVC alloc]init];
                    lgaVC.unionid = unionid;
                    [selfWeak.navigationController pushViewController:lgaVC animated:YES];

                }
                
            }else if(resultCode == FailureCode)
            {
                L_GuideAttentionVC * lgaVC = [[L_GuideAttentionVC alloc]init];
                lgaVC.unionid = unionid;
                [selfWeak.navigationController pushViewController:lgaVC animated:YES];
            }
        });
    }];
    
}
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_MoneyDetailTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MoneyDetailTVC"];

    if (dataArray.count > 0) {
        L_BalanceListModel *model = dataArray[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
}

@end
