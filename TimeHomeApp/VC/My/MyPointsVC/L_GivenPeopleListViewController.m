//
//  L_GivenPeopleListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GivenPeopleListViewController.h"
#import "L_MyGivenPeopleListTVC.h"
#import "L_NewMinePresenters.h"
#import "L_GivenPopVC.h"
#import "L_NewPointPresenters.h"

@interface L_GivenPeopleListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isRereshing;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

/**
 发送弹出框
 */
@property (nonatomic, strong) L_GivenPopVC *givenPopVC;

@end

@implementation L_GivenPeopleListViewController


/**
 发送给用户

 @param message 留言信息
 */
- (void)httpRequestForSendInfo:(NSString *)message withModel:(L_MyFollowersModel *)model callBack:(void(^)())callBack {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_NewPointPresenters persentCertificateWithUserid:model.userid theid:_theid message:message updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [self showToastMsg:data[@"errmsg"] Duration:3.0];
                if (callBack) {
                    callBack();
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

/**
 获得关注的用户列表

 @param isRefresh 是否为刷新
 */
- (void)httpRequestForMyAttentionsIsRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        _page = 1;
        isRereshing = YES;
    }else {
        if (isRereshing) {
            [_tableView.mj_footer endRefreshing];
            return;
        }
        _page ++;
    }
    _tableView.hidden = NO;

    [L_NewMinePresenters getMyFollowWithPagesize:20 page:_page UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
            
                if (isRefresh) {
                    
                    [_dataArray removeAllObjects];
                    [_dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                    isRereshing = NO;
                }else {
                    
                    
                    if (((NSArray *)data).count == 0) {
                        _page = _page - 1;
                    }else {
                        NSArray * tmparr = (NSArray *)data;
                        NSInteger count = _dataArray.count;
                        [_dataArray addObjectsFromArray:tmparr];
                        [_tableView beginUpdates];
                        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:20];
                        for (int i = 0; i < tmparr.count; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                            [insertIndexPaths addObject:newPath];
                        }
                        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [_tableView endUpdates];
                    }
                    
                }
                
                if (_dataArray.count == 0) {
                    _tableView.hidden = YES;
                    [self showNothingnessViewWithType:NoContentTypeAttentionFriends Msg:@"您还未关注朋友噢，快去邻趣交友吧！" eventCallBack:nil];
                    [self.view sendSubviewToBack:self.nothingnessView];
                    
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                });
            
            }else {
                if (isRefresh) {

                }else {
                    _page = _page - 1;
                }
                
                if (_dataArray.count == 0) {
                    _tableView.hidden = YES;
                    [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"加载失败，点击刷新" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        _tableView.hidden = NO;
                        [self hiddenNothingnessView];
                        [_tableView.mj_header beginRefreshing];
                        
                    }];

                    self.nothingnessView.hidden = NO;
                    [self.view sendSubviewToBack:self.nothingnessView];
                }
                
            }
            
        });
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

    _dataArray = [[NSMutableArray alloc] init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;

    _tableView.tableFooterView = [[UIView alloc] init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyGivenPeopleListTVC" bundle:nil] forCellReuseIdentifier:@"L_MyGivenPeopleListTVC"];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForMyAttentionsIsRefresh:YES];
    }];

    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForMyAttentionsIsRefresh:NO];

    }];
    
    [_tableView.mj_header beginRefreshing];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = BLACKGROUND_COLOR;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [bgView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    titleLabel.textColor = TITLE_TEXT_COLOR;
    titleLabel.font = DEFAULT_BOLDFONT(14);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"请选择您已关注的用户";
    
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_dataArray.count > 0 ) {

        L_MyGivenPeopleListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyGivenPeopleListTVC"];

        if (indexPath.row == 0) {
            cell.bottomLineView.hidden = YES;
        }else {
            cell.bottomLineView.hidden = NO;
        }
        
        L_MyFollowersModel *model = _dataArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_MyFollowersModel *model = _dataArray[indexPath.row];
    _givenPopVC = [L_GivenPopVC getInstance];

    [_givenPopVC showVC:self withInfoDict:@{@"picurl":model.userpicurl,@"nickname":model.nickname} cellEvent:^(NSInteger buttonIndex, NSString *context) {
       
        if (buttonIndex == 2) {
            NSLog(@"发送===%@",context);
            [self httpRequestForSendInfo:context withModel:model callBack:^{
                if (self.givenSuccessBlock) {
                    self.givenSuccessBlock();
                }
                [_givenPopVC dismissVC];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
        
    }];
    
}


@end
