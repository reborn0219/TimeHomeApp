//
//  PATimingLockCarViewController.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PATimingLockCarViewController.h"
#import "L_GarageTimeSetTVC1.h"
#import "L_GarageTimeSetTVC2.h"
#import "ParkingManagePresenter.h"
#import "PALockCarModel.h"
#import "L_GarageTimePopVC.h"
#import "L_GarageDaysPopVC.h"
#import "PAUpdateTimingLockCarInfoRequest.h"
#import "PALockCarInfoService.h"

@interface PATimingLockCarViewController ()<UITableViewDelegate, UITableViewDataSource,PALockCompleteDelegate>

@property (nonatomic, strong) UITableView  * paTableView;
@property (nonatomic, strong) PALockCarModel * lockModel;
@property (nonatomic, strong) PALockCarInfoService *paService;
@end

@implementation PATimingLockCarViewController{
    NSArray *titlesArray;
}

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    titlesArray = @[@[@"定  时"],@[@"自动锁车设置",@"时  间",@"重  复"],@[@"自动解锁设置",@"时  间",@"重  复"]];
    
    self.leftHidden = YES;
    [self.view addSubview:self.paTableView];
    [self setupNavBarButtons];
    self.paService = [[PALockCarInfoService alloc]init];
    self.paService.delegagte = self;
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [self.paService loadData:self.vehicleModel.vehicleID];
    
}

#pragma mark - initUI
-(UITableView *)paTableView
{
    if (!_paTableView) {
        
        _paTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _paTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _paTableView.backgroundColor = BLACKGROUND_COLOR;
        _paTableView.delegate = self;
        _paTableView.dataSource = self;
        [_paTableView registerNib:[UINib nibWithNibName:@"L_GarageTimeSetTVC1" bundle:nil] forCellReuseIdentifier:@"L_GarageTimeSetTVC1"];
        [_paTableView registerNib:[UINib nibWithNibName:@"L_GarageTimeSetTVC2" bundle:nil] forCellReuseIdentifier:@"L_GarageTimeSetTVC2"];
    }
    return _paTableView;
}

