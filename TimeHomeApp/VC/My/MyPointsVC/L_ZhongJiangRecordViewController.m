//
//  L_ZhongJiangRecordViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ZhongJiangRecordViewController.h"
#import "L_ZJListsTVC.h"
#import "L_NewPointPresenters.h"

@interface L_ZhongJiangRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation L_ZhongJiangRecordViewController

#pragma mark - 网络请求

/**
 中奖纪录请求
 */
- (void)httpRequestForUserRecordList {
    
    [L_NewPointPresenters getUserRecordListUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
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
                    
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有中过奖哦~" SubMsg:@"坚持每日签到，就有机会参与抽奖哦" btnTitle:@"" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        [self hiddenNothingnessView];
                        _tableView.hidden = NO;
                        [_tableView.mj_header beginRefreshing];
                        
                    }];
                    
                }
                
            }else if (resultCode == FailureCode) {
                
                _tableView.hidden = YES;
                [self showToastMsg:data Duration:3.0];
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有中过奖哦~" SubMsg:@"坚持每日签到，就有机会参与抽奖哦" btnTitle:@"" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
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
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"L_ZJListsTVC" bundle:nil] forCellReuseIdentifier:@"L_ZJListsTVC"];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForUserRecordList];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_ZJListsTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_ZJListsTVC"];
    
    if (_listArray.count > 0) {
        
        L_RecordListModel *model = _listArray[indexPath.row];
        cell.model = model;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 10;
    
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
