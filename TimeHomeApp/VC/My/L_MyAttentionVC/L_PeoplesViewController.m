//
//  L_PeoplesViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PeoplesViewController.h"

//TVC
#import "L_PeopleListTVC.h"

#import "L_NewMinePresenters.h"

#import "WebViewVC.h"
#import "personListViewController.h"

@interface L_PeoplesViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger page;
    NSInteger pagesize;
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation L_PeoplesViewController

#pragma mark - 我的关注请求列表-+

/**
 我的关注请求列表

 @param isRefresh 是否是刷新
 */
- (void)httpRequestForMyFollowsListsRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    [L_NewMinePresenters getMyFollowWithPagesize:pagesize page:page UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
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
                    
                }else {

                    if (((NSArray *)data).count == 0) {
                        page = page - 1;
                    }else {
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

                }
                
            }else {
                if (isRefresh) {
                }else {
                    page = page - 1;
                }
                
            }
            
            if (dataArray.count == 0) {
                
                [self showNothingnessViewWithType:NoContentTypeAttentionFriends Msg:@"您最近没有新的关注" eventCallBack:nil];
                [self.view sendSubviewToBack:self.nothingnessView];
                
            }else {
                [self hiddenNothingnessView];
            }
            
        });
        
    }];
}

#pragma mark - 取消关注

/**
 取消关注
 */
- (void)httpRequestForCancelAttentionWithL_MyFollowersModeld:(L_MyFollowersModel *)model {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    //type: 0 新增 1 取消
    [L_NewMinePresenters addFollowWithUserid:model.userid type:1 UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [dataArray removeObject:model];
                [_tableView reloadData];
                [self showToastMsg:@"取消用户关注!" Duration:3.0];

            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
            if (dataArray.count == 0) {
                
                [self showNothingnessViewWithType:NoContentTypeAttentionFriends Msg:@"您最近没有新的关注" eventCallBack:nil];
                [self.view sendSubviewToBack:self.nothingnessView];
                
            }else {
                [self hiddenNothingnessView];
            }
            
        });
        
    }];
    
}

/**
 刷新数据
 */
- (void)refreshDataList {
    [_tableView.mj_header beginRefreshing];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_REFRESH_ATTENTION_DATA object:nil];
}
#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataList) name:NOTICE_REFRESH_ATTENTION_DATA object:nil];

    page = 1;
    pagesize = 20;
    dataArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, SCREEN_HEIGHT - (44+statuBar_Height) - 55 - 16 - 5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_PeopleListTVC" bundle:nil] forCellReuseIdentifier:@"L_PeopleListTVC"];
    
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForMyFollowsListsRefresh:YES];

    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForMyFollowsListsRefresh:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dataArray.count > 0) {
    
        L_PeopleListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_PeopleListTVC"];

        L_MyFollowersModel *model = dataArray[indexPath.row];
    
        cell.model = model;
    
        @WeakObj(self);
        cell.attentionButtonDidTouchBlock = ^() {
            
            NSLog(@"取消关注%ld",(long)indexPath.row);
            [selfWeak httpRequestForCancelAttentionWithL_MyFollowersModeld:model];
        };
    
        cell.headImageViewDidTouchBlock = ^() {
          
            NSLog(@"点击头像%ld,进入个人详情",(long)indexPath.row);
            
            if ([XYString isBlankString:model.userid]) {
                return;
            }
            
            //点赞头像点击
            personListViewController *personList = [[personListViewController alloc]init];
            [personList getuserID:model.userid];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personList animated:YES];
            
        };
        
        return cell;
        
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat leftWidth = 60;
    CGFloat rightWidth = 0;

    if (indexPath.row == dataArray.count - 1) {
        leftWidth  = _tableView.frame.size.width / 2.;
        rightWidth = _tableView.frame.size.width / 2.;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, leftWidth, 0, rightWidth)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, leftWidth, 0, rightWidth)];
    }
    
}


@end
