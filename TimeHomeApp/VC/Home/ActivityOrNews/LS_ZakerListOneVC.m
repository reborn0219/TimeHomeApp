//
//  LS_ZakerListOneVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_ZakerListOneVC.h"
#import "LS_ZakerCell.h"
#import "NewsPresenter.h"
#import "DateUitls.h"
#import "WebViewVC.h"

@interface LS_ZakerListOneVC ()<UITableViewDelegate,UITableViewDataSource>
{
    //数据源
    NSMutableArray * zakerArr;
    //页码
    NSString * page;
    //当前所在频道
    NSString * currentChannel;
}
@end

@implementation LS_ZakerListOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    zakerArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.nothingnessView setHidden:YES];
    [self.view addSubview:self.table];
}
#pragma mark - 初始化UI

#pragma mark - 请求频道新闻数据

-(void)requestData:(NSString *)Channel
{
    
    if (self.nothingnessView != nil) {
        
        
        if (![XYString isBlankString:currentChannel]&&self.nothingnessView.hidden) {
            return;
        }else
        {
            currentChannel = Channel;
        }
        
    }else{
        
        if (![XYString isBlankString:currentChannel]) {
            return;
        }else
        {
            currentChannel = Channel;
        }
    }
    
    
    @WeakObj(self);
    [NewsPresenter getZakerChannelinfo:Channel andPage:@"1" withBlock:^(id  _Nullable data, ResultCode resultCode) {
     
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                [selfWeak.table setHidden:NO];
                [selfWeak.nothingnessView setHidden:YES];
                [zakerArr removeAllObjects];
                [zakerArr addObjectsFromArray:data];
                
                [selfWeak.table reloadData];
            }else
            {
                
                
                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据！" eventCallBack:nil];
                
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                [selfWeak.table setHidden:YES];
                [selfWeak.nothingnessView setHidden:NO];
                    
                
            }
            
        });
    }];
    
}
#pragma mark - 刷新加载数据
-(void)refreshData
{
    
    @WeakObj(self);
    [NewsPresenter getZakerChannelinfo:currentChannel andPage:page withBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.table.mj_header endRefreshing];
            [selfWeak.table.mj_footer endRefreshing];
            if (resultCode == SucceedCode) {
                [selfWeak.table setHidden:NO];
                [selfWeak.nothingnessView setHidden:YES];
                if (page.integerValue == 1) {
                    
                    [zakerArr removeAllObjects];
                    [zakerArr addObjectsFromArray:data];
                    [selfWeak.table reloadData];
                    
                }else
                {
                    NSArray * dataarr = data;
                    if (dataarr.count==0 || data==nil) {
                        page = [NSString stringWithFormat:@"%ld",page.integerValue-1>0?1:(page.integerValue-1)];
                        
                    }
                    [zakerArr addObjectsFromArray:data];
                    [selfWeak.table reloadData];
                }
               
                
                
            }else
            {
                
                if (page.integerValue==1) {
                
                    [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据！" eventCallBack:nil];
                    
                    [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                    [selfWeak.table setHidden:YES];
                    [selfWeak.nothingnessView setHidden:NO];
                    
                }
                
            }
            
        });
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化tableview
-(UITableView *)table
{
    if (_table==nil) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        [_table registerNib:[UINib nibWithNibName:@"LS_ZakerCell" bundle:nil] forCellReuseIdentifier:@"LS_ZakerCell"];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate =self;
        _table.dataSource =self;
        @WeakObj(self);
        _table.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
            page = @"1";
            [selfWeak refreshData];
        }];
        
        _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page = [NSString stringWithFormat:@"%ld",(page.integerValue+1)];
            [selfWeak refreshData];
        }];
        
        [_table.mj_footer setAutomaticallyHidden:YES];
        
    }
    return _table;
}
#pragma mark - TableViewDelegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    author = "汽车头条",
//    thumbnailpic = "https://zkres4.myzaker.com/201801/5a548fe21bc8e0e33d000005_1024.jpg",
//    infourl = "https://app.myzaker.com/news/article.php?pk=5a548fe31bc8e0e33d000008&f=pingan_community",
//    title = "喜忧参半！福特去年在华同比下降，林肯暴涨",
//    date = "2018-01-09 17:31:30"
    NSDictionary * dic = [zakerArr objectAtIndex:indexPath.row];
//    newsUrl=[newsDic objectForKey:@"gotourl"];
    //[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:[newDict objectForKey:@"date"]]]
    LS_ZakerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LS_ZakerCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLb.text = [dic objectForKey:@"title"];
    NSString * dateStr = [DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:[dic objectForKey:@"date"]]];
    
    cell.timeLb.text = [NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"author"],dateStr];
    NSString * picStr = [dic objectForKey:@"thumbnailpic"];

    if(![XYString isBlankString:picStr])
    {
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"默认图"]];
    }else
    {
        [cell.imgV setImage:[UIImage imageNamed:@"默认图"]];
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return zakerArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    return v;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSDictionary * dic = [zakerArr objectAtIndex:indexPath.row];
        NSString * newsUrl =[dic objectForKey:@"infourl"];
        AppDelegate * appDlgt = GetAppDelegates;
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
        webVc.type = 10;
        webVc.isnoHaveQQ = 1;
        if([newsUrl hasSuffix:@".html"])
        {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@",newsUrl,appDlgt.userData.token];
        }
        else
        {
            webVc.url=[NSString stringWithFormat:@"%@&token=%@",newsUrl,appDlgt.userData.token];
        }
//        webVc.title=@"社区新闻";
        webVc.isShowRightBtn = YES;
        webVc.isGetCurrentTitle = YES;
        webVc.hidesBottomBarWhenPushed = YES;
    
    
        UserActivity *userActivityModel = [[UserActivity alloc] init];
        userActivityModel.title = [XYString IsNotNull:dic[@"title"]];
        userActivityModel.content = @"点击查看全部内容";
        userActivityModel.gotourl = [XYString IsNotNull:[NSString stringWithFormat:@"%@",dic[@"infourl"]]];
        userActivityModel.picurl = [XYString isBlankString:dic[@"thumbnailpic"]] ? SHARE_LOGO_IMAGE : [NSString stringWithFormat:@"%@",dic[@"thumbnailpic"]];
        webVc.userActivityModel = userActivityModel;

        [self.navigationController pushViewController:webVc animated:YES];

}
@end
