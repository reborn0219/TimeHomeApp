//
//  MessageViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 16/7/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MessageViewController.h"

#import "UITabBar+Badge.h"

#import "FriendViewController.h"

///vcs
#import "MyFansVC.h"
#import "BlacklistVC.h"
#import "SearchFriendsVC.h"
#import "ChatViewController.h" 
#import "MyGroupVC.h"
#import "GroupNoticeVC.h"
#import "PersonalNoticeVC.h"
#import "MyFollowVC.h"
#import "PersonalDataVC.h"
#import "ScreeningAlertVC.h"

#import "ChatPresenter.h"
#import "DateTimeUtils.h"
///views
#import "PersonnalBarView.h"
#import "Masonry.h"

///cells
#import "UnreadMessageCell.h"
#import "FriendsCell.h"
#import "DetailInfoCell.h"

///models
#import "Gam_Chat.h"
#import "Gam_UnreadMsg.h"
#import "DataOperation.h"
#import "XYString.h"
#import "ChatPresenter.h"
#import "RecentlyFriendModel.h"
#import "DateUitls.h"
#import "Gam_Chat.h"
#import "DateTimeUtils.h"
#import "PushMsgModel.h"
#import "THMyInfoPresenter.h"
#import "UserInfoModel.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger page;
    NSString * searchStr;
    NSString * searchTag;
    AppDelegate * appDelegate;
    NSArray * fetchController;
    UILabel * contentLb ;
    UIView * headerV;
    UILabel *timeLabel;
    UILabel *countLabel;
    /**
     *  个人通知
     */
    UserNoticeCountModel *noticeModel;
    NothingnessView * nothingV;
}

@end

@implementation MessageViewController

-(UIView *)createNothingView
{
    nothingV=[NothingnessView getInstanceView];
    nothingV.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    nothingV.centerH.constant = -50;
    nothingV.view_SubBg.hidden=YES;
    [nothingV.img_ErrorIcon setImage:[UIImage imageNamed:@"暂无数据"]];
    nothingV.lab_Clues.text = @"暂无附近邻友记录";
    return nothingV;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:NABAR_COLOR];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 70, 20)];
    
    [bt setImage:[UIImage imageNamed:@"邻圈_邻友uncheck"] forState:UIControlStateNormal];
    [bt setTitle:@"邻友" forState:UIControlStateNormal];
    [bt setTitleColor:RGBACOLOR(177, 177, 177, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [bt addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    bt.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    bt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    UIBarButtonItem *leftBarBt = [[UIBarButtonItem alloc]initWithCustomView:bt];
    
    self.navigationItem.leftBarButtonItem = leftBarBt;
    
    appDelegate = GetAppDelegates;
    
    self.tabBarController.navigationController.interactivePopGestureRecognizer.delegate = self;

    page = 1;
    
    [self creatTwoTable];
    
}

#pragma mark - left barbutton

-(void)left:(id)sender{
    
    //self.hidesBottomBarWhenPushed = YES;
    FriendViewController *friend = [[FriendViewController alloc]init];
    friend.Type = 2;
    friend.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friend animated:YES];
    
}

#pragma mark - creatTableView
-(void)creatTwoTable {
    
    self.msgTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20,SCREEN_HEIGHT-(44+statuBar_Height)-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    [self creatTableHeaderView];
    self.msgTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.msgTable.tag = 1000;
    self.msgTable.delegate =self;
    self.msgTable.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [self.msgTable setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    self.msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.msgTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.msgTable];
    [self.msgTable registerNib:[UINib nibWithNibName:@"UnreadMessageCell" bundle:nil] forCellReuseIdentifier:@"unreadCell"];
    
}
/**
 *  个人通知请求
 */
- (void)httpRequestForNoticeInfo {
    
    @WeakObj(self);
    [ChatPresenter getUserNoticeCount:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                noticeModel = (UserNoticeCountModel *)data;
                contentLb.text = noticeModel.usernotice;
                [selfWeak.nothingnessView setHidden:YES];
                if (![XYString isBlankString:noticeModel.userlasttime]) {
                    NSString *timeString = [DateTimeUtils StringToDateTimeWithTime:noticeModel.userlasttime];
                    timeLabel.text = timeString;
                }
                countLabel.text = [NSString stringWithFormat:@"%@",noticeModel.usercount];
                
                if (noticeModel.usercount.intValue > 0) {
                    countLabel.hidden = NO;
                    
                }else {
                    countLabel.hidden = YES;
                }
                

                    headerV.hidden = NO;
                    [self setBadges];
                    self.msgTable.tableHeaderView = headerV;
                
            }else {

                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
            [_msgTable reloadData];
            
        });
        
    }];
    
}

