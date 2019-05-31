//
//  MyTabVC.m
//  TimeHomeApp
//
//  Created by us on 16/1/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyTabVC.h"
#import "THMySettingsVC.h"
#import "MySettingsViewController.h"
#import "THMyVisitorListsViewController.h"
#import "THMySubRegionListViewController.h"
#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "THMyActivityListViewController.h"
#import "THUserLevelsInfoVC.h"

//网络请求
#import "THMyInfoPresenter.h"
#import "UserPointAndMoneyPresenters.h"
#import "ChatMessageMainVC.h"
#import "PushMsgModel.h"
#import "DataOperation.h"
#import "MainTabBars.h"

#import "THMyCollectionVC.h"

//TVC
#import "L_MyHeaderInfoTVC.h"
#import "L_MyInfoBaseTVC.h"
#import "L_MoneyAndCountTVC.h"
#import "L_MyOrderTwoButtonTVC.h"
#import "L_MyInteractFourButton.h"
//VC
#import "L_MyPublishViewController.h"
#import "L_MyMoneyViewController.h"
#import "L_MyCommentsViewController.h"
#import "L_HelpsViewController.h"
#import "L_MyAttentionViewController.h"
#import "L_MyCommunityViewController.h"

#import "L_NewPointCenterViewController.h"
#import "L_MyExchangeListViewController.h"
#import "PAMyOrderViewController.h"

#import "WebViewVC.h"
#import "ZG_ScratchViewController.h"
#import "SigninPopVC.h"//签到弹窗
#import "L_ZhongJiangRecordViewController.h"
#import "RaiN_NewSigninPresenter.h"

#import "L_NewMyCommunityCertifyVC.h"
#import "PAUserInfoRequest.h"
#import "PAMyRedBagVoucherViewController.h"
#import "PAUserManager.h"

@interface MyTabVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titles;
    NSArray *leftImages;
    /**
     *  维修推送信息
     */
    NSString *showRepairMsg;
    /**
     *  投诉推送信息
     */
    NSString *showComplainMsg;

    AppDelegate *appDelegate;
    
}
@property (nonatomic, strong) UITableView *tableView;
/**
 *  我的信息model
 */
@property (nonatomic, strong) PAUserData *userData;

@end

@implementation MyTabVC

-(void)scratch:(id)sender{
    
    ZG_ScratchViewController *scratch = [[ZG_ScratchViewController alloc]init];
    scratch.hidesBottomBarWhenPushed = YES;
    [scratch getReadytime:@"1" frequency:@"1"];
    [self.navigationController pushViewController:scratch animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    NSLog(@"===%@",[AppDelegate getNetWorkStates]);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //设置消息标记
    [self setBadges];
    [self getMyInfoHttpRequest];
    
//    [TalkingData trackPageBegin:@"wode"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"wode"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /** rootViewController不允许侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.tintColor = TITLE_TEXT_COLOR;
    
    [self createTitles];

    showRepairMsg   = @"";
    showComplainMsg = @"";
    [self createTableView];

    appDelegate = GetAppDelegates;
    _userData = appDelegate.userData;
    [_tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSigninNet) name:kTaskBoardSign object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTaskBoardSign object:nil];
}

// MARK: - 获得登陆用户的个人信息
- (void)getMyInfoHttpRequest {

    PAUserInfoRequest *api = [[PAUserInfoRequest alloc]initWithToken:appDelegate.userData.token?:appDelegate.userData.token];
    @WeakObj(self);
    [api requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {

        
        NSLog(@"返回数据：%@",responseModel.data);
        if (responseModel.data) {
            PAUserInfo * userinfo = [PAUserInfo yy_modelWithJSON:[responseModel.data objectForKey:@"userinfo"]];
            [[PAUserManager sharedPAUserManager]updataUserInfo:userinfo];
            _userData = appDelegate.userData;
            [_tableView reloadData];
        }
        [selfWeak getUserIntergelAndAccount];/** 获得用户的积分和余额 */

    
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"权限获取失败");
        [selfWeak getUserIntergelAndAccount];/** 获得用户的积分和余额 */

    }];
    
