//
//  AlertsListVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AlertsListVC.h"
#import "MessageCell.h"
#import "MessageCell_Del.h"
#import "PostPresenter.h"
#import "DateTimeUtils.h"
#import "WebViewVC.h"

@interface AlertsListVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * table;
    NSMutableArray *dataArray;
}
@end

@implementation AlertsListVC
/**
 *  消息请求
 *
 *  @param refresh YES刷新 NO加载
 */
- (void)htttpRequestForMessages {
    @WeakObj(self);
    THIndicatorVC * indicator1 = [THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator1 startAnimating:self.tabBarController];
    [PostPresenter getMsg:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator1 stopAnimating];
            if(resultCode == SucceedCode)
            {
                [dataArray removeAllObjects];
//                UserMsgModel * UMML = [[UserMsgModel alloc]init];
//                UMML.msgtype = @"1";
//                UMML.cellHight = 120;
//                UMML.msgcontent = @"14456465456456456456456456456456465456456456456456456456456456456456456456465465465564564564654";
//                [dataArray addObject:UMML];
                
                [dataArray addObjectsFromArray:data];
                [table reloadData];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
            if (dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"当前暂无消息" eventCallBack:nil];
            }
            
        });
        
    } withType:@"0"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    [self setUp];

    [self htttpRequestForMessages];
}
- (void)setUp {
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    
    [table registerNib:[UINib nibWithNibName:@"MessageCell_Del" bundle:nil] forCellReuseIdentifier:@"MessageCell_Del"];

    self.navigationItem.title = @"消息";
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark - tableviewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    MessageCell_Del * cell_del = [tableView dequeueReusableCellWithIdentifier:@"MessageCell_Del"];
    UserMsgModel *model = dataArray[indexPath.row];
    if(model.msgtype.integerValue==3)
    {
        cell_del.titleLb.text = model.nickname;
        cell_del.contentLb.text = model.msgcontent;
        return cell_del;
        
    }else
    {
        
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:PLACEHOLDER_IMAGE];
        cell.titleLb.text    = model.nickname;
        cell.contentLb.text  = model.msgcontent;
        NSLog(@"%@",model.msgcontent);
        NSLog(@"-------%@",model.postscontent);
        NSString *timeString = [DateTimeUtils StringToDateTimeWithTime:model.systime];
        cell.timeLb.text     = timeString;
        cell.contentLb_R.text = model.postscontent;
        [cell.zanImg setHidden:YES];
        [cell.contentLb setHidden:YES];
        if (model.msgtype.integerValue == 1) {
            [cell.contentLb setHidden:NO];
        }else if (model.msgtype.integerValue == 2)
        {
            [cell.zanImg setHidden:NO];
        }
        
        if (![XYString isBlankString:model.postspic]) {
            [cell.contentImgV setHidden:NO];
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:model.postspic] placeholderImage:PLACEHOLDER_IMAGE];
            [cell.contentLb_R setHidden:YES];
        }else {
            [cell.contentImgV setHidden:YES];
            [cell.contentLb_R setHidden:NO];
        }
        
        return cell;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserMsgModel *model = dataArray[indexPath.row];
    
    if (model.msgtype.integerValue == 1) {
        
        return model.cellHight + 80;

    }else if (model.msgtype.integerValue == 2)
    {
        return 80;
        
    }else if(model.msgtype.integerValue == 3)
    {
        
        CGFloat f = [XYString HeightForText:model.msgcontent withSizeOfLabelFont:12.0f withWidthOfContent:SCREEN_WIDTH-30];

        return 70 + f;
    }
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserMsgModel *model = dataArray[indexPath.row];

    if(model.msgtype.integerValue==3)
    {
        return;
    }
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    AppDelegate *appDlgt=GetAppDelegates;
    if([model.postsgotourl hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@",model.postsgotourl,appDlgt.userData.token];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@",model.postsgotourl,appDlgt.userData.token];
    }
    webVc.type = 10;
    webVc.postsid = model.postsid;

    [self.navigationController pushViewController:webVc animated:YES];
    
}
@end