#pragma mark - HeaderView

-(void)creatTableHeaderView
{
    if (headerV==nil) {
        
        headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,80)];
        //更改--2016.6.07默认隐藏，待有数据再显示，防止闪现        headerV.hidden = YES;
        [headerV setBackgroundColor:[UIColor clearColor]];
        
        UIView *backW = [[UIView alloc]initWithFrame:CGRectMake(0, 10, headerV.frame.size.width, headerV.frame.size.height - 10)];
        [backW setBackgroundColor:[UIColor whiteColor]];
        [headerV addSubview:backW];
        
        UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(60,15, SCREEN_WIDTH, 21)];
        lb.text = @"个人通知";
        lb.font = [UIFont systemFontOfSize:15.0f];
        
        lb.textColor = TITLE_TEXT_COLOR;
        
        //        contentLb = [[UILabel alloc]initWithFrame:CGRectMake(60,36, SCREEN_WIDTH, 21)];
        contentLb = [[UILabel alloc]init];
        contentLb.textColor = TEXT_COLOR;
        contentLb.font = [UIFont systemFontOfSize:13.0f];
        
        //        contentLb.text = @"通知内容";
        //        if (![XYString isBlankString:noticeModel.usernotice]) {
        //            contentLb.text = noticeModel.usernotice;
        //        }
        
        [backW addSubview:contentLb];
        
        [backW addSubview:lb];
        UIImageView * btn = [[UIImageView alloc]initWithFrame:CGRectMake(15,20,30,30)];
        [btn setImage:[UIImage imageNamed:@"邻圈_消息_个人通知"]];
        [backW addSubview:btn];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTapAction:)];
        [backW addGestureRecognizer:tap];
        timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = TEXT_COLOR;
        timeLabel.textAlignment = NSTextAlignmentRight;
        [backW addSubview:timeLabel];
        if (![XYString isBlankString:noticeModel.userlasttime]) {
            NSString *timeString = [DateTimeUtils StringToDateTimeWithTime:noticeModel.userlasttime];
            timeLabel.text = timeString;
        }
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerV).offset(-20);
            make.height.equalTo(@20);
            make.top.equalTo(lb.mas_top);
        }];
        countLabel = [[UILabel alloc]init];
        countLabel.hidden = YES;
        countLabel.font = [UIFont systemFontOfSize:14];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.backgroundColor = PURPLE_COLOR;
        countLabel.textAlignment = NSTextAlignmentCenter;
        [backW addSubview:countLabel];
        countLabel.sd_layout.rightEqualToView(timeLabel).topSpaceToView(timeLabel,1).widthIs(20).heightEqualToWidth();
        [countLabel setSd_cornerRadiusFromWidthRatio:@0.5];
        
        
        countLabel.text = [NSString stringWithFormat:@"%@",noticeModel.usercount];
        
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(btn.mas_right).offset(15);
            make.top.equalTo(lb.mas_bottom).offset(1);
            make.height.equalTo(@20);
            make.right.equalTo(headerV).offset(-60);
            
        }];
        
        if (noticeModel.usercount.intValue > 0) {
            countLabel.hidden = NO;
        }
        headerV.hidden = YES;
    }
}
-(void)headTapAction:(UIGestureRecognizer *)gest
{
    
    PushMsgModel * pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.PersonalMsg];
    pushMsg.countMsg = @0;
    [UserDefaultsStorage saveData:pushMsg forKey:appDelegate.PersonalMsg];
    
    PersonalNoticeVC *pnVC  = [[PersonalNoticeVC alloc]init];
    pnVC.userallcount = noticeModel.userallcount;
    [self.navigationController pushViewController:pnVC animated:YES];
}
#pragma mark - 请求第一页数据
-(void)loadone
{
    page = 1;
        
    //[self httpRequestForNoticeInfo];

    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
    [self.msgTable.mj_header endRefreshing];
    [self.msgTable reloadData];
    [self.msgTable setHidden:NO];

}
#pragma mark - 加载更多
-(void)loadmore
{
    page ++;
        
    [self.msgTable  setHidden:NO];
}