//    return;
//    [THMyInfoPresenter getMyUserInfoUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if(resultCode == SucceedCode) {
//                _userData = appDelegate.userData;
//
//                [_tableView reloadData];
//
//            }
//            [self getUserIntergelAndAccount];/** 获得用户的积分和余额 */
//
//        });
//
//    }];
    
}
// MARK: - 获得用户的积分和余额
- (void)getUserIntergelAndAccount {

    [UserPointAndMoneyPresenters getIntegralBalanceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if(resultCode == SucceedCode)
            {
                _userData = appDelegate.userData;
                [_tableView reloadData];
            }

        });
        
    }];
    
}

// MARK: - 标题数据
- (void)createTitles {
    
//    titles = [[NSArray alloc]initWithObjects:@[@"",@""],@[@""],@[@"我的社区"],@[@"积分商城",@"我的订单",@"我的票券"],@[@"中奖纪录"],@[@"我的发布"],@[@"帮助意见与反馈"],@[@"设置"], nil];
//    leftImages = [[NSArray alloc]initWithObjects:@[@"",@""],@[@""],@[@"我的-首页-我的社区图标"],@[@"我的-首页-积分商城图标",@"我的订单-图标(新)",@"我的票券-图标"],@[@"中奖纪录"],@[@"我的-首页-我的发布图标"],@[@"我的-首页-帮助图标"],@[@"我的_设置"],nil];
    
    titles = [[NSArray alloc]initWithObjects:@[@"",@""],@[@""],@[@"我的社区"],@[@"积分商城",@"我的订单",@"我的红包",@"我的卡券"],@[@"中奖记录"],@[@"我的发布"],@[@"帮助意见与反馈"],@[@"设置"], nil];
    leftImages = [[NSArray alloc]initWithObjects:@[@"",@""],@[@""],@[@"我的-首页-我的社区图标"],@[@"我的-首页-积分商城图标",@"我的订单-图标(新)",@"我的-开门红包",@"我的票券-图标"],@[@"中奖记录"],@[@"我的-首页-我的发布图标"],@[@"我的-首页-帮助图标"],@[@"我的_设置"],nil];
    
}

// MARK: - 创建表
- (void)createTableView {
    
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, SCREEN_HEIGHT- self.navigationController.navigationBar.frame.size.height -self.tabBarController.tabBar.frame.size.height - rectStatus.size.height) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorColor = LINE_COLOR;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [[UIView alloc] init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.separatorColor = [UIColor clearColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerNib:[UINib nibWithNibName:@"L_MyHeaderInfoTVC" bundle:nil] forCellReuseIdentifier:@"L_MyHeaderInfoTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyInfoBaseTVC" bundle:nil] forCellReuseIdentifier:@"L_MyInfoBaseTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_MoneyAndCountTVC" bundle:nil] forCellReuseIdentifier:@"L_MoneyAndCountTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyOrderTwoButtonTVC" bundle:nil] forCellReuseIdentifier:@"L_MyOrderTwoButtonTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyInteractFourButton" bundle:nil] forCellReuseIdentifier:@"L_MyInteractFourButton"];

}