#pragma mark -  设置导航按钮
- (void)setupNavBarButtons {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 35, 30);
    [leftButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    leftButton.tag = 1;
    leftButton.titleLabel.font = DEFAULT_FONT(15);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToLastVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    rightButton.tag = 2;
    rightButton.titleLabel.font = DEFAULT_FONT(15);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backToLastVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

#pragma mark - Request
-(void)requestDataCompleted{
    
    [[THIndicatorVC sharedTHIndicatorVC]stopAnimating];
    self.lockModel = self.paService.lockModel;
    self.lockModel.autoLockCarTime = [self.lockModel.autoLockCarTime substringToIndex:5];
    self.lockModel.autoUnlockCarTime = [self.lockModel.autoUnlockCarTime substringToIndex:5];
    [self gearingStateSetting];
    
}
-(void)requestSaveCompleted:(NSInteger)type{
    
    [[THIndicatorVC sharedTHIndicatorVC]stopAnimating];
    
    if (type==1) {
        ///成功
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        ///失败
        [self showToastMsg:@"保存失败！" Duration:2.5f];
    }
}
#pragma mark - 保存锁车数据
- (void)requestForSaveTimingInfo {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [self.paService saveLockModel:self.lockModel];
    
}

#pragma mark - Actions

-(void)changeLockState:(NSInteger)section isOn:(BOOL)isOn
{
    if (section == 0) {
        if (isOn) {
            
            self.lockModel.lockstate = @"1";
            self.lockModel.autoLockCarSwitch = @"1";
            self.lockModel.autoUnlockCarSwitch = @"1";
            
        }else{
            
            self.lockModel.lockstate = @"0";
            self.lockModel.autoLockCarSwitch = @"0";
            self.lockModel.autoUnlockCarSwitch = @"0";
        }
        [self.paTableView reloadData];
        
    }else if (section == 1){
        
        if (isOn) {
            self.lockModel.autoLockCarSwitch = @"1";
        }else{
            self.lockModel.autoLockCarSwitch = @"0";
        }
        [self gearingStateSetting];
        
    }else if (section == 2){
        if (isOn) {
            self.lockModel.autoUnlockCarSwitch = @"1";
        }else{
            self.lockModel.autoUnlockCarSwitch = @"0";
        }
        [self gearingStateSetting];
    }
}
#pragma mark -状态联动  当解锁和锁车开关有一个为开启时 总开关开启
-(void)gearingStateSetting
{
    ///设置总开关状态联动
    if (self.lockModel.autoLockCarSwitch.integerValue==1||self.lockModel.autoUnlockCarSwitch.integerValue==1) {
        self.lockModel.lockstate = @"1";
    }else{
        self.lockModel.lockstate = @"0";
    }
    [self.paTableView reloadData];
    
}
- (void)backToLastVC:(UIButton *)button {
    
    if (button.tag == 2) {
        
        if ([self.lockModel.autoLockCarSwitch isEqualToString:@"0"] && [self.lockModel.autoUnlockCarSwitch isEqualToString:@"0"]) {
            
           
            
        }else {
            
            if ([self.lockModel.autoLockCarSwitch isEqualToString:@"1"]) {
                
                if (([self.lockModel.autoLockCarTime isEqualToString:@"请选择"] || ![self.lockModel.autoLockCarTime isNotBlank]) && ([self.lockModel.autoLockCarRule isEqualToString:@"请选择"] || ![self.lockModel.autoLockCarRule isNotBlank])) {
                    
                    [self showToastMsg:@"请选择自动锁车的时间和日期！" Duration:3.0];
                    return;
                    
                }else if ([self.lockModel.autoLockCarTime isEqualToString:@"请选择"] || ![self.lockModel.autoLockCarTime isNotBlank]) {
                    
                    [self showToastMsg:@"请选择自动锁车时间！" Duration:3.0];
                    return;
                    
                }else if ([self.lockModel.autoLockCarRule
                           isEqualToString:@"请选择"] || ![self.lockModel.autoLockCarRule isNotBlank]) {
                    
                    [self showToastMsg:@"请选择自动锁车日期！" Duration:3.0];
                    return;
                }
                
            }
            
            if ([self.lockModel.autoUnlockCarSwitch isEqualToString:@"1"]) {
                
                if (([self.lockModel.autoUnlockCarTime isEqualToString:@"请选择"] || ![self.lockModel.autoUnlockCarTime isNotBlank]) && ([self.lockModel.autoUnlockCarRule isEqualToString:@"请选择"] || ![self.lockModel.autoUnlockCarRule isNotBlank])) {
                    
                    [self showToastMsg:@"请选择自动解锁的时间和日期！" Duration:3.0];
                    return;
                    
                }else if ([self.lockModel.autoUnlockCarTime isEqualToString:@"请选择"] ||![self.lockModel.autoUnlockCarTime isNotBlank]) {
                    
                    [self showToastMsg:@"请选择自动解锁时间！" Duration:3.0];
                    return;
                    
                }else if ([self.lockModel.autoUnlockCarRule isEqualToString:@"请选择"] || ![self.lockModel.autoUnlockCarRule isNotBlank]) {
                    
                    [self showToastMsg:@"请选择自动解锁日期！" Duration:3.0];
                    return;
                }
                
            }
            
        }
        [self requestForSaveTimingInfo];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    }
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.paTableView.frame.size.width, 50)];
    bgView.backgroundColor = BLACKGROUND_COLOR;
    
    if (section == 0) {
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = BLACKGROUND_COLOR;
        label.text = @"您可以自主设置每辆车的自动锁车和自动解锁的时间";
        label.textColor = kNewRedColor;
        label.numberOfLines = 0;
        label.font = DEFAULT_FONT(15);
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.left.equalTo(bgView).offset(15);
            make.right.equalTo(bgView).offset(-5);
            
        }];
        
    }
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        L_GarageTimeSetTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_GarageTimeSetTVC1"];
        cell.leftTitle_Label.text = titlesArray[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            
            cell.right_Switch.on = self.lockModel.lockstate.boolValue;
            
        }else if (indexPath.section == 1) {
            
            cell.right_Switch.on = self.lockModel.autoLockCarSwitch.boolValue;
            
        }else if (indexPath.section == 2) {
            cell.right_Switch.on = self.lockModel.autoUnlockCarSwitch.boolValue;
        }
        
        cell.switchOnCallBack = ^(BOOL isOn) {
            
            [self changeLockState:indexPath.section isOn:isOn];
        };
        
        return cell;
        
    }else {
        
        L_GarageTimeSetTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_GarageTimeSetTVC2"];
        cell.leftTitle_Label.text = titlesArray[indexPath.section][indexPath.row];
        
        if (indexPath.section == 1) {
            
            if (indexPath.row == 1) {
                cell.rightDetail_Label.text = [XYString IsNotNull:self.lockModel.autoLockCarTime withString:@"请选择"];
            }else if (indexPath.row == 2) {
                
                if ([XYString isBlankString:self.lockModel.autoLockCarRule]) {
                    cell.rightDetail_Label.text = @"请选择";
                }else {
                    cell.rightDetail_Label.text = [XYString dayNumToString:self.lockModel.autoLockCarRule];
                }
            }
            
        }else if (indexPath.section == 2) {
            
            if (indexPath.row == 1) {
                cell.rightDetail_Label.text = [XYString IsNotNull:self.lockModel.autoUnlockCarTime withString:@"请选择"];
            }else if (indexPath.row == 2) {
                
                if ([XYString isBlankString:self.lockModel.autoUnlockCarRule]) {
                    cell.rightDetail_Label.text = @"请选择";
                }else {
                    cell.rightDetail_Label.text = [XYString dayNumToString:self.lockModel.autoUnlockCarRule];
                }
                
            }
            
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        if ([self.lockModel.autoLockCarSwitch isEqualToString:@"0"]) {
            [self showToastMsg:@"请开启自动锁车设置按钮" Duration:3.0];
            return;
        }
        if (indexPath.row == 1) {
            
            NSString *hour = [XYString NSDateToString:[NSDate date] withFormat:@"HH"];
            NSString *minute = [XYString NSDateToString:[NSDate date] withFormat:@"mm"];
            
            if (![XYString isBlankString:self.lockModel.autoLockCarTime]) {
                NSArray *arr = [self.lockModel.autoLockCarTime componentsSeparatedByString:@":"];
                if (arr.count == 2) {
                    hour = arr[0];
                    minute = arr[1];
                }
                
            }
            L_GarageTimePopVC *garageTimePopVC = [L_GarageTimePopVC getInstance];
            [garageTimePopVC showVC:self withHour:hour withMinute:minute cellEvent:^(NSString *timeString) {
                
                self.lockModel.autoLockCarTime = timeString;
                [self.paTableView reloadData];
                
            }];
            
        }
        if (indexPath.row == 2) {
            
            L_GarageDaysPopVC *dayPopVC = [L_GarageDaysPopVC getInstance];
            [dayPopVC showVC:self withDay:self.lockModel.autoLockCarRule cellEvent:^(NSString *days) {
                
                self.lockModel.autoLockCarRule = days;
                [self.paTableView reloadData];
                
            }];
            
        }
    }
    
    if (indexPath.section == 2) {
        
        if ([self.lockModel.autoUnlockCarSwitch isEqualToString:@"0"]) {
            [self showToastMsg:@"请开启自动解锁设置按钮" Duration:3.0];
            return;
        }
        
        if (indexPath.row == 1) {
            NSString *hour = [XYString NSDateToString:[NSDate date] withFormat:@"HH"];
            NSString *minute = [XYString NSDateToString:[NSDate date] withFormat:@"mm"];
            
            if (![XYString isBlankString:self.lockModel.autoUnlockCarTime]) {
                NSArray *arr = [self.lockModel.autoUnlockCarTime componentsSeparatedByString:@":"];
                if (arr.count == 2) {
                    hour = arr[0];
                    minute = arr[1];
                }
                
            }
            
            L_GarageTimePopVC *garageTimePopVC = [L_GarageTimePopVC getInstance];
            [garageTimePopVC showVC:self withHour:hour withMinute:minute cellEvent:^(NSString *timeString) {
                
                NSLog(@"timeString==%@",timeString);
                self.lockModel.autoUnlockCarTime = timeString;
                [self.paTableView reloadData];
                
            }];
            
        }
        if (indexPath.row == 2) {
            
            
            L_GarageDaysPopVC *dayPopVC = [L_GarageDaysPopVC getInstance];
            [dayPopVC showVC:self withDay:self.lockModel.autoUnlockCarRule cellEvent:^(NSString *days) {
                
                self.lockModel.autoUnlockCarRule = days;
                [self.paTableView reloadData];
                
            }];
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 16;
    
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
