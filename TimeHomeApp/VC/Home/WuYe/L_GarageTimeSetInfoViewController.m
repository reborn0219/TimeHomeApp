//
//  L_GarageTimeSetInfoViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GarageTimeSetInfoViewController.h"
#import "L_GarageTimeSetTVC1.h"
#import "L_GarageTimeSetTVC2.h"
#import "ParkingManagePresenter.h"
#import "L_TimeSetInfoModel.h"
#import "L_GarageTimePopVC.h"
#import "L_GarageDaysPopVC.h"

#import "L_BikeManagerPresenter.h"

@interface L_GarageTimeSetInfoViewController () <UITableViewDelegate, UITableViewDataSource>
{
    ParkingManagePresenter *parkingPresenter;
    NSArray *titlesArray;
}
@property (nonatomic, strong) L_TimeSetInfoModel *timeSetInfoModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation L_GarageTimeSetInfoViewController

// MARK: - 自行车时间设置保存
- (void)httpRequestForChangeBikeTimeSetWithModel:(L_TimeSetInfoModel *)model {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

    [L_BikeManagerPresenter changeOpenCloseWithID:model.parkingcarid model:model UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if (resultCode == SucceedCode) {
                
                [self.navigationController popViewControllerAnimated:YES];

            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}

// MARK: - 获取自行车时间信息
- (void)httpRequestForGetBikeTimeInfoWithID:(NSString *)theID {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

    [L_BikeManagerPresenter getBikeTimeSetWithID:theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                _timeSetInfoModel = data;
                _timeSetInfoModel.parkingcarid = _bikeID;

                [_tableView reloadData];
                
            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }

            
        });
        
    }];
    
}