// MARK: - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titles[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == (titles.count -1)) return 8.f;
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        return 58;
    }else if (indexPath.section == 1) {
        return 103;
    }
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    @WeakObj(self);
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            L_MyHeaderInfoTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyHeaderInfoTVC"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _userData;

            cell.randButtonDidClick = ^() {
                //用户等级
                THUserLevelsInfoVC *levelVC = [[THUserLevelsInfoVC alloc]init];
                [levelVC setHidesBottomBarWhenPushed:YES];

                [selfWeak.navigationController pushViewController:levelVC animated:YES];
            };
            
            //签到
            cell.signOnBlock = ^{
//                [self scratch:nil];
                [selfWeak newSigninNet];
            };
            return  cell;
            
        }else {
            
            L_MoneyAndCountTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MoneyAndCountTVC"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            //余额
            if (![XYString isBlankString:_userData.balance]) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_userData.balance.floatValue];
            }else {
                cell.moneyLabel.text = @"￥0.00";
            }
            
            //积分
            if (![XYString isBlankString:_userData.integral]) {
                cell.countLabel.text = [NSString stringWithFormat:@"%@",_userData.integral];
            }else {
                cell.countLabel.text = @"0";
            }
            
            //按钮点击
            cell.twoButtonClickCallBack = ^(NSInteger index) {
              
                if (index == 1) {
                    //余额
                    L_MyMoneyViewController *myMoneyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyMoneyViewController"];
                    [myMoneyVC setHidesBottomBarWhenPushed:YES];

                    [self.navigationController pushViewController:myMoneyVC animated:YES];

                }else {
                    /** 新版积分界面 */
                    L_NewPointCenterViewController *pointVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewPointCenterViewController"];
                    [pointVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:pointVC animated:YES];
                    
                }
                
            };
            
            return cell;
        }
        
    }else if (indexPath.section == 1) {
        
        L_MyInteractFourButton *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyInteractFourButton"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.fourButtonDidClickBlock = ^(NSInteger buttonTag) {
          
            if (buttonTag == 1) {
                NSLog(@"我的收藏");
                
                //我的收藏
                THMyCollectionVC *myCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"THMyCollectionVC"];
                [myCollectionVC setHidesBottomBarWhenPushed:YES];

                [self.navigationController pushViewController:myCollectionVC animated:YES];
                
            }else if (buttonTag == 2) {
                NSLog(@"我的关注");
                
                //我的关注
                L_MyAttentionViewController *attentionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyAttentionViewController"];
                [attentionVC setHidesBottomBarWhenPushed:YES];

                [self.navigationController pushViewController:attentionVC animated:YES];

            }else if (buttonTag == 3) {
                NSLog(@"我的评论");
                
                //我的评论
                L_MyCommentsViewController *commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyCommentsViewController"];
                [commentsVC setHidesBottomBarWhenPushed:YES];

                [self.navigationController pushViewController:commentsVC animated:YES];

            }else {
                NSLog(@"我的活动");
                
                //我的活动
                THMyActivityListViewController *activityVC = [[THMyActivityListViewController alloc]init];
                [activityVC setHidesBottomBarWhenPushed:YES];

                [self.navigationController pushViewController:activityVC animated:YES];

            }
            
        };
        
        return cell;
        
    }else {
        
        L_MyInfoBaseTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyInfoBaseTVC"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftImageView.image = [UIImage imageNamed:leftImages[indexPath.section][indexPath.row]];
        cell.leftLabel.text = titles[indexPath.section][indexPath.row];
        cell.dotView.hidden = YES;
        cell.bottomLineView.hidden = YES;

        cell.leftImageLeadingConstraint.constant = 25;
        cell.leftImageWidthConstraint.constant = 30;
        cell.leftImageHeightConstraint.constant = 30;
        cell.leftImageTraingConstraint.constant = 10;
        
        if (indexPath.section == 2) {
            
            if (![XYString isBlankString:showRepairMsg] || ![XYString isBlankString:showComplainMsg]) {
                cell.dotView.hidden = NO;
            }
            
        }
        
        if (indexPath.section == 3) {
            
//            if (indexPath.row == 0 || indexPath.row == 1) {
//                cell.bottomLineView.hidden = NO;
//            }
            
            if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
                cell.bottomLineView.hidden = NO;
            }

            if (indexPath.row == 2) {
                cell.leftImageLeadingConstraint.constant = 30;
                cell.leftImageWidthConstraint.constant = 20;
                cell.leftImageHeightConstraint.constant = 20;
                cell.leftImageTraingConstraint.constant = 15;
            }
            
        }
        
        if (indexPath.section == 6) {
            
            cell.leftImageLeadingConstraint.constant = 30;
            cell.leftImageWidthConstraint.constant = 20;
            cell.leftImageHeightConstraint.constant = 20;
            cell.leftImageTraingConstraint.constant = 15;
            
        }
        
        if (indexPath.section ==  7) {
            cell.leftImageLeadingConstraint.constant = 32;
            cell.leftImageWidthConstraint.constant = 16;
            cell.leftImageHeightConstraint.constant = 16;
            cell.leftImageTraingConstraint.constant = 17;
        }

        return cell;
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            THMySettingsVC *mySettingVC  = [[THMySettingsVC alloc]init];
            [mySettingVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:mySettingVC animated:YES];
        }
        
    }else if (indexPath.section == 2) {
        
        //我的社区
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
        L_NewMyCommunityCertifyVC *communityVC = [storyBoard instantiateViewControllerWithIdentifier:@"L_NewMyCommunityCertifyVC"];
        communityVC.hidesBottomBarWhenPushed = YES;
        communityVC.showRepairMsg = showRepairMsg;
        communityVC.showComplainMsg = showComplainMsg;
        [self.navigationController pushViewController:communityVC animated:YES];

    }else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            /** 积分商城 */
            [self comeingoodsWithCallBack:nil];
        }
        if (indexPath.row == 1) {
            
            /** 新我的订单 */
//            L_MyExchangeListViewController *exchangeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyExchangeListViewController"];
//            [self.navigationController pushViewController:exchangeVC animated:YES];
            PAMyOrderViewController *orderVC = [[PAMyOrderViewController alloc]init];
            orderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
        if (indexPath.row == 2) {
            /** 我的红包 */
            NSLog(@"我的红包");
//            L_MyRedBagViewController *redVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyRedBagViewController"];
//            [self.navigationController pushViewController:redVC animated:YES];
//
            PAMyRedBagVoucherViewController *redBagVC = [[PAMyRedBagVoucherViewController alloc]initWithNibName:@"PAMyRedBagVoucherViewController" bundle:nil];
            redBagVC.tableType = MYREDBAG_TABLE_TYPE_REDBAG;
            redBagVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:redBagVC animated:YES];

        }
        
        if (indexPath.row == 3) {
            /** 我的票券 */
            NSLog(@"我的票券");
//            L_MyTicketsListViewController *ticketsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyTicketsListViewController"];
//            [self.navigationController pushViewController:ticketsVC animated:YES];
            PAMyRedBagVoucherViewController *redBagVC = [[PAMyRedBagVoucherViewController alloc]initWithNibName:@"PAMyRedBagVoucherViewController" bundle:nil];
            redBagVC.tableType = MYREDBAG_TABLE_TYPE_VOUCHER;
            redBagVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:redBagVC animated:YES];

        }
    }else if (indexPath.section == 4) {

        NSLog(@"中奖纪录");
        //中奖纪录
        L_ZhongJiangRecordViewController *zjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_ZhongJiangRecordViewController"];
        zjVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zjVC animated:YES];
        
    }else if (indexPath.section == 5) {
        
        NSLog(@"我的发布");
        //我的发布
        L_MyPublishViewController *myPublishVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyPublishViewController"];
        myPublishVC.selectIndex = 1;
        [myPublishVC setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:myPublishVC animated:YES];
        
    }else if (indexPath.section == 6) {
        
        //帮助意见与反馈
        L_HelpsViewController *helpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HelpsViewController"];
        [helpVC setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:helpVC animated:YES];

    }else if (indexPath.section == 7) {
        
        //设置
        MySettingsViewController *mySetVC = [[MySettingsViewController alloc]init];
        [mySetVC setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:mySetVC animated:YES];
        
    }else {
        return;
    }
    
}

