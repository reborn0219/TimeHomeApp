//
//  ChatMessageMainVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ChatMessageMainVC.h"
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

@interface ChatMessageMainVC ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    PersonnalBarView *barV;
    NSInteger page;
    NSMutableArray *friendArr;
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

@implementation ChatMessageMainVC
@synthesize Type;
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
    appDelegate = GetAppDelegates;
    friendArr =[[NSMutableArray alloc]initWithCapacity:0];

    self.tabBarController.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    if(appDelegate.userData.sex.integerValue==1)
    {
        searchStr = @"女生";
        searchTag = @"2";

    }else if(appDelegate.userData.sex.integerValue==2)
    {
        searchStr = @"男生";
        searchTag = @"1";

    }else
    {
        searchStr = @"全部";
        searchTag = @"0";

    }
       page = 1;

    [self creatTwoTable];
    
    barV = [[[NSBundle mainBundle]loadNibNamed:@"PersonnalBarView" owner:self options:nil] lastObject];
    [self.view addSubview:barV];
    
    [barV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right .equalTo(self.view.mas_right).offset(0);
        make.left  .equalTo(self.view.mas_left).offset(0);
    }];
    
    @WeakObj(self)
    @WeakObj(barV)
    barV.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        [selfWeak.nothingnessView setHidden:YES];

        if (index==1000) {
            ///消息
            [selfWeak.friendTable setHidden:YES];
            selfWeak.Type = 1;
            selfWeak.navigationItem.title = @"消息";
            [barVWeak.focusBtn setImage:[UIImage imageNamed:@"邻圈_消息selected"] forState:UIControlStateNormal];
            [barVWeak.chatBtn setImage:[UIImage imageNamed:@"邻圈_邻友uncheck"] forState:UIControlStateNormal];
            [barVWeak.leftLb setTextColor:UIColorFromRGB(0x9F111C)];
            [barVWeak.rightLb setTextColor:UIColorFromRGB(0x8e8e8e)];
            [selfWeak loadone];
            
        }else
        {
            ///邻友
            [selfWeak.msgTable setHidden:YES];

            selfWeak.Type = 2;
            selfWeak.navigationItem.title = @"邻友";
            [barVWeak.focusBtn setImage:[UIImage imageNamed:@"邻圈_消息uncheck"] forState:UIControlStateNormal];
            [barVWeak.chatBtn setImage:[UIImage imageNamed:@"邻圈_邻友selected"] forState:UIControlStateNormal];
            [barVWeak.leftLb setTextColor:UIColorFromRGB(0x8e8e8e)];
            [barVWeak.rightLb setTextColor:UIColorFromRGB(0x9F111C)];
            [selfWeak loadone];

        }
    };
    
    
}
#pragma mark - creatTableView
-(void)creatTwoTable
{
    @WeakObj(self)
    self.friendTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    self.friendTable.tag = 1001;
    self.friendTable.delegate =self;
    self.friendTable.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [self.friendTable setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    self.friendTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendTable.tableFooterView = [self createNothingView];
    
    [self.view addSubview:self.friendTable];
    
    [self.friendTable registerNib:[UINib nibWithNibName:@"DetailInfoCell" bundle:nil] forCellReuseIdentifier:@"DetailInfoCell"];
    [self.friendTable registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
    self.friendTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadone];
    }];

    self.friendTable.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadmore];
    }];
    [self.friendTable setHidden:YES];

    
    self.msgTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20,SCREEN_HEIGHT-(44+statuBar_Height)-50) style:UITableViewStyleGrouped];
    self.msgTable.tableHeaderView = [self creatTableHeaderView];
    self.msgTable.tag = 1000;

    self.msgTable.delegate =self;
    self.msgTable.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [self.msgTable setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    self.msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.msgTable];
    [self.msgTable registerNib:[UINib nibWithNibName:@"UnreadMessageCell" bundle:nil] forCellReuseIdentifier:@"unreadCell"];
    
