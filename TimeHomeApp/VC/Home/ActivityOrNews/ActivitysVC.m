//
//  ActivitysVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ActivitysVC.h"
#import "TableViewDataSource.h"
#import "ActivitysTableViewCell.h"
#import "HDActivityPresenter.h"
#import "UserActivity.h"
#import "WebViewVC.h"
#import "THMyActivityListTVCStyle1.h"


@interface ActivitysVC ()<UITableViewDelegate,UITableViewDataSource>
{
    ///活动数据
    NSMutableArray * actArray;
     NSInteger page;
}
/**
 *  列表显示
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActivitysVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
//    [self.tableView triggerPullToRefresh];
    [_tableView.mj_header beginRefreshing];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.tableView triggerPullToRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tableView triggerPullToRefresh];
    //[TalkingData trackPageBegin:@"huodong"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[TalkingData trackPageEnd:@"huodong"];
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    
    self.tableView.sd_resetLayout.leftSpaceToView(self.view,7).rightSpaceToView(self.view,7).topEqualToView(self.view).heightIs(SCREEN_HEIGHT-(44+statuBar_Height));
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"ActivitysTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivitysTableViewCell"];
    [self.tableView registerClass:[THMyActivityListTVCStyle1 class] forCellReuseIdentifier:@"THMyActivityListTVCStyle1"];
    //    self.tableView.allowsSelection = NO;//列表不可选择

    actArray=[NSMutableArray new];
    self.tableView.dataSource=self;
    [self setExtraCellLineHidden:self.tableView];
    
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak topRefresh];
    }];

    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak loadmore];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];

}

///下拉刷新数据
-(void)topRefresh
{
    page=1;
    [self getData:[NSString stringWithFormat:@"%ld",(long)page]];
}
///上拉加载更多
-(void)loadmore
{
    page++;
    [self getData:[NSString stringWithFormat:@"%ld",(long)page]];
}




#pragma mark ----------关于列表数据及协议处理--------------

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return actArray.count;
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
    
    UserActivity *model = actArray[indexPath.section];
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"userActivity" cellClass:[THMyActivityListTVCStyle1 class] contentViewWidth:[self cellContentViewWith]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
 
    cell = [tableView dequeueReusableCellWithIdentifier:@"THMyActivityListTVCStyle1" forIndexPath:indexPath];
    
    UserActivity *model = actArray[indexPath.section];
    [self setData:model withCell:cell withIndexPath:indexPath];
    
    return cell;
}

/**
 *  设置隐藏列表分割线
 *
 *  @param tableView tableView description
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  设置列表数据
 *
 *  @param data      <#data description#>
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    UserActivity * userAct=(UserActivity *)data;
    THMyActivityListTVCStyle1 *ATCell=cell;
    ATCell.userActivity=userAct;

    
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UserActivity * userAct = [actArray objectAtIndex:indexPath.section];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    AppDelegate *appDlgt=GetAppDelegates;
    
    NSLog(@"%@",userAct.gotourl);
    
    if([userAct.gotourl hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",userAct.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",userAct.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    webVc.type = 5;
    webVc.shareTypes = 5;
    webVc.userActivityModel = [userAct copy];
    if (![XYString isBlankString:userAct.title]) {
        webVc.title = userAct.title;
    }else {
        webVc.title = @"活动详情";
    }
    webVc.isGetCurrentTitle = YES;
    webVc.talkingName = @"shequhuodong";

    [self.navigationController pushViewController:webVc animated:YES];
    
}



#pragma mark ------------------网络-----------------

///获取通知数据
-(void)getData:(NSString *)pageStr
{
    [HDActivityPresenter getActivitingListFor:pageStr updataBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if(resultCode==SucceedCode)
            {
                if(page>1)
                {
//                    [self.tableView.infiniteScrollingView stopAnimating];
                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=actArray.count;
                    [actArray addObjectsFromArray:tmparr];
                    
                    [self.tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                }
                else
                {
//                    [self.tableView.pullToRefreshView stopAnimating];
                    [actArray removeAllObjects];
                    [actArray addObjectsFromArray:data];
                    [self.tableView reloadData];
                    
                }
            }
            else if(resultCode==FailureCode)
            {
                if(data==nil||![data isKindOfClass:[NSDictionary class]])
                {
                    return ;
                }
                
                NSDictionary *dicJson=(NSDictionary *)data;
                NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
//                NSString * errmsg=[dicJson objectForKey:@"errmsg"];
                
                if(page>1)
                {
                    page--;
//                    [self.tableView.infiniteScrollingView stopAnimating];
//                    [self showToastMsg:errmsg Duration:5.0];
                }
                else{
//                    [self.tableView.pullToRefreshView stopAnimating];
//                    [self showToastMsg:errmsg Duration:5.0];
                    
                    
                    if(errcode==99999)
                    {
                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"物业没有发布新的活动" eventCallBack:nil];

                        return ;
                    }
                    
                }
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                if(page>1)
                {
                    page--;
                }
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];

                
            }
        });
    }];

}


@end