#pragma mark - 初始化headerView

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([ self.tabBarController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.tabBarController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    // 开启
    if ([self.tabBarController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.tabBarController.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"xiaoxi"];
    
    self.hidesBottomBarWhenPushed = NO;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self httpRequestForNoticeInfo];
    
    //[self setBadges];
    
    [self loadone];
}

-(void)viewWillDisappear:(BOOL)animated{
    
//    [TalkingData trackPageEnd:@"xiaoxi"];
}

#pragma mark - tableviewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag ==1000) {
        
        UnreadMessageCell * cell = [self.msgTable dequeueReusableCellWithIdentifier:@"unreadCell"];
        [cell becomeFirstResponder];
        
        Gam_Chat *GUM;
        if (indexPath.section<fetchController.count) {
            
            GUM = [fetchController objectAtIndex:indexPath.section];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (GUM.countMsg.integerValue >0) {
                [cell.unreadV setHidden:NO];
                cell.unreadLb.text = [NSString stringWithFormat:@"%ld",(long)GUM.countMsg.integerValue];
            }else
            {
                [cell.unreadV setHidden:YES];
                
            }
            
            //NSLog(@"name==%@   count===%ld   userid==%@",GUM.sendName,(long)GUM.countMsg.integerValue-1,GUM.sendID);
            NSString *timeString = [XYString NSDateToString:GUM.systime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            cell.timeLb.text = [DateTimeUtils StringToDateTimeWithTime:timeString];
            
            cell.nameLb.text = GUM.sendName;
            cell.contentLb.text = GUM.content;
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:GUM.headPicUrl] placeholderImage:kHeaderPlaceHolder];
            
        }
        
        return cell;
    }
    
    return [UITableViewCell new];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [fetchController count];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 5;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Gam_Chat * GC = [fetchController objectAtIndex:indexPath.section];
        [[DataOperation sharedDataOperation]deleteDataWithChatID:GC.chatID];
        [self loadone];
        
        //[self setBadges];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.3;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView new];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Gam_Chat *GUM = [fetchController objectAtIndex:indexPath.section];
    
    @WeakObj(self);
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    [THMyInfoPresenter getOneUserInfoUserID:GUM.chatID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                
                UserInfoModel* UIML_P = data;
                if (UIML_P.isblack.boolValue) {
                    [selfWeak showToastMsg:@"请先将该用户移除黑名单！" Duration:3.0f];
                }else
                {
                    
//                    PushMsgModel * pushMsg2;
//                    ///聊天消息通知
//                    pushMsg2=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.ChatMsg];
//                    int tmp2=pushMsg2.countMsg.intValue;
//                    
//                    Gam_Chat *GUM;
//                    if (indexPath.section<fetchController.count) {
//                        
//                        GUM = [fetchController objectAtIndex:indexPath.section];
//                        if (GUM.countMsg.integerValue >0) {
//
//                            int count = GUM.countMsg.intValue;
//                            if(tmp2 >= count){
//                                
//                                pushMsg2.countMsg=[[NSNumber alloc]initWithInt:tmp2 - count];
//                                [UserDefaultsStorage saveData:pushMsg2 forKey:appDelegate.ChatMsg];
//                            }
//                        }
//                    }
                    
                    ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
                    self.hidesBottomBarWhenPushed = YES;
                    //chatC.navigationItem.title = GUM.sendName;
                    chatC.ReceiveID = GUM.chatID;
                    //chatC.chatterThumb = GUM.headPicUrl;
                    [selfWeak.navigationController pushViewController:chatC animated:YES];
                    
                }
                
            }else{
                
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
        });
        
    }];
}