//    [self.msgTable addPullToRefreshWithActionHandler:^{
//        [selfWeak loadone];
//    } ];
    
}
/**
 *  个人通知请求
 */
- (void)httpRequestForNoticeInfo {
    
    headerV.hidden = YES;
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
                    [barV.badgeView setHidden:NO];

                }else {
                    countLabel.hidden = YES;
                }
                NSString *allCountString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userallcount"];
                NSInteger allCount = noticeModel.userallcount.integerValue - allCountString.integerValue;
                
                if (allCount == 0) {
                    headerV.hidden = YES;
                    self.msgTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                    if(fetchController.count==0&&selfWeak.Type==1){
                        [selfWeak.nothingnessView setHidden:NO];
                        [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无记录" eventCallBack:nil];
                        [selfWeak.nothingnessView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-130)];
                        selfWeak.nothingnessView.centerH.constant = -20;
                    }
                }else {
                    headerV.hidden = NO;
                }
                
            }else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            [_msgTable reloadData];

            
        });
        
    }];
    
}

#pragma mark - HeaderView

-(UIView *)creatTableHeaderView
{
    if (headerV==nil) {
        
        headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,70)];
        //更改--6.07默认隐藏，待有数据再显示，防止闪现
        headerV.hidden = YES;
        [headerV setBackgroundColor:[UIColor whiteColor]];
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
        [headerV addSubview:contentLb];

        [headerV addSubview:lb];
        UIImageView * btn = [[UIImageView alloc]initWithFrame:CGRectMake(15,20,30,30)];
       
        [btn setImage:[UIImage imageNamed:@"邻圈_消息_个人通知"]];
        [headerV addSubview:btn];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTapAction:)];
        [headerV addGestureRecognizer:tap];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = TEXT_COLOR;
        timeLabel.textAlignment = NSTextAlignmentRight;
        [headerV addSubview:timeLabel];
        
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
        [headerV addSubview:countLabel];
        countLabel.sd_layout.rightEqualToView(timeLabel).topSpaceToView(timeLabel,1).widthIs(20).heightEqualToWidth();
        [countLabel setSd_cornerRadiusFromWidthRatio:@0.5];
        
        
        countLabel.text = [NSString stringWithFormat:@"%@",noticeModel.usercount];
        
        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(btn.mas_right).offset(15);
            make.top.equalTo(lb.mas_bottom).offset(1);
            make.height.equalTo(@20);
            make.right.equalTo(countLabel.mas_left).offset(-2);
            
        }];
        
        if (noticeModel.usercount.intValue > 0) {
            countLabel.hidden = NO;
        }
        
    }
    return headerV;
    
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
    if (Type==1) {

        [self httpRequestForNoticeInfo];

        [self.friendTable setHidden:YES];
        fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
        [self.msgTable.mj_header endRefreshing];
        [self.msgTable reloadData];
        [self.msgTable  setHidden:NO];

        
    }else if(Type == 2)
    {
        @WeakObj(self)
        NSLog(@"-------%@",searchTag);
        [ChatPresenter getComLastUser:^(id  _Nullable data, ResultCode resultCode) {
         

            [self.friendTable.mj_header endRefreshing];

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (resultCode==SucceedCode) {
                        NSArray * list = data;
                        
                        if ([list isKindOfClass:[NSArray class]]&&list.count>0) {
                            [selfWeak.nothingnessView setHidden:YES];
                            [friendArr removeAllObjects];
                            [friendArr addObjectsFromArray:data];

                            [selfWeak.friendTable reloadData];
                            [nothingV setHidden:YES];
                            self.friendTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                            [selfWeak.friendTable setHidden:NO];
                            
                        }else
                        {
                            [friendArr removeAllObjects];
                            self.friendTable.tableFooterView  = [self createNothingView];
                            [nothingV setHidden:NO];
                            [self.friendTable reloadData];
                            [selfWeak.friendTable setHidden:NO];

                        }

                    }else
                    {
                        [friendArr removeAllObjects];
                        self.friendTable.tableFooterView  = [self createNothingView];
                        [nothingV setHidden:NO];
                        [self.friendTable reloadData];
                        [selfWeak.friendTable setHidden:NO];

                    }
                });
            
        } withSex:searchTag andPage:@"1"];
    }
    
}
#pragma mark - 加载更多
-(void)loadmore
{
    page ++;
    @WeakObj(self)

    if (Type==1) {
        
            [self.friendTable setHidden:YES];
            [self.msgTable  setHidden:NO];
        
    }else if(Type == 2)
    {
        [self.friendTable setHidden:NO];
        [self.msgTable  setHidden:YES];
        [ChatPresenter getComLastUser:^(id  _Nullable data, ResultCode resultCode) {
            [self.friendTable.mj_footer endRefreshing];
            
            if (resultCode==SucceedCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray * list = data;

                    if ([list isKindOfClass:[NSArray class]]) {
                        
                        if (list.count==0) {
                            page--;
                            [selfWeak showToastMsg:@"没有更多数据" Duration:2.0f];

                            return ;
                        }
                        
                        [friendArr addObjectsFromArray:data];
                        [selfWeak.friendTable reloadData];
                    }
                    
                });
            }
            
        } withSex:searchTag andPage:[NSString stringWithFormat:@"%ld",page]];
        

    }
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
////    // 禁用 iOS7 返回手势
////    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
////        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
////    }
//
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//
//    self.navigationController.navigationBarHidden = NO;
    
    [barV.leftLb setText:@"消息"];
    [barV.rightLb setText:@"邻友"];
    [self setBadges];

    if (Type==1) {
        self.navigationItem.title = @"消息";
        [barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_消息selected"] forState:UIControlStateNormal];
        [barV.chatBtn setImage:[UIImage imageNamed:@"邻圈_邻友uncheck"] forState:UIControlStateNormal];
        
        [barV.leftLb setTextColor:UIColorFromRGB(0x9F111C)];
        [barV.rightLb setTextColor:UIColorFromRGB(0x8e8e8e)];

    }else
    {
        self.navigationItem.title = @"邻友";
        [barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_消息uncheck"] forState:UIControlStateNormal];
        [barV.chatBtn setImage:[UIImage imageNamed:@"邻圈_邻友selected"] forState:UIControlStateNormal];
        
        [barV.leftLb setTextColor:UIColorFromRGB(0x8e8e8e)];
        [barV.rightLb setTextColor:UIColorFromRGB(0x9F111C)];

    }
    
    [self loadone];
    
    
}

#pragma mark - tableviewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (Type ==1 &&tableView.tag ==1000) {
        
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
            
            NSLog(@"name==%@   count===%ld   userid==%@",GUM.sendName,(long)GUM.countMsg.integerValue-1,GUM.sendID);
            NSString *timeString = [XYString NSDateToString:GUM.systime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            cell.timeLb.text = [DateTimeUtils StringToDateTimeWithTime:timeString];
            
            cell.nameLb.text = GUM.sendName;
            cell.contentLb.text = GUM.content;
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:GUM.headPicUrl] placeholderImage:PLACEHOLDER_IMAGE];

        }
        
        return cell;
    }else if (Type == 2&&tableView.tag ==1001) {
        
        if(indexPath.section == 0 )
        {
            DetailInfoCell  * cell  = [self.friendTable dequeueReusableCellWithIdentifier:@"DetailInfoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell becomeFirstResponder];

            cell.swithbar.hidden = YES;
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLb.text = @"关注";
                    [cell.imgV setImage:[UIImage imageNamed:@"邻圈_详细资料_注"]];
                    
                }
                    break;
                case 1:
                {
                    cell.titleLb.text = @"粉丝";
                    [cell.imgV setImage:[UIImage imageNamed:@"邻圈_邻友列表_粉丝"]];

                }
                    break;
                case 2:
                {
                    cell.titleLb.text = @"黑名单";
                    [cell.imgV setImage:[UIImage imageNamed:@"邻圈_邻友列表_黑名单"]];
                    [cell.lineImg setHidden:YES];
                }
                    break;
                default:
                    break;
            }
            return  cell;
        }
        FriendsCell * cell = [self.friendTable dequeueReusableCellWithIdentifier:@"friendsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        RecentlyFriendModel * RFML = [friendArr objectAtIndex:indexPath.row];
        cell.nameLb.text = RFML.nickname;
        cell.ageLb.text = RFML.age;
        cell.contentLb.text = RFML.signature;
        cell.timeLb.text = [DateTimeUtils FriendsStringToDateTime:RFML.lastactiondate];
        
        if(RFML.sex.integerValue == 1)
        {
            [cell.sexV setBackgroundColor:BLUE_TEXT_COLOR];
            [cell.sexImg setImage:[UIImage imageNamed:@"邻圈_男"]];
            
        }else if(RFML.sex.integerValue == 2)
        {
            [cell.sexV setBackgroundColor:WOMEN_COLOR];
            [cell.sexImg setImage:[UIImage imageNamed:@"邻圈_女"]];
        }
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:RFML.userpic] placeholderImage:PLACEHOLDER_IMAGE];
        
        return cell;
        
        
    }
    
    return [UITableViewCell new];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (Type ==1) {
        return [fetchController count];
    }else if (Type ==2) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (Type ==1) {
        
        return 1;
    }else if (Type == 2) {
        if (section == 0) {
            return 3;
        }
        
        if (section == 1) {
            return friendArr.count;
            
        }
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Type ==1) {

//        if (indexPath.row==0) {
//            return 80;
//        }else if(indexPath.row == 1)
//        {
//            return 80;
//        }
        return 65;
    }
    if (indexPath.section==0) {
        return 50;
    }
    return 70;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (Type == 1) {
        return 5;
        
    }else if (Type == 2) {
        if (section == 0) {
            return 50;
        }else if (section == 1) {
            return 40;
        }
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Type == 1) {
        return YES;

    }
   return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Type == 1) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
                Gam_Chat * GC = [fetchController objectAtIndex:indexPath.section];
                [[DataOperation sharedDataOperation]deleteDataWithChatID:GC.chatID];
                [self loadone];
        
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.3;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (Type == 2) {
        if (section == 0) {
            UIView * v_0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 50)];
            
            [v_0 setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
            
            UIView * backV = [[UIView alloc]initWithFrame:CGRectMake(10,5,SCREEN_WIDTH-20-20,40)];
            backV.layer.borderWidth = 1;
            backV.layer.borderColor = UIColorFromRGB(0xdadada).CGColor;
            
            [v_0 addSubview:backV];
            
            
            UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(6,7.5,25,25)];
            [imgV setImage:[UIImage imageNamed:@"邻圈_群_群组列表_查找群"]];
            UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(35,5,1,30)];
            [imgLine setBackgroundColor:UIColorFromRGB(0xdadada)];
            
            UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(40   , 0, SCREEN_WIDTH-40-40,40)];
            lb.text = @"昵称／手机号／门牌号";
            lb.font = [UIFont systemFontOfSize:12.0f];
            lb.textColor = UIColorFromRGB(0x8e8e8e);
            
            [backV addSubview:lb];
            [backV addSubview:imgLine];
            [backV addSubview:imgV];
            UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapGestAction:)];
            [v_0 addGestureRecognizer:gest];
            
            return v_0;
        }
        
        if (section == 1) {
            
            UIView * v_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
            [v_1 setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
            
            UILabel * titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 10,100,30)];
            titleLb.text = [NSString stringWithFormat:@"最近在线(%@)",searchStr];
            
            titleLb.font = [UIFont systemFontOfSize:13.0f];

            
            UIButton * btn  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-60-10,17,70, 20)];
            [btn setTitle:@"筛选" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(screening:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选"] forState:UIControlStateNormal];
            
            UIButton * btn_down = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40,15,20, 20)];
            [btn_down setImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
            [btn_down addTarget:self action:@selector(screening:) forControlEvents:UIControlEventTouchUpInside];

            [v_1 addSubview:btn];
            [v_1 addSubview:titleLb];
            [v_1 addSubview:btn_down];

            return v_1;
        }
        
    }
    
    
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Type == 2) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                ///关注
                MyFollowVC * mfVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"MyFollowVC"];
                
                [self.navigationController pushViewController:mfVC animated:YES];
            }else if (indexPath.row == 1) {
                ///我的粉丝
                MyFansVC * mfVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"MyFansVC"];
                
                [self.navigationController pushViewController:mfVC animated:YES];
                
            }else if (indexPath.row == 2) {
                ///黑名单
                BlacklistVC * blVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"BlacklistVC"];
                
                [self.navigationController pushViewController:blVC animated:YES];
                

            }
        }else if (indexPath.section == 1)
        {
            RecentlyFriendModel * RFML = [friendArr objectAtIndex:indexPath.row];
            if([appDelegate.userData.userID isEqualToString:RFML.userID])
            {
                [self showToastMsg:@"不能和自己聊天！" Duration:2.5f];
                return;
            }

            
            PersonalDataVC * pdVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalDataVC"];
            pdVC.userID = RFML.userID;
            @WeakObj(self);
            [THMyInfoPresenter getOneUserInfoUserID:RFML.userID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(resultCode ==FailureCode)
                    {
                        NSNumber * code = data;
                        if (code.integerValue == 90002) {
                            [selfWeak showToastMsg:@"您已被拉黑！" Duration:3.0f];
                        }
                    }else
                    {
                        [selfWeak.navigationController pushViewController:pdVC animated:YES];
                        
                    }
                });
            }];

    }
    }else if (Type == 1)
    {
        
        Gam_Chat *GUM = [fetchController objectAtIndex:indexPath.section];

        @WeakObj(self);
        
        [THMyInfoPresenter getOneUserInfoUserID:GUM.chatID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(resultCode == SucceedCode)
                {
                    
                    UserInfoModel* UIML_P = data;
                    if (UIML_P.isblack.boolValue) {
                        [selfWeak showToastMsg:@"请先将该用户移除黑名单！" Duration:3.0f];
                    }else
                    {
                        ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
                        
                        
                        //chatC.navigationItem.title = GUM.sendName;
                        chatC.ReceiveID = GUM.chatID;
                        //chatC.chatterThumb = GUM.headPicUrl;
                        [selfWeak.navigationController pushViewController:chatC animated:YES];
                    }
                }
            });

        }];
        
                
        

       