#pragma mark - 获取信息
- (void)httpRequestForGetTimeSetInfo {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [parkingPresenter getLockTimeSetInfoForParkingCarid:self.carModel.parkingcarid upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                _timeSetInfoModel = data;
                
                if ([XYString isBlankString:[NSString stringWithFormat:@"%@",_lockstate]]) {
                    _timeSetInfoModel.lockstate = [NSNumber numberWithInt:0];
                }else {
                    _timeSetInfoModel.lockstate = _lockstate;
                }
                
                [_tableView reloadData];
                
            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}

#pragma mark - 保存信息
- (void)httpRequestForSaveTimeSetInfo {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

    [parkingPresenter saveLockTimeSetInfoForParkingModel:_timeSetInfoModel upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if (resultCode == SucceedCode) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}

// MARK: - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = BLACKGROUND_COLOR;
    
    parkingPresenter = [ParkingManagePresenter new];
    
    _timeSetInfoModel = [[L_TimeSetInfoModel alloc] init];

    _timeSetInfoModel.opentime = @"";
    _timeSetInfoModel.opentimes = @"";
    _timeSetInfoModel.closetime = @"";
    _timeSetInfoModel.closetimes = @"";
    _timeSetInfoModel.openstate = @"0";
    _timeSetInfoModel.closestate = @"0";
    
    _timeSetInfoModel.lockstate = [NSNumber numberWithInt:0];
    
    if (!_isFromBike) {
        
        if ([XYString isBlankString:[NSString stringWithFormat:@"%@",_lockstate]]) {
            _timeSetInfoModel.lockstate = [NSNumber numberWithInt:0];
        }else {
            _timeSetInfoModel.lockstate = _lockstate;
        }
        _timeSetInfoModel.parkingcarid = _carModel.parkingcarid;
        
    }else {
        _timeSetInfoModel.parkingcarid = _bikeID;
    }
    
    titlesArray = @[@[@"定  时"],@[@"自动锁车设置",@"时  间",@"重  复"],@[@"自动解锁设置",@"时  间",@"重  复"]];
    
    self.leftHidden = YES;
    
    [self setupNavBarButtons];
    
    [self createTableView];
    
    if (!_isFromBike) {
        [self httpRequestForGetTimeSetInfo];
    }else {
        [self httpRequestForGetBikeTimeInfoWithID:_bikeID];
    }
    
    
}
// MARK: - 设置导航按钮
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
// MARK: - 导航按钮点击事件
- (void)backToLastVC:(UIButton *)button {
    
    if (button.tag == 2) {
        
        if (_timeSetInfoModel.lockstate.integerValue == 1) {
            
            if ([_timeSetInfoModel.openstate isEqualToString:@"0"] && [_timeSetInfoModel.closestate isEqualToString:@"0"]) {
                
                [self showToastMsg:@"若开启定时锁车，自动解锁和自动锁车至少要设置一项" Duration:5.0];
                return;
                
            }else {
                
                if ([_timeSetInfoModel.openstate isEqualToString:@"1"]) {
                    
                    if (([_timeSetInfoModel.opentime isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.opentime]) && ([_timeSetInfoModel.opentimes isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.opentimes])) {
                        
                        [self showToastMsg:@"请选择自动解锁的时间和日期！" Duration:3.0];
                        return;
                        
                    }else if ([_timeSetInfoModel.opentime isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.opentime]) {
                        
                        [self showToastMsg:@"请选择自动解锁时间！" Duration:3.0];
                        return;
                        
                    }else if ([_timeSetInfoModel.opentimes isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.opentimes]) {
                        
                        [self showToastMsg:@"请选择自动解锁日期！" Duration:3.0];
                        return;
                    }
                    
                }
                
                if ([_timeSetInfoModel.closestate isEqualToString:@"1"]) {
                    
                    if (([_timeSetInfoModel.closetime isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.closetime]) && ([_timeSetInfoModel.closetimes isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.closetimes])) {
                        
                        [self showToastMsg:@"请选择自动锁车的时间和日期！" Duration:3.0];
                        return;
                        
                    }else if ([_timeSetInfoModel.closetime isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.closetime]) {
                        
                        [self showToastMsg:@"请选择自动锁车时间！" Duration:3.0];
                        return;
                        
                    }else if ([_timeSetInfoModel.closetimes isEqualToString:@"请选择"] || [XYString isBlankString:_timeSetInfoModel.closetimes]) {
                        
                        [self showToastMsg:@"请选择自动锁车日期！" Duration:3.0];
                        return;
                    }
                    
                }
                
            }
            
        }
        if (!_isFromBike) {
            [self httpRequestForSaveTimeSetInfo];
        }else {
            [self httpRequestForChangeBikeTimeSetWithModel:_timeSetInfoModel];
        }
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}
// MARK: - tableview设置
- (void)createTableView {

    [_tableView registerNib:[UINib nibWithNibName:@"L_GarageTimeSetTVC1" bundle:nil] forCellReuseIdentifier:@"L_GarageTimeSetTVC1"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_GarageTimeSetTVC2" bundle:nil] forCellReuseIdentifier:@"L_GarageTimeSetTVC2"];

    
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
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
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
            if (_timeSetInfoModel.lockstate.integerValue == 0) {
                cell.right_Switch.on = NO;
            }else {
                cell.right_Switch.on = YES;
            }
        }
        if (indexPath.section == 1) {
            if (_timeSetInfoModel.closestate.integerValue == 0) {
                cell.right_Switch.on = NO;
            }else {
                cell.right_Switch.on = YES;
            }

        }
        if (indexPath.section == 2) {
            if (_timeSetInfoModel.openstate.integerValue == 0) {
                cell.right_Switch.on = NO;
            }else {
                cell.right_Switch.on = YES;
            }
        }
        
        cell.switchOnCallBack = ^(BOOL isOn) {
          
            if (indexPath.section == 0) {
                
                if (isOn) {
                    _timeSetInfoModel.lockstate = [NSNumber numberWithInt:1];
                    _timeSetInfoModel.openstate = @"1";
                    _timeSetInfoModel.closestate = @"1";
                    [_tableView reloadData];
                }else {
                    _timeSetInfoModel.lockstate = [NSNumber numberWithInt:0];
                    _timeSetInfoModel.openstate = @"0";
                    _timeSetInfoModel.closestate = @"0";
                    [_tableView reloadData];
                }
                
            }else if (indexPath.section == 2) {
                
                if (isOn) {
                    
                    _timeSetInfoModel.openstate = @"1";
                    if (_timeSetInfoModel.lockstate.integerValue == 0) {
                        _timeSetInfoModel.lockstate = [NSNumber numberWithInt:1];
                        [_tableView reloadData];
                    }
                    
                }else {
                    _timeSetInfoModel.openstate = @"0";
                    
                    if ([_timeSetInfoModel.closestate isEqualToString:@"0"]) {
                        _timeSetInfoModel.lockstate = [NSNumber numberWithInt:0];
                        [_tableView reloadData];
                    }
                }
                
            }else if (indexPath.section == 1) {
                
                if (isOn) {
                    
                    _timeSetInfoModel.closestate = @"1";
                    if (_timeSetInfoModel.lockstate.integerValue == 0) {
                        _timeSetInfoModel.lockstate = [NSNumber numberWithInt:1];
                        [_tableView reloadData];
                    }
                    
                }else {
                    _timeSetInfoModel.closestate = @"0";
                    if ([_timeSetInfoModel.openstate isEqualToString:@"0"]) {
                        _timeSetInfoModel.lockstate = [NSNumber numberWithInt:0];
                        [_tableView reloadData];
                    }
                }
                
            }
            
        };
        
        return cell;
        
    }else {
        
        L_GarageTimeSetTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_GarageTimeSetTVC2"];
        cell.leftTitle_Label.text = titlesArray[indexPath.section][indexPath.row];

        if (indexPath.section == 2) {
            
            if (indexPath.row == 1) {
                cell.rightDetail_Label.text = [XYString IsNotNull:_timeSetInfoModel.opentime withString:@"请选择"];
            }else if (indexPath.row == 2) {
                
                if ([XYString isBlankString:_timeSetInfoModel.opentimes]) {
                    cell.rightDetail_Label.text = @"请选择";
                }else {
                    cell.rightDetail_Label.text = [XYString dayNumToString:_timeSetInfoModel.opentimes];
                }
            }
            
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == 1) {
                cell.rightDetail_Label.text = [XYString IsNotNull:_timeSetInfoModel.closetime withString:@"请选择"];
            }else if (indexPath.row == 2) {
                
                if ([XYString isBlankString:_timeSetInfoModel.closetimes]) {
                    cell.rightDetail_Label.text = @"请选择";
                }else {
                    cell.rightDetail_Label.text = [XYString dayNumToString:_timeSetInfoModel.closetimes];
                }
                
            }
            
        }
        
        return cell;
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        if ([_timeSetInfoModel.openstate isEqualToString:@"0"]) {
            [self showToastMsg:@"请开启自动解锁设置按钮" Duration:3.0];
            return;
        }
        
        if (indexPath.row == 1) {
            

            
            NSString *hour = [XYString NSDateToString:[NSDate date] withFormat:@"HH"];
            NSString *minute = [XYString NSDateToString:[NSDate date] withFormat:@"mm"];

            if (![XYString isBlankString:_timeSetInfoModel.opentime]) {
                NSArray *arr = [_timeSetInfoModel.opentime componentsSeparatedByString:@":"];
                if (arr.count == 2) {
                    hour = arr[0];
                    minute = arr[1];
                }
                
            }
            
            L_GarageTimePopVC *garageTimePopVC = [L_GarageTimePopVC getInstance];
            [garageTimePopVC showVC:self withHour:hour withMinute:minute cellEvent:^(NSString *timeString) {
               
                NSLog(@"timeString==%@",timeString);
                _timeSetInfoModel.opentime = timeString;
                [_tableView reloadData];
                
            }];
            
        }
        if (indexPath.row == 2) {

            L_GarageDaysPopVC *dayPopVC = [L_GarageDaysPopVC getInstance];
            [dayPopVC showVC:self withDay:_timeSetInfoModel.opentimes cellEvent:^(NSString *days) {
               
                _timeSetInfoModel.opentimes = days;
                [_tableView reloadData];
                
            }];
            
        }
    }
    
    if (indexPath.section == 1) {
        
        if ([_timeSetInfoModel.closestate isEqualToString:@"0"]) {
            [self showToastMsg:@"请开启自动锁车设置按钮" Duration:3.0];
            return;
        }
        
        if (indexPath.row == 1) {
            NSString *hour = [XYString NSDateToString:[NSDate date] withFormat:@"HH"];
            NSString *minute = [XYString NSDateToString:[NSDate date] withFormat:@"mm"];
            
            if (![XYString isBlankString:_timeSetInfoModel.closetime]) {
                NSArray *arr = [_timeSetInfoModel.closetime componentsSeparatedByString:@":"];
                if (arr.count == 2) {
                    hour = arr[0];
                    minute = arr[1];
                }

            }
            
            L_GarageTimePopVC *garageTimePopVC = [L_GarageTimePopVC getInstance];
            [garageTimePopVC showVC:self withHour:hour withMinute:minute cellEvent:^(NSString *timeString) {
                
                NSLog(@"timeString==%@",timeString);
                _timeSetInfoModel.closetime = timeString;
                [_tableView reloadData];

            }];
            
        }
        if (indexPath.row == 2) {
            
            
            L_GarageDaysPopVC *dayPopVC = [L_GarageDaysPopVC getInstance];
            [dayPopVC showVC:self withDay:_timeSetInfoModel.closetimes cellEvent:^(NSString *days) {
                
                _timeSetInfoModel.closetimes = days;
                [_tableView reloadData];
                
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