#pragma mark - headerViewAction
-(void)headerTapGestAction:(UIGestureRecognizer *)gestInfo
{
    ///搜索好友
    SearchFriendsVC * blVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"SearchFriendsVC"];
    
    [self.navigationController pushViewController:blVC animated:YES];
    
}
#pragma mark - screeningAction
-(void)screening:(UIButton *)btn
{
    @WeakObj(self)
    [[ScreeningAlertVC shareScreeningVC]showInVC:self];
    [[ScreeningAlertVC shareScreeningVC]setFirstSelected:searchTag.integerValue];
    [ScreeningAlertVC shareScreeningVC].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index == 1000) {
            searchStr = @"全部";
            searchTag = @"0";
        }else if(index ==1001)
        {
            searchStr = @"男生";
            searchTag = @"1";
            
        }else if(index ==1002)
        {
            searchStr = @"女生";
            searchTag = @"2";
        }
        
        [selfWeak loadone];
    };
}
-(void)setBadges
{
    AppDelegate *appDlgt = GetAppDelegates;
    PushMsgModel * pushMsg1;
    ///个人通知
    pushMsg1=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
    if (pushMsg1==nil) {
        pushMsg1=[PushMsgModel new];
        pushMsg1.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    
    NSInteger tmp1=pushMsg1.countMsg.integerValue;
    NSInteger tmp=[noticeModel.usercount integerValue];
        
    tmp1 = tmp;
    pushMsg1.countMsg=[[NSNumber alloc]initWithInteger:tmp1];
    pushMsg1.content=@"";
    [UserDefaultsStorage saveData:pushMsg1 forKey:appDelegate.PersonalMsg];
    
    PushMsgModel * pushMsg2;
    ///消息通知
    pushMsg2=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.ChatMsg];
    if (pushMsg2==nil) {
        pushMsg2=[PushMsgModel new];
        pushMsg2.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    
    [self.msgTable.mj_header beginRefreshing];
    
    NSInteger rowCount=0;
    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
    
    Gam_Chat * GCT;
    for(NSInteger i=0;i<fetchController.count;i++)
    {
        GCT=[fetchController objectAtIndex:i];
    
        rowCount+=GCT.countMsg.integerValue;
    }
    
    if (pushMsg1!=nil || pushMsg2!=nil) {
        if(tmp1>0 || rowCount>0)
        {
            pushMsg2.countMsg=[[NSNumber alloc]initWithInt:(int)rowCount];
            [UserDefaultsStorage saveData:pushMsg2 forKey:appDelegate.ChatMsg];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",tmp1 + rowCount];
        }else{

            pushMsg1.countMsg=[[NSNumber alloc]initWithInt:0];
            pushMsg1.content=@"";
            [UserDefaultsStorage saveData:pushMsg1 forKey:appDelegate.PersonalMsg];
            pushMsg2.countMsg=[[NSNumber alloc]initWithInt:0];
            pushMsg2.content=@"";
            [UserDefaultsStorage saveData:pushMsg2 forKey:appDelegate.ChatMsg];
            self.navigationController.tabBarItem.badgeValue = nil;
        }
    }
    //pushMsg.countMsg
    
}
#pragma mark - 接收消息
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [super subReceivePushMessages:aNotification];
    
    [self httpRequestForNoticeInfo];
    
}

@end