//        switch (indexPath.row) {
//            case 0:
//            {
//                PersonalNoticeVC *pnVC  = [[PersonalNoticeVC alloc]init];
//                [self.navigationController pushViewController:pnVC animated:YES];
//
//            }
//                break;
//            case 1:
//            {
//                GroupNoticeVC * gnVC = [[GroupNoticeVC alloc]init];
//                [self.navigationController pushViewController:gnVC animated:YES];
//                
//            }
//                break;
//                
//
//            default:
//            {
//            
//            }
//                break;
//       }
    }
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
    PushMsgModel * pushMsg;
    ///个人通知
    pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
//    noticeCount = pushMsg.countMsg.integerValue;
    [self.msgTable.mj_header beginRefreshing];
    
    NSInteger rowCount=0;
    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];

    Gam_Chat * GCT;
    for(NSInteger i=0;i<fetchController.count;i++)
    {
        GCT=[fetchController objectAtIndex:i];
        
        rowCount+=GCT.countMsg.integerValue;
    }
    [barV.badgeView setHidden:YES];

    if(rowCount>fetchController.count)
    {
        [barV.badgeView setHidden:NO];
    }else
    {
        [barV.badgeView setHidden:YES];

    }
    [self httpRequestForNoticeInfo];

//pushMsg.countMsg
}
#pragma mark - 接收消息
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [self setBadges];
        
}
@end
