//
//  LS_MessageVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.

///VCS
#import "FriendViewController.h"
#import "ChatViewController.h"
#import "LS_PersonalNoticeVC.h"
#import "LS_NeighborCircleNoticeVC.h"

///Views
#import "PersonnalBarView.h"
#import "Masonry.h"

///Cells
#import "UnreadMessageCell.h"
///Others
#import "UITabBar+Badge.h"
#import "ChatPresenter.h"
#import "DateTimeUtils.h"
#import "Gam_Chat.h"
#import "Gam_UnreadMsg.h"
#import "DataOperation.h"
#import "DateUitls.h"
#import "PushMsgModel.h"
#import "THMyInfoPresenter.h"
#import "UserInfoModel.h"
#import "LS_MessageVC.h"
#import "CommunityManagerPresenters.h"

#import "L_AppNotificationPopVC.h"

@interface LS_MessageVC ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    
    NSInteger page;
    AppDelegate * appDelegate;
    NSArray * fetchController;
    UserNoticeCountModel *noticeModel;
    NothingnessView * nothingV;
    NSMutableArray * dataArr;
    NSMutableArray * topArr;
    NSMutableArray * chatArr;
    NSMutableArray * storeArr;
    NSString * ls_dataArr;
}

@property(nonatomic,strong)UITableView * msgTable;

@end

@implementation LS_MessageVC


