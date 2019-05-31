//
//  MySettingsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MySettingsViewController.h"
#import "MineTVC.h"
#import "THMyHouseAuthorityViewController.h"
#import "THMyCarAuthorityListVC.h"

#import "THMyNoticesSettingVC.h"

#import "THMotifyPwdViewController.h"
#import "THAboutUsViewController.h"

#import "NSData+SDDataCache.h"

#import "LoginVC.h"

#import "FilePresenters.h"
#import "SignUpVC.h"
#import "DateUitls.h"
#import "PANoticeManager.h"
#import "AppDelegate+JPush.h"
@interface MySettingsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *leftImages;
    NSArray *leftTitles;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MySettingsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"shezhi"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":SheZhi}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
//    [TalkingData trackPageBegin:@"shezhi"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:SheZhi];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    leftTitles = @[@[@"消息通知",@"签到设置",@"修改密码",@"清理缓存"],@[@"关于我们"]];
    leftImages = @[@[@"消息",@"签到设置",@"我的_设置_修改密码",@"我的_设置_清理缓存"],@[@"我的_设置_关于我们"]];
//    leftTitles = @[@[@"消息通知",@"修改密码",@"清理缓存"],@[@"关于我们"]];
//    leftImages = @[@[@"消息",@"我的_设置_修改密码",@"我的_设置_清理缓存"],@[@"我的_设置_关于我们"]];
    [self createTableView];


}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[MineTVC class] forCellReuseIdentifier:NSStringFromClass([MineTVC class])];
    
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return leftTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [leftTitles[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    if (section == 1) {
        UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logOutButton setBackgroundColor:kNewRedColor];
        [logOutButton setTitle:@"退  出  登  录" forState:UIControlStateNormal];
        logOutButton.titleLabel.font = DEFAULT_BOLDFONT(16);
        [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:logOutButton];
        [logOutButton addTarget:self action:@selector(logOutClick) forControlEvents:UIControlEventTouchUpInside];
        [logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(20);
            make.width.equalTo(@(WidthSpace(584)));
            make.height.equalTo(@(WidthSpace(80)));
            make.centerX.equalTo(view.mas_centerX);
        }];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineTVC class])];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftImageView.image = [UIImage imageNamed:leftImages[indexPath.section][indexPath.row]];
    cell.titleLabel.text = leftTitles[indexPath.section][indexPath.row];
    
    cell.accessoryImage.hidden = NO;
//    if (indexPath.section == 1) {
//        cell.accessoryImage.hidden = YES;
//    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            /**
             消息通知
             */
            THMyNoticesSettingVC *myNoticeSettingVC = [[THMyNoticesSettingVC alloc]init];
            [self.navigationController pushViewController:myNoticeSettingVC animated:YES];
            
        }
        
        if (indexPath.row == 1) {
            //签到设置
            SignUpVC *signUpVC = [[SignUpVC alloc]init];
            [self.navigationController pushViewController:signUpVC animated:YES];
        }
        if (indexPath.row == 2) {
            //修改密码
            THMotifyPwdViewController *motifyVC = [[THMotifyPwdViewController alloc]init];
            [self.navigationController pushViewController:motifyVC animated:YES];
        }
        if (indexPath.row == 3) {
            //提示清理内存
            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
            
            [alertVC ShowAlert:self Title:@"温馨提示" Msg:[NSString stringWithFormat:@"缓存大小为%.1fM，是否清理",[FilePresentersManager filePath]] oneBtn:@"取消" otherBtn:@"确定"];

            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                
                if (index == 1000) {
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                    //确定
                    [FilePresentersManager clearFileWithBlock:^(NSInteger success) {
                        
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                        [self showToastMsg:@"清理成功" Duration:3.0];
                        
                    }];

                }
                
            };
        }
    }
    if (indexPath.section == 1) {
        
        THAboutUsViewController *aboutUs = [[THAboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUs animated:YES];

    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;

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


/**
 退出登录
 */
- (void)logOutClick {
    
    //退出登录
    [self isBeyonbdDays];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
    UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate setTags:nil error:nil];
    appdelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
    appdelegate.userData.token = @"";
    [appdelegate saveContext];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
    [shared setObject:appdelegate.userData.token forKey:@"widget"];
    [shared synchronize];

    appdelegate.window.rootViewController = loginVC;
    
    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
    [loginVC.view.window.layer addAnimation:animation forKey:nil];
    
    [PANoticeManager unBindDeviceInfo];/// 解绑推送设备信息
}



- (void)isBeyonbdDays {
    NSString *nowTimeStr = [DateUitls getTodayDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *beginTime = [userDefaults objectForKey:@"beginLoginTime"];
    NSInteger days = [DateUitls calcDaysFromBeginForString:nowTimeStr today:beginTime];
//    NSInteger daysssss = [[self intervalFromLastDate:beginTime toTheDate:nowTimeStr] integerValue];
    
    if (days > 60) {
        AppDelegate *appdelget = GetAppDelegates;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"clearPassWord"];
        [userDefaults synchronize];
        appdelget.userData.isLogIn = @NO;
        [appdelget saveContext];
    }
}

- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //        min = [min substringToIndex:min.length-7];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //        min = [min substringToIndex:min.length-7];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    //        house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    return min;
}

@end
