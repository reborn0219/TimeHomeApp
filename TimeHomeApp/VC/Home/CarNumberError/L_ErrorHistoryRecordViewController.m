//
//  L_ErrorHistoryRecordViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ErrorHistoryRecordViewController.h"
#import "L_CarErrorPresenter.h"
#import "L_CarErrorHistoryListTVC.h"

@interface L_ErrorHistoryRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) int page;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;/** 列表数组 */

@end

@implementation L_ErrorHistoryRecordViewController

#pragma mark - 网络请求

/**
 获得用户车牌纠错历史纪录
 */
- (void)httpRequestForGetUserApplyList {
    
    [self hiddenNothingnessView];
    
    [L_CarErrorPresenter getUserApplyListWithPage:_page updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
//            if (_tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
//                [_tableView.pullToRefreshView stopAnimating];
//            }
//            
//            if (_tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
//                [_tableView.infiniteScrollingView stopAnimating];
//            }
            
            if (resultCode == SucceedCode) {
                
                NSArray *arr = (NSArray *)data;
                
                if (arr.count > 0) {
                    
                    if (_page == 1) {
                        [_listArray removeAllObjects];
                    }
                    [_listArray addObjectsFromArray:arr];
                    
                    [_tableView reloadData];
                    if (_page == 1) {
                        if (_listArray.count > 0) {
                            [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//                            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        }
                    }
                    _page ++;
                    
                }
                
                if (_listArray.count == 0) {
                    
                    [self showNothingnessViewWithType:NoContentTypePublish Msg:@"暂无纠错记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        [_tableView.mj_header beginRefreshing];
                    }];
                    
                }
                
            }else if(resultCode == FailureCode) {
                
                if ([data isKindOfClass:[NSString class]]) {
                    [self showToastMsg:data Duration:3.0];
                }else {
                    
                    if ([[data objectForKey:@"errcode"]intValue] == 99999) {
                        if (_listArray.count > 0) {
                            [self showToastMsg:@"没有更多数据了！" Duration:3.0];
                        }
                    }else {
                        NSString * errmsg=[data objectForKey:@"errmsg"];
                        [self showToastMsg:errmsg Duration:3.0];
                    }
                    
                }

                if (_listArray.count == 0) {
                    [self showNothingnessViewWithType:NoContentTypePublish Msg:@"暂无纠错记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        [_tableView.mj_header beginRefreshing];
                    }];
                }
                
            }else if(resultCode == NONetWorkCode)//无网络处理
            {
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    [_tableView.mj_header beginRefreshing];
                }];
            }
            
        });
        
    }];
    
}

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_CarErrorHistoryListTVC" bundle:nil] forCellReuseIdentifier:@"L_CarErrorHistoryListTVC"];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        _page = 1;
        [selfWeak httpRequestForGetUserApplyList];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetUserApplyList];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    L_CarNumApplyListModel *model = _listArray[indexPath.row];
    return model.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_CarErrorHistoryListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CarErrorHistoryListTVC"];
    
    L_CarNumApplyListModel *model = _listArray[indexPath.row];
    cell.listModel = model;
    
    return cell;
}

@end