#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = GetAppDelegates;
    ls_dataArr = [NSString stringWithFormat:@"ls_dataArr_%@",appDelegate.userData.userID];
    
    [self.navigationController.navigationBar setBarTintColor:NABAR_COLOR];
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 70, 20)];
    [bt setImage:[UIImage imageNamed:@"邻圈_邻友uncheck"] forState:UIControlStateNormal];
    [bt setTitle:@"邻友" forState:UIControlStateNormal];
    [bt setTitleColor:RGBACOLOR(177, 177, 177, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:12];
    [bt addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    bt.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    bt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    UIBarButtonItem *leftBarBt = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = leftBarBt;
    
   
    
    
    [self.view addSubview:self.msgTable];
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    
    dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    topArr  = [[NSMutableArray alloc]initWithCapacity:0];
    chatArr = [[NSMutableArray alloc]initWithCapacity:0];
    storeArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self createNothingView];
    [self.view addSubview:nothingV];

    [nothingV setHidden:YES];
    
    [self httpRequestNoticeCount];
    
//    BOOL isNotifitionOpen = [appDelegate checkNotifitionIsOpen];/** 推送是否开启 */
//    if (!isNotifitionOpen) {
//
//        /** 弹窗 */
//        L_AppNotificationPopVC *popVC = [L_AppNotificationPopVC getInstance];
//        [popVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
//            
//            if (index == 2) {
//                /** 去设置 */
//                
////                NSURL * url = [NSURL URLWithString:UIApplicationOpenURLOptionsSourceApplicationKey];
////                if([[UIApplication sharedApplication] canOpenURL:url]) {
////                    [[UIApplication sharedApplication] openURL:url];
////                }
////                APP-prefs:root=boundleId
//                
////                NSURL *url = [NSURL URLWithString:@"App-prefs:root=com.usnoon.050804.YouLifeApp"];
////                [[UIApplication sharedApplication] openURL:url];
//                
//                
////                NSString * urlString = [NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@",bundleID];
//                
//                [self gotoAppSystemSettings];
//                
//            }
//            
//        }];
//        
//    }

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"xiaoxi"];
    self.tabBarController.tabBar.hidden = NO;
    
    [self synchronousChatData];
    
    NSNumber * isNewPush = [[NSUserDefaults standardUserDefaults]objectForKey:@"ls_isNewPush"];
    
    if (isNewPush) {
        
        if (isNewPush.boolValue) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:@"ls_isNewPush"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self httpRequestNoticeCount];
            
        }
        
    }
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /** rootViewController不允许侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"xiaoxi"];
    
    [UserDefaultsStorage saveCustomArray:dataArr forKey:ls_dataArr];
    
}

#pragma mrk - 获取新未读消息数据
-(void)httpRequestNoticeCount {
    
    @WeakObj(self);
    NSString * ls_saveKey = [NSString stringWithFormat:@"saveTypes_%@",appDelegate.userData.userID];
    NSString * saveTypes = [[NSUserDefaults standardUserDefaults]objectForKey:ls_saveKey];

    [ChatPresenter getUserNoticeCountWithTypes:saveTypes :^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode) {
                
                [dataArr removeAllObjects];
                [dataArr addObjectsFromArray:data];
                [selfWeak setBadges];

                
                [selfWeak sortingDataArr];
                [nothingV setHidden:YES];
                [_msgTable setHidden:NO];
                
                if(dataArr.count == 0) {
                    [nothingV setHidden:NO];
                    [_msgTable setHidden:YES];
                }
                
                [_msgTable reloadData];
                
            }else {

                [selfWeak setBadges];

                if(dataArr.count == 0) {
                    [_msgTable setHidden:YES];
                    [nothingV setHidden:NO];
                }
                
                [selfWeak synchronousChatData];
                
            }

        });
        
    }];

  
}

#pragma mark - 左侧导航按钮

-(void)leftBtnAction:(id)sender {
    
    FriendViewController *friend = [[FriendViewController alloc]init];
    
    friend.Type = 2;
    
    friend.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friend animated:YES];
}

#pragma mark - 暂无数据

-(UIView *)createNothingView
{
    nothingV=[NothingnessView getInstanceView];
    nothingV.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    nothingV.centerH.constant = 50;
    nothingV.view_SubBg.hidden=YES;
    [nothingV.img_ErrorIcon setImage:[UIImage imageNamed:@"暂无数据"]];
    nothingV.lab_Clues.text = @"没有新消息";
    return nothingV;
}
#pragma mark - 初始化tableview
-(UITableView *)msgTable
{
    if (!_msgTable) {

        
        if (SCREEN_HEIGHT == 812.00) {
            
            _msgTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20,SCREEN_HEIGHT-64-self.tabBarController.tabBar.frame.size.height-bottomSafeArea_Height) style:UITableViewStylePlain];
        }else
        {
            _msgTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20,SCREEN_HEIGHT-64-self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
            
        }
    
        _msgTable.delegate =self;
        _msgTable.dataSource = self;
        [_msgTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_msgTable setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
        _msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _msgTable.showsVerticalScrollIndicator = NO;
        [_msgTable registerNib:[UINib nibWithNibName:@"UnreadMessageCell" bundle:nil] forCellReuseIdentifier:@"unreadCell"];
    }
    
    return _msgTable;
}

#pragma mark - TableViewDelegate/DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UnreadMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"unreadCell"];
    UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
    [cell assignmentWithModel:UNCML];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// MARK: - 兼容iOS 8方法需加上
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { }

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
    
    if (UNCML.type.integerValue == 0 || UNCML.type.integerValue == 2) {
        return NO;
    }
    return YES;
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * title_1  = @"       ";
    NSString * title_2  = @"置顶";
    UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
    if(UNCML.istop.boolValue)
    {
        title_2 = @"取消置顶";
    }else
    {
        title_2 = @"置顶";
    }
    /**
     删除按钮事件
     */
    @WeakObj(self);
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title_1 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
        if (UNCML.type.integerValue==3) {
            
            for(int i = 0;i<fetchController.count;i++)
            {
                Gam_Chat * GC = [fetchController objectAtIndex:i];
                
                if([GC.chatID isEqualToString:UNCML.receiveID])
                {
                    [[DataOperation sharedDataOperation]deleteDataWithChatID:GC.chatID];
                    
                }
            }
            
        }else
        {
            [selfWeak setUpTheTypes:UNCML.type AddOrDelete:NO];
        }
        [selfWeak setBadgesIfdidSelect:UNCML.usercount.integerValue];
        [dataArr removeObjectAtIndex:indexPath.row];
        UNCML.usercount = @"0";
        [tableView reloadData];
        
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
    }];
    action1.backgroundColor = kNewRedColor;
    /**
     置顶按钮事件
     */
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title_2 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
        
        if (UNCML.istop.boolValue) {
            
            UNCML.istop = @NO;
            UNCML.subscript = [NSDate date];
            
            [selfWeak sortTopData];
            
        }else {
            
            UNCML.istop = @YES;
            UNCML.subscript = [NSDate date];
            
            [selfWeak sortTopData];
            
        }
        
        [tableView reloadData];
        
    }];
    
    action2.backgroundColor = [UIColor orangeColor];
    return @[action1,action2];
}

