//
//  THMyNoticesSettingVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyNoticesSettingVC.h"
#import "YYNoticeSetTVC1.h"
#import "YYNoticeSetTVC2.h"
#import "YYNoticeSetPresent.h"

@interface THMyNoticesSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *leftTitles;

@property (nonatomic, strong) AppNoticeSet *appNoticeSet;

@end

@implementation THMyNoticesSettingVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":SheZhi}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:SheZhi];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"消息通知";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setupData];                       //初始化数据
        
        [self createTableView];
        
        [self httpRequestForSettingInfos];      //获得推送消息的设置
        
    });

}
/**
 *  保存推送消息的设置
 */
- (void)saveNoticeInfoWithAppNoticeSet:(AppNoticeSet *)appNoticeSet {
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    [YYNoticeSetPresent saveAppMsgsetWithAppNoticeSet:appNoticeSet UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                
            }else {
                [selfWeak showToastMsg:@"保存失败" Duration:3.0];
            }
            
        });
        
    }];
    
}

/**
 *  获得推送消息的设置
 */
- (void)httpRequestForSettingInfos {
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [YYNoticeSetPresent getAppMsgsetUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                selfWeak.appNoticeSet = data;
                if (selfWeak.appNoticeSet == nil) {
                    selfWeak.appNoticeSet = [[AppNoticeSet alloc]init];
                    selfWeak.appNoticeSet.chatreceive = @"1";
                    selfWeak.appNoticeSet.chatdetails = @"1";
                    selfWeak.appNoticeSet.voiceopen = @"1";
                    selfWeak.appNoticeSet.shockopen = @"1";
                    selfWeak.appNoticeSet.nightopen = @"1";
                    selfWeak.appNoticeSet.carremind = @"1";

                }
                [selfWeak.tableView reloadData];
            }
            if (resultCode == FailureCode) {
                if (selfWeak.appNoticeSet == nil) {
                    selfWeak.appNoticeSet = [[AppNoticeSet alloc]init];
                    selfWeak.appNoticeSet.chatreceive = @"1";
                    selfWeak.appNoticeSet.chatdetails = @"1";
                    selfWeak.appNoticeSet.voiceopen = @"1";
                    selfWeak.appNoticeSet.shockopen = @"1";
                    selfWeak.appNoticeSet.nightopen = @"1";
                    selfWeak.appNoticeSet.carremind = @"1";

                }
                [selfWeak.tableView reloadData];
            }

        });
        
    }];
    
}

/**
 *  初始化数据
 */
- (void)setupData {
    
    _leftTitles = @[@[@"接收消息通知",@"通知显示消息详情"],@[@"声音",@"震动",@"夜间免打扰"],@[@"车辆防盗报警"]];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"YYNoticeSetTVC1" bundle:nil] forCellReuseIdentifier:NSStringFromClass([YYNoticeSetTVC1 class])];
    [_tableView registerNib:[UINib nibWithNibName:@"YYNoticeSetTVC2" bundle:nil] forCellReuseIdentifier:NSStringFromClass([YYNoticeSetTVC2 class])];

    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _leftTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_leftTitles[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48;
    }
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *bgView = [[UIView alloc]init];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [bgView addSubview:titleLabel];
        titleLabel.font = DEFAULT_FONT(16);
        titleLabel.text = @"聊天消息";
        titleLabel.textColor = TITLE_TEXT_COLOR;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(bgView).offset(5);
            make.top.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.right.equalTo(bgView);
            
        }];
        
        return bgView;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 75;
        }else {
            return 48;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            return 75;
        }else {
            return 48;
        }
    }
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        YYNoticeSetTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYNoticeSetTVC2 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTopTitleLabel.text = _leftTitles[indexPath.section][indexPath.row];
        
        cell.leftBottomDetailLabel.text = @"关闭后，消息通知将不显示发信人和内容摘要";
        
        if ([_appNoticeSet.chatdetails isEqualToString:@"0"]) {
            [cell.rightSwitch setOn:NO];
        }else {
            [cell.rightSwitch setOn:YES];
        }
        
        cell.switchClick = ^(BOOL isOpen) {
          
            NSLog(@"====%d",isOpen);
            if (isOpen) {
                _appNoticeSet.chatdetails = @"1";
            }else {
                _appNoticeSet.chatdetails = @"0";
            }
            
            [selfWeak saveNoticeInfoWithAppNoticeSet:_appNoticeSet];
            
        };
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        
        YYNoticeSetTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYNoticeSetTVC2 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTopTitleLabel.text = _leftTitles[indexPath.section][indexPath.row];

        cell.leftBottomDetailLabel.text = @"开启后，将自动屏蔽22：00-07：00时间的任何提醒";
        
        if ([_appNoticeSet.nightopen isEqualToString:@"0"]) {
            [cell.rightSwitch setOn:NO];
        }else {
            [cell.rightSwitch setOn:YES];
        }
        
        cell.switchClick = ^(BOOL isOpen) {
            
            NSLog(@"====%d",isOpen);
            if (isOpen) {
                _appNoticeSet.nightopen = @"1";
            }else {
                _appNoticeSet.nightopen = @"0";
            }
            [selfWeak saveNoticeInfoWithAppNoticeSet:_appNoticeSet];

        };
        
        return cell;
        
    }else {
        
        YYNoticeSetTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYNoticeSetTVC1 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTitleLabel.text = _leftTitles[indexPath.section][indexPath.row];

        if (indexPath.section == 0 && indexPath.row == 0) {
            if ([_appNoticeSet.chatreceive isEqualToString:@"0"]) {
                [cell.rightSwitch setOn:NO];
            }else {
                [cell.rightSwitch setOn:YES];
            }
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            if ([_appNoticeSet.voiceopen isEqualToString:@"0"]) {
                [cell.rightSwitch setOn:NO];
            }else {
                [cell.rightSwitch setOn:YES];
            }
        }
        if (indexPath.section == 1 && indexPath.row == 1) {
            if ([_appNoticeSet.shockopen isEqualToString:@"0"]) {
                [cell.rightSwitch setOn:NO];
            }else {
                [cell.rightSwitch setOn:YES];
            }
        }
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            if ([_appNoticeSet.carremind isEqualToString:@"0"]) {
                [cell.rightSwitch setOn:NO];
            }else {
                [cell.rightSwitch setOn:YES];
            }
        }
        
        cell.switchClick = ^(BOOL isOpen) {
            
            NSLog(@"====%d",isOpen);
            
            if (indexPath.section == 0 && indexPath.row == 0) {
                if (isOpen) {
                    _appNoticeSet.chatreceive = @"1";
                }else {
                    _appNoticeSet.chatreceive = @"0";
                }
            }
            if (indexPath.section == 1 && indexPath.row == 0) {
                if (isOpen) {
                    _appNoticeSet.voiceopen = @"1";
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kCloseSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }else {
                    _appNoticeSet.voiceopen = @"0";
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCloseSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }

            }
            if (indexPath.section == 1 && indexPath.row == 1) {
                if (isOpen) {
                    _appNoticeSet.shockopen = @"1";
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kCloseShakeOrNot];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else {
                    _appNoticeSet.shockopen = @"0";
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCloseShakeOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            
            if (indexPath.section == 2 && indexPath.row == 0) {
                if (isOpen) {
                    _appNoticeSet.carremind = @"1";
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kAlertSoundOrNot];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else {
                    _appNoticeSet.carremind = @"0";
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kAlertSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }

            }
            
            [selfWeak saveNoticeInfoWithAppNoticeSet:_appNoticeSet];

        };
        
        return cell;
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


@end
