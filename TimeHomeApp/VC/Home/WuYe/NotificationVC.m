//
//  NotificationVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NotificationVC.h"
#import "TableViewDataSource.h"
#import "NotificationCell.h"
#import "NotificationDetailVC.h"
#import "CommunityManagerPresenters.h"
#import "NewsVC.h"
#import "WebViewVC.h"
#import "DateUitls.h"
#import "UserDefaultsStorage.h"
#import "PushMsgModel.h"

@interface NotificationVC ()
{
    /**
     *  列表数据源
     */
    TableViewDataSource * dataSource;
    NSMutableArray * noticArray;
    NSInteger page;
    NSMutableArray *pushMsgArray;
}
/**
 *  通知列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"shequgonggao"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:SheQuGongGao];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"shequgonggao"];
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":SheQuGongGao}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self topRefresh];
    
//    [self.tableView.mj_header beginRefreshing];

}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:@"NotificationCell"];
//    self.tableView.allowsSelection = NO;//列表不可选择
    /**
     *  测试数据
     */
    noticArray=[NSMutableArray new];
    
    @WeakObj(self);
    dataSource=[[TableViewDataSource alloc]initWithItems:noticArray cellIdentifier:@"NotificationCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
    }];
    dataSource.isSection=NO;
    self.tableView.dataSource=dataSource;
    [self setExtraCellLineHidden:self.tableView];

    self.tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak topRefresh];

    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak loadmore];

    }];
    
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
    
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
    NotificationCell * nCell=(NotificationCell *)cell;
    NSDictionary * dic=(NSDictionary *)data;
    nCell.img_Icon.contentMode=UIViewContentModeCenter;
    if ([[dic objectForKey:@"isread"] integerValue]==0) {
        
        [nCell.img_Icon setImage:[UIImage imageNamed:@"社区公告_公告_有通知"]];
        nCell.lab_Title.textColor=UIColorFromRGB(0x595353);
    }
    else
    {
        [nCell.img_Icon setImage:[UIImage imageNamed:@"社区公告_公告"]];
        nCell.lab_Title.textColor=UIColorFromRGB(0xa7a7a7);
    }
    nCell.lab_Title.text=[dic objectForKey:@"title"];
    nCell.lab_Content.text=[dic objectForKey:@"content"];
    nCell.lab_Content.font=DEFAULT_FONT(13);
    nCell.lab_Date.text=[DateUitls formatDateForDayHHMM:[dic objectForKey:@"systime"]];
    nCell.lab_Date.font=DEFAULT_FONT(12);
}
/**
 *  设置列表高度
 *
 *  @param tableView tableView description
 *  @param indexPath indexPath description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * noticData=[noticArray objectAtIndex:indexPath.row];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    AppDelegate *appDlgt=GetAppDelegates;
    if([[noticData objectForKey:@"gotourl"] hasSuffix:@".html"]) {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@",[noticData objectForKey:@"gotourl"],appDlgt.userData.token];
    } else {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@",[noticData objectForKey:@"gotourl"],appDlgt.userData.token];
    }
    webVc.shareUr = [noticData objectForKey:@"gotourl"];
    
    webVc.noticeTitle = [noticData objectForKey:@"title"];
    webVc.noticeContent = [noticData objectForKey:@"content"];
    
    webVc.type = 3;
    
    UserActivity *userActivityModel = [[UserActivity alloc] init];
    userActivityModel.title = [XYString IsNotNull:[noticData objectForKey:@"title"]];
    userActivityModel.content = [XYString IsNotNull:[noticData objectForKey:@"content"]];
    userActivityModel.gotourl = [XYString IsNotNull:[noticData objectForKey:@"gotourl"]];
    webVc.userActivityModel = userActivityModel;
    
    webVc.isShowRightBtn=YES;
    webVc.title = @"公告详情";
    webVc.talkingName = SheQuGongGao;
    webVc.shareTypes=1;
    [self.navigationController pushViewController:webVc animated:YES];
    
    if([[noticData objectForKey:@"isread"] integerValue]==0)
    {
        [CommunityManagerPresenters readNoticeID:[noticData objectForKey:@"id"] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultCode==SucceedCode) {}
                else if(resultCode==FailureCode) {}
                else if(resultCode==NONetWorkCode)//无网络处理
                {}
                
            });
            
        }];
        
    }


}



#pragma mark ------------------网络-----------------

///获取通知数据
-(void)getData:(NSString *)pageStr
{
    [CommunityManagerPresenters getPropertyNoticePage:pageStr UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
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
                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=noticArray.count;
                    [noticArray addObjectsFromArray:tmparr];
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
                    [noticArray removeAllObjects];
                    [noticArray addObjectsFromArray:data];
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
                }
                else{
                    
                    if(errcode==99999)
                    {

                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"物业没有发布新的公告哦!" eventCallBack:nil];

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