#pragma mark - iOS11 新增左右侧滑方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (@available(iOS 11.0, *)) {

        @WeakObj(self);
        
        NSString * title_1  = @"";
        NSString * title_2  = @"置顶";
        UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
        if(UNCML.istop.boolValue)
        {
            title_2 = @"取消置顶";
        }else
        {
            title_2 = @"置顶";
        }
        
        //置顶 取消置顶
        UIContextualAction *topRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:title_2 handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
            
            if (UNCML.istop.boolValue) {
                
                UNCML.istop = @NO;
                UNCML.subscript = [NSDate date];
                
                [selfWeak sortTopData];
                
            }else {
                
                UNCML.istop = @YES;
                UNCML.subscript = [NSDate date];
                
                [selfWeak sortTopData];
                
            }
            
            [tableView reloadData];
            
        }];
        
        topRowAction.backgroundColor = [UIColor orangeColor];
        
        //删除
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:title_1 handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
            if (UNCML.type.integerValue==3) {
                
                for(int i = 0;i<fetchController.count;i++)
                {
                    Gam_Chat * GC = [fetchController objectAtIndex:i];
                    
                    if([GC.chatID isEqualToString:UNCML.receiveID])
                    {
                        [[DataOperation sharedDataOperation]deleteDataWithChatID:GC.chatID];
                        
                    }
                }
                
            }else
            {
                [selfWeak setUpTheTypes:UNCML.type AddOrDelete:NO];
            }
            [selfWeak setBadgesIfdidSelect:UNCML.usercount.integerValue];
            [dataArr removeObjectAtIndex:indexPath.row];
            UNCML.usercount = @"0";
            [tableView reloadData];
            
            //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }];
        
        deleteRowAction.image = [UIImage imageNamed:@"删除图标"];
        deleteRowAction.backgroundColor = kNewRedColor;
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction,topRowAction]];
        
        return config;

        
    }else {
        return nil;
    }
    
};

#else

#endif

#pragma mark -- select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserNoticeCountModel * UNCML = [dataArr objectAtIndex:indexPath.row];
    
    if ([UNCML.type isEqualToString:@"3"]) {
        ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
        chatC.hidesBottomBarWhenPushed = YES;
        chatC.chatterName = UNCML.title;
        chatC.ReceiveID = UNCML.receiveID;
        [self.navigationController pushViewController:chatC animated:YES];

    }else if([UNCML.type isEqualToString:@"4"]||[UNCML.type isEqualToString:@"5"])
    {
        ///点赞
        LS_NeighborCircleNoticeVC *ls_ncnVC = [[LS_NeighborCircleNoticeVC alloc]init];
        ///如果是系统通知或者个人通知，需要blcok回调传值更改页面展示
        ls_ncnVC.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            UNCML.usernotice = data;
            [UserDefaultsStorage saveCustomArray:dataArr forKey:ls_dataArr];
            [_msgTable reloadData];
        };
        ls_ncnVC.UNCML = UNCML;
        ls_ncnVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ls_ncnVC animated:YES];
        
    }else {
        LS_PersonalNoticeVC * ls_pnVC = [[LS_PersonalNoticeVC alloc]init];

        ls_pnVC.hidesBottomBarWhenPushed = YES;
        ls_pnVC.type = UNCML.type;

        ///如果是系统通知或者个人通知，需要blcok回调传值更改页面展示
        ls_pnVC.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            UNCML.usernotice = data;
            [UserDefaultsStorage saveCustomArray:dataArr forKey:ls_dataArr];
            [_msgTable reloadData];
        };
        
        [self.navigationController pushViewController:ls_pnVC animated:YES];
    }
    
    [self setBadgesIfdidSelect:UNCML.usercount.integerValue];
    UNCML.usercount = @"0";
    [tableView reloadData];

}

#pragma mark - 数据处理排序置顶

