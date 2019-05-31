//
//  PersonalNoticeVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PersonalNoticeVC.h"
#import "PersonalNoticeCell.h"
#import "DateTimeUtils.h"
#import "ChatPresenter.h"

#import "WebViewVC.h"

#import "L_NormalDetailsViewController.h"
#import "L_HouseDetailsViewController.h"
#import "BBSQusetionViewController.h"

@interface  PersonalNoticeVC()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * table;
    NSInteger page;
    NSMutableArray *dataArray;
}
@end

@implementation PersonalNoticeVC
/**
 *  获得个人通知请求
 *
 *  @param refresh YES刷新 NO加载
 */
- (void)httpRequestForPersonNotice:(BOOL)refresh {
//    @WeakObj(self);

    [ChatPresenter getUserNotice:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if(resultCode == SucceedCode)
            {
                if (refresh) {
                    [table.mj_header endRefreshing];
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [table reloadData];
                }else {
                    if (((NSArray *)data).count == 0) {
                        page --;
                    }
                    [table.mj_footer endRefreshing];
                    
                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [table beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [table insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [table endUpdates];
                    
                }
                
            }
            else
            {
                if (refresh) {
                    [table.mj_header endRefreshing];
                    page = 1;
                }else {
                    [table.mj_footer endRefreshing];
                    page --;
                }
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            if (dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"当前无个人通知" eventCallBack:nil];
            }
            
            
        });
        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    page = 1;
    [self setUp];
    
//    [self httpRequestForPersonNotice:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [table.mj_header beginRefreshing];
}
- (void)setUp {
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.navigationItem.title = @"个人通知";
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    [table registerNib:[UINib nibWithNibName:@"PersonalNoticeCell" bundle:nil] forCellReuseIdentifier:@"PersonalNoticeCell"];
    
    @WeakObj(self);
    /**
     *  刷新
     */
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [selfWeak httpRequestForPersonNotice:YES];
    }];
    
    /**
     加载
     */
    table.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        page  = page + 1;
        [selfWeak httpRequestForPersonNotice:NO];
    }];
}
#pragma mark - 导航栏右侧按钮事件
-(void)rightAction:(id)sender
{
    /**
     *  清空群消息
     */
    @WeakObj(self);
    @WeakObj(table)
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    [ChatPresenter clearNotice:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                [dataArray removeAllObjects];
                [[NSUserDefaults standardUserDefaults] setObject:_userallcount forKey:@"userallcount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [tableWeak reloadData];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
            if (dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"当前无个人通知" eventCallBack:nil];
            }
            
        });
        
    }];

}

#pragma mark - tableviewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonalNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalNoticeCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserNoticeModel *model = dataArray[indexPath.row];
    cell.time_Label.text = [DateTimeUtils StringToDateTime:model.systime];
    if (model.type.intValue == 0) {
        cell.titleLb.text = @"系统通知";
        cell.rigntImage.image = [UIImage imageNamed:@"邻圈_消息_个人通知_系统通知"];

    }else if(model.type.integerValue == 1){
        cell.titleLb.text = @"社区通知";
        cell.rigntImage.image = [UIImage imageNamed:@"邻圈_消息_个人通知_社区通知"];
    }
    
    cell.titleLb.text   = model.title;
    cell.contentLb.text = model.content;
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserNoticeModel *model = dataArray[indexPath.row];
    return model.contentHeight+95;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserNoticeModel *model = dataArray[indexPath.row];

//    if (![XYString isBlankString:model.jsonDic[@"goodslogid"]]) {
//        /** 进入订单详情 */
//        [self gotoExchangeInfoWithID:model.jsonDic[@"goodslogid"]];
//        return;
//    }
    if (![XYString isBlankString:model.jsondata[@"goodslogid"]]) {
        
        if (![XYString isBlankString:model.jsondata[@"convertid"]]) {
            /** 进入订单详情 */
            [self gotoExchangeInfoWithID:model.jsondata[@"convertid"]];
        }
        
        return;
    }
    
    
    /** 跳转帖子详情 */
    if ([XYString isBlankString:model.posttype] || [XYString isBlankString:model.postid]) {
        return;
    }
    
    if (model.posttype.integerValue == 0) {//普通帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
        normalDetailVC.postID = model.postid;
        [self.navigationController pushViewController:normalDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 4) {//房产车位帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
        houseDetailVC.postID = model.postid;
        [self.navigationController pushViewController:houseDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 3) {//问答帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
        qusetion.postID = model.postid;
        [self.navigationController pushViewController:qusetion animated:YES];
        return;
    }
    
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
    
    webVc.title=@"商城";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

@end