#pragma  mark ------------推送消息处理-----------
-(void)subReceivePushMessages:(NSNotification *)aNotification {
    [self setBadges];
}
/**
 *  设置消息标记
 */
-(void)setBadges {
    
    PushMsgModel * pushMsg;
    /**
     *  我的 维修
     */
    pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.RepairMsg];
    if (pushMsg != nil) {
        NSInteger tmp = pushMsg.countMsg.integerValue;
        if(tmp>0)
        {
            
            /**
             *  处理维修显示标记
             */
            showRepairMsg = pushMsg.content;
            
        }
        else
        {
            showRepairMsg =@"";
        }
    }
    /**
     *  我的 投诉
     */
    pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.ComplainMsg];
    if (pushMsg != nil) {
        NSInteger tmp = pushMsg.countMsg.integerValue;
        if(tmp>0)
        {
            /**
             *  处理投诉显示标记
             */
            showComplainMsg = pushMsg.content;
        }
        else
        {
            showComplainMsg=@"";
        }
    }
    [_tableView reloadData];
    NSLog(@"showComplainMsg==%@",showComplainMsg);
    NSLog(@"showRepairMsg==%@",showRepairMsg);
    MainTabBars *tab=(MainTabBars *)self.tabBarController;
    [tab setTabBarBadges];
  
}

//MARK: - ------------新版本签到相关
- (void)newSigninNet {
    
    [RaiN_NewSigninPresenter getUserSignWithupdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSDictionary *dic = data[@"map"];
                
               
                SigninPopVC * shareSigninPopVC =  [SigninPopVC shareSigninPopVC];
                [shareSigninPopVC showInVC:self with:dic];
                shareSigninPopVC.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    NSNumber * datanum = data;
                    NSLog(@"__%d___",datanum.boolValue);
                    if (datanum.boolValue==NO) {
                        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:@"1" forKey:@"isSignup"];//设置签到状态为1
                        [userDefaults synchronize];
                    }
                    
                };
            }else {
                NSLog(@"----%@--",data);
            }
        });
    }];
}


@end