-(void)sortingDataArr {
    
    [topArr removeAllObjects];
    [storeArr removeAllObjects];
    
    ///取出聊天未读数据添加到未读消息列表中
    NSMutableDictionary * fetchDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
    
    for (int i = 0; i<fetchController.count; i++) {
        
        Gam_Chat * GCM = [fetchController objectAtIndex:i];
        UserNoticeCountModel * UMCML = [[UserNoticeCountModel alloc]init];
        
        UMCML.usercount =[NSString stringWithFormat:@"%ld",GCM.countMsg.integerValue];
        UMCML.userlasttime =  [XYString NSDateToString:GCM.systime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        UMCML.title = GCM.sendName;
        UMCML.usernotice = GCM.content;
        UMCML.type = @"3";
        UMCML.picurl = GCM.headPicUrl;
        UMCML.receiveID = GCM.chatID;
        [fetchDic setObject:UMCML forKey:UMCML.receiveID];
    }
    
    [dataArr addObjectsFromArray:fetchDic.allValues];

    NSArray *arr1 = [UserDefaultsStorage getDataforKey:ls_dataArr];
    [storeArr addObjectsFromArray:[arr1 copy]];

    ///将存储数据的置顶信息 通过匹配title和type值 赋值给新消息数据
    for (int i =0;i<storeArr.count; i++) {
        
        UserNoticeCountModel * UNCML_store =storeArr[i];

        for (int j = 0; j<dataArr.count; j++) {
            
            UserNoticeCountModel * UNCML_data =dataArr[j];
            
            if (([UNCML_store.type isEqualToString:UNCML_data.type]&&UNCML_store.type.integerValue!=3)||[UNCML_store.title isEqualToString:UNCML_data.title]){
                
                UNCML_data.istop = UNCML_store.istop;
                UNCML_store.usercount = UNCML_data.usercount;
                UNCML_store.usernotice = UNCML_data.usernotice;
                UNCML_store.userlasttime = UNCML_data.userlasttime;
            }
            
        }
        
    }
    
    [dataArr addObjectsFromArray:storeArr];
    
    ///数据去重
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (int i = 0; i<dataArr.count; i++) {
        UserNoticeCountModel * UMCML = [dataArr objectAtIndex:i];
        NSString * key = UMCML.receiveID;
        if ([XYString isBlankString:UMCML.receiveID]) {
            
            key = UMCML.type;
            if ([XYString isBlankString:UMCML.type]) {
                key = @"receiveID";
            }
        }
        [dataDic setObject:UMCML forKey:key];
    }
    
    [dataArr removeAllObjects];
    
    [dataArr addObjectsFromArray:dataDic.allValues];
    
    [self sortTopData];
    
}

#pragma mark - 选择查看消息修正未读数
-(void)setBadgesIfdidSelect:(NSInteger)msgCount
{
    __block NSInteger underCount = 0;
    [dataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UserNoticeCountModel * UNCML = obj;
        underCount += UNCML.usercount.integerValue;
        
    }];
    NSInteger rowCount=0;

    PushMsgModel * PML = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.PersonalMsg];
    
    underCount -= msgCount;
    
    if(underCount>0)
    {
        if (PML==nil) {
            PML=[PushMsgModel new];
            PML.countMsg=[[NSNumber alloc]initWithInt:0];
        }
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",underCount + rowCount];
        PML.countMsg = [[NSNumber alloc]initWithInt:[[NSString stringWithFormat:@"%ld",underCount] intValue]];
        [UserDefaultsStorage saveData:PML forKey:appDelegate.PersonalMsg];
        
    }else{
        
        PML.countMsg=[[NSNumber alloc]initWithInt:0];
        PML.content=@"";
        [UserDefaultsStorage saveData:PML forKey:appDelegate.PersonalMsg];
        self.navigationController.tabBarItem.badgeValue = nil;
        
    }

}
#pragma mark - 设置未读消息

- (void)setBadges {

    __block NSInteger underCount = 0;
    [dataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UserNoticeCountModel * UNCML = obj;
        if (UNCML.type.integerValue!=3) {
            underCount += UNCML.usercount.integerValue;
        }
      
    }];
    
    NSInteger rowCount=0;
    
    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
    
    Gam_Chat * GCT;
    
    if (fetchController) {
    
        for(NSInteger i=0;i<fetchController.count;i++)
        {
            GCT=[fetchController objectAtIndex:i];
            
            rowCount+=GCT.countMsg.integerValue;
        }
    }

    
    PushMsgModel * PML;
    if(underCount>0 || rowCount>0) {
            
        PML =(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.PersonalMsg];
        if (PML==nil) {
            PML=[PushMsgModel new];
            PML.countMsg=[[NSNumber alloc]initWithInt:0];
        }
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",underCount + rowCount];
        PML.countMsg = [[NSNumber alloc]initWithInt:[self.navigationController.tabBarItem.badgeValue intValue]];
        [UserDefaultsStorage saveData:PML forKey:appDelegate.PersonalMsg];

    }else{
        
        PML.countMsg=[[NSNumber alloc]initWithInt:0];
        PML.content=@"";
        [UserDefaultsStorage saveData:PML forKey:appDelegate.PersonalMsg];
        self.navigationController.tabBarItem.badgeValue = nil;
        
    }
    
}

#pragma mark - 接收消息

-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [super subReceivePushMessages:aNotification];
    [self httpRequestNoticeCount];
}

