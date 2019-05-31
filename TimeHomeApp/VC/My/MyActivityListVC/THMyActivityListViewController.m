//
//  THMyActivityListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyActivityListViewController.h"
#import "THMyActivityListTVC.h"
#import "THMyActivityListTVC2.h"
#import "THMyActivityListTVCStyle1.h"
#import "AppSystemSetPresenters.h"
/**
 *  网络请求
 */
#import "HDActivityPresenter.h"

#import "ActivitysVC.h"

#import "WebViewVC.h"

@interface THMyActivityListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  数据
     */
    NSMutableArray *dataArray;
    NSInteger page;
    /**
     *  当前日期
     */
    NSString *currentDate;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMyActivityListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [_tableView triggerPullToRefresh];
    
    [_tableView.mj_header beginRefreshing];
    
//    [TalkingData trackPageBegin:@"huodong"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:HuoDong];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"huodong"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":HuoDong}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的活动";
    
    page = 1;
    dataArray = [[NSMutableArray alloc]init];

    [self createTableView];

}

/**
 *  我的活动列表请求
 */
- (void)httpRequestPullToRefreshOrNot:(BOOL)refresh {
    
    if (refresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    @WeakObj(self);

    [HDActivityPresenter getActivitingListPage:page WithBlock:^(id  _Nullable data, ResultCode resultCode) {
        
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
//                    [selfWeak.tableView.pullToRefreshView stopAnimating];

                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                    
                }else {
                    if (((NSArray *)data).count == 0) {
                        page --;
                    }
//                    [selfWeak.tableView.infiniteScrollingView stopAnimating];

                    NSArray * tmparr = (NSArray *)data;
                    NSInteger count = dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [selfWeak.tableView beginUpdates];
                    for (int i = 0; i < tmparr.count; i++) {
                        [selfWeak.tableView insertSections:[NSIndexSet indexSetWithIndex:count + i] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    [selfWeak.tableView endUpdates];
                    
                }
                _tableView.hidden = NO;

            }
            else
            {
                if (refresh) {
//                    [selfWeak.tableView.pullToRefreshView stopAnimating];
                    page = 1;
                }else {
//                    [selfWeak.tableView.infiniteScrollingView stopAnimating];
                    page --;
                }
            }
            if (dataArray.count == 0) {
                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"您没有参加过社区活动" SubMsg:@"去看看现在社区都有哪些活动吧" btnTitle:@"社区活动" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    //社区活动
                    if (index == 1) {
                        return ;
                    }
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ActivityNews" bundle:nil];
                    ActivitysVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"ActivitysVC"];
                    [selfWeak.navigationController pushViewController:pmvc animated:YES];
                    
                }];

                selfWeak.nothingnessView.btn_Go.backgroundColor = kNewRedColor;
                _tableView.hidden = YES;
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
            }
            
            
        });
        
    }];
    
    
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THMyActivityListTVCStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyActivityListTVCStyle1 class])];

    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestPullToRefreshOrNot:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestPullToRefreshOrNot:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserActivity *model = dataArray[indexPath.section];
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"userActivity" cellClass:[THMyActivityListTVCStyle1 class] contentViewWidth:[self cellContentViewWith]];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THMyActivityListTVCStyle1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMyActivityListTVCStyle1 class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (dataArray.count > 0) {
        
        UserActivity *model = dataArray[indexPath.section];
        cell.userActivity = model;
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UserActivity *model2 = dataArray[indexPath.section];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    AppDelegate *appDlgt=GetAppDelegates;
    
    if([model2.gotourl hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",model2.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",model2.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    webVc.type = 5;
    webVc.shareTypes = 5;
    webVc.userActivityModel = model2;
    if (![XYString isBlankString:model2.title]) {
        webVc.title = model2.title;
    }else {
        webVc.title = @"活动详情";
    }
    webVc.isGetCurrentTitle = YES;
    webVc.talkingName = @"shequhuodong";

    [self.navigationController pushViewController:webVc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = SCREEN_WIDTH/2-7;
    
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