#pragma mark - 个人发起聊天消息以后同步数据

- (void)synchronousChatData {
    
    [storeArr removeAllObjects];
    [chatArr removeAllObjects];
    
    NSArray *arr1 = [UserDefaultsStorage getDataforKey:ls_dataArr];
    [storeArr addObjectsFromArray:[arr1 copy]];;
    
    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
    NSMutableDictionary * fetchDic = [[NSMutableDictionary alloc]init];
    
    ///取出聊天数据转换成UserNoticeCountModel模型
    for (int i = 0; i<fetchController.count; i++) {
        
        Gam_Chat * GCM = [fetchController objectAtIndex:i];
        UserNoticeCountModel * UMCML = [[UserNoticeCountModel alloc]init];
        
        UMCML.usercount = [NSString stringWithFormat:@"%@",GCM.countMsg];
        UMCML.userlasttime =  [XYString NSDateToString:GCM.systime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        UMCML.title = GCM.sendName;
        UMCML.usernotice = GCM.content;
        UMCML.type = @"3";
        UMCML.picurl = GCM.headPicUrl;
        UMCML.receiveID = GCM.chatID;
        
        [fetchDic setObject:UMCML forKey:UMCML.receiveID];
        
    }
    
    [chatArr addObjectsFromArray:fetchDic.allValues];

    ///更新已存储的聊天数据
    for (int i =0;i<chatArr.count; i++) {
        
        UserNoticeCountModel * UNCML_i =chatArr[i];
        
        for (int j = 0; j<storeArr.count; j++) {
            
            UserNoticeCountModel * UNCML_j =storeArr[j];

            if ([UNCML_i.receiveID isEqualToString:UNCML_j.receiveID]) {
                
                UNCML_j.usernotice = UNCML_i.usernotice;
                UNCML_j.usercount  = UNCML_i.usercount;
                UNCML_j.userlasttime = UNCML_i.userlasttime;
                UNCML_j.type = @"3";
                [UserDefaultsStorage saveCustomArray:storeArr forKey:ls_dataArr];
                
                [chatArr removeObject:UNCML_i];
                
            }
        }
    }
    
    [dataArr removeAllObjects];
    ///添加新增的聊天数据
    [dataArr addObjectsFromArray:chatArr];
    
    NSArray *arr2 = [UserDefaultsStorage getDataforKey:ls_dataArr];
    [storeArr removeAllObjects];
    [storeArr addObjectsFromArray:[arr2 copy]];
    
    if (storeArr) {
        [dataArr addObjectsFromArray:[storeArr copy]];
        //        dataArr = [UserDefaultsStorage getDataforKey:ls_dataArr];
    }
    
    ///数据去重
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    for (int i = 0; i<dataArr.count; i++) {
        
        UserNoticeCountModel * UMCML = [dataArr objectAtIndex:i];
        NSString * key = UMCML.receiveID;
        if ([XYString isBlankString:UMCML.receiveID]) {
            
            key = UMCML.type;
            if ([XYString isBlankString:UMCML.type]) {
                key = @"receiveID";
            }
        }
        [dataDic setObject:UMCML forKey:key];
        
    }
    
    [dataArr removeAllObjects];
    
    [dataArr addObjectsFromArray:dataDic.allValues];
    
    ///排序置顶数据并存储
    [self sortTopData];

    if(dataArr.count == 0) {
        [_msgTable setHidden:YES];
        [nothingV setHidden:NO];
    }else {
        [_msgTable setHidden:NO];
        [nothingV setHidden:YES];
    }

    [self.msgTable reloadData];

}

#pragma mark -- 置顶排序

-(void)sortTopData {
    
    [topArr removeAllObjects];
    ///取出置顶数据
    [dataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UserNoticeCountModel * UNCML = obj;
        if (UNCML.istop.boolValue) {
            
            [topArr addObject:UNCML];
            [dataArr removeObject:UNCML];
            
        }
        
    }];
    
    //=========================系统通知 个人通知占位时间为空排序问题=====2017-08-29修改============================================
    for (UserNoticeCountModel * UNCML in topArr) {
//        NSLog(@"排序前=====%@=====%@=====%@=====%@=====%@=====%@",UNCML.title,UNCML.subscript,UNCML.type,UNCML.istop,UNCML.userlasttime,UNCML.usernotice);
        
        if (!UNCML.subscript) {
            UNCML.subscript = [NSDate date];
        }

    }
    //=========================系统通知 个人通知占位时间为空排序问题=====2017-08-29修改============================================

    ///置顶数据排序
    NSArray * temp_topArr = [topArr sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        
        UserNoticeCountModel *object1 = (UserNoticeCountModel *)obj1;
        UserNoticeCountModel *object2 = (UserNoticeCountModel *)obj2;
        
        NSComparisonResult result = [object1.subscript compare:object2.subscript];
        
//        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
        
    }];
    
    //=========================其他消息占位时间为空排序问题=====2017-08-29修改============================================
    for (UserNoticeCountModel * UNCML in dataArr) {
        //        NSLog(@"排序前=====%@=====%@=====%@=====%@=====%@=====%@",UNCML.title,UNCML.subscript,UNCML.type,UNCML.istop,UNCML.userlasttime,UNCML.usernotice);
        
        if (!UNCML.userlasttime) {
            UNCML.userlasttime = [XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"];
        }
        
    }
    //=========================其他消息占位时间为空排序问题=====2017-08-29修改============================================

    ///排序剩余数据
    NSArray * tempArr = [dataArr sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        
        UserNoticeCountModel *object1 = (UserNoticeCountModel *)obj1;
        UserNoticeCountModel *object2 = (UserNoticeCountModel *)obj2;
        NSDate * obj_1_date = [XYString  NSStringToDate:[object1.userlasttime substringWithRange:NSMakeRange(0,19)]];
        NSDate * obj_2_date = [XYString  NSStringToDate:[object2.userlasttime substringWithRange:NSMakeRange(0,19)]];
        
        return [obj_2_date compare:obj_1_date];
        
    }];
    
    ///整合数据保存
    [dataArr removeAllObjects];
    [dataArr addObjectsFromArray:temp_topArr];
    [dataArr addObjectsFromArray:tempArr];
    
    //=========================系统通知 个人通知永久置顶=====2017-08-29修改===================================================
    
    NSMutableArray *currArr = [[NSMutableArray alloc] initWithArray:dataArr];

    BOOL isSystemMessage = NO;/** 是否有系统通知 */
    BOOL isPersonMessage = NO;/** 是否有个人通知 */
    
    for (int i = 0 ; i < dataArr.count; i++) {
        
        UserNoticeCountModel *object1 = dataArr[i];
        
        if (object1.type.integerValue == 0) {
            isSystemMessage = YES;
            
            object1.istop = @YES;
            object1.subscript = [NSDate date];
            
            [currArr removeObject:object1];
            [currArr insertObject:object1 atIndex:0];
        }
        
        if (object1.type.integerValue == 2) {
            isPersonMessage = YES;
            
            object1.istop = @YES;
            object1.subscript = [NSDate date];

            if (isSystemMessage) {
                
                [currArr removeObject:object1];
                [currArr insertObject:object1 atIndex:1];
                
            }else {
                
                [currArr removeObject:object1];
                [currArr insertObject:object1 atIndex:0];
            }
        }
        
    }

    if (!isSystemMessage) {
        
        UserNoticeCountModel * UNCML_store1 = [[UserNoticeCountModel alloc] init];
        UNCML_store1.istop = @YES;
        UNCML_store1.type = @"0";
        UNCML_store1.title = @"系统通知";
        UNCML_store1.usercount = @"0";
        UNCML_store1.usernotice = @"";
        UNCML_store1.userlasttime = @"";
        UNCML_store1.subscript = [NSDate date];

        if (currArr.count > 0) {
            [currArr insertObject:UNCML_store1 atIndex:0];
        }else {
            [currArr addObject:UNCML_store1];
        }
        
    }
    
    if (!isPersonMessage) {
        
        UserNoticeCountModel * UNCML_store1 = [[UserNoticeCountModel alloc] init];
        UNCML_store1.istop = @YES;
        UNCML_store1.type = @"2";
        UNCML_store1.title = @"个人通知";
        UNCML_store1.usercount = @"0";
        UNCML_store1.usernotice = @"";
        UNCML_store1.userlasttime = @"";
        UNCML_store1.subscript = [NSDate date];

        if (currArr.count > 2) {
            [currArr insertObject:UNCML_store1 atIndex:1];
        }else {
            [currArr addObject:UNCML_store1];
        }
        
    }
    
    [dataArr removeAllObjects];
    [dataArr addObjectsFromArray:currArr];

    //=========================系统通知 个人通知永久置顶=====2017-08-29修改===================================================

    [UserDefaultsStorage saveCustomArray:dataArr forKey:ls_dataArr];
    
}

@end
