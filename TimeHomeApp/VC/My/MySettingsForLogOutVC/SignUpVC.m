//
//  SignUpVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/7/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SignUpVC.h"
#import "SignUpCell.h"
#import "RaiN_NewSigninPresenter.h"
@interface SignUpVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSUserDefaults * userDefaults;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *rightData;
@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"签到设置";
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self createTableView];
    [self createData];
}


//MARK: - 创建数据源以及列表
- (void)createData {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    [_dataSource addObjectsFromArray:@[@"开启签到悬浮提醒",@"开启每日签到弹窗"]];
    
    
    if (!_rightData) {
        _rightData = [[NSMutableArray alloc] init];
    }
    
    @WeakObj(self)
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:nil];
    [RaiN_NewSigninPresenter getUserSignsetWithupdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {

                [userDefaults setObject:data[@"map"][@"issuspendremind"] forKey:[DataDealUitls getSetingKey:XuanfuBtn]];//悬浮按钮
                [userDefaults setObject:data[@"map"][@"isdailypopups"] forKey:[DataDealUitls getSetingKey:TankuangAlert]];//弹窗
                
                
                [_rightData addObjectsFromArray:@[data[@"map"][@"issuspendremind"],data[@"map"][@"isdailypopups"]]];
                [userDefaults synchronize];
            }else {
                [userDefaults setObject:@"0" forKey:[DataDealUitls getSetingKey:TankuangAlert]];
                [userDefaults setObject:@"0" forKey:[DataDealUitls getSetingKey:XuanfuBtn]];
                [userDefaults synchronize];
                [_rightData addObject:@"0"];
                [_rightData addObject:@"0"];
                [userDefaults synchronize];
            }
            [selfWeak.tableView reloadData];
        });
    }];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, SCREEN_HEIGHT - 8) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"SignUpCell" bundle:nil] forCellReuseIdentifier:@"SignUpCell"];
}

//MARK: - 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignUpCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftTitle.text = _dataSource[indexPath.row];
    if (_rightData.count <= 0) {
        return cell;
    }
    if ([_rightData[indexPath.row] integerValue] == 0) {
        cell.rightSwitch.on = NO;
    }else if ([_rightData[indexPath.row] integerValue] == 1) {
        cell.rightSwitch.on = YES;
    }
    
    if (indexPath.row == _dataSource.count - 1) {
        cell.lineLabel.hidden = YES;
    }else {
        cell.lineLabel.hidden = NO;
    }
    
    ///到悬浮提醒
    if (indexPath.row == 0) {
        
        cell.switchBlock = ^(BOOL isOpen) {
            
            NSLog(@"====%d",isOpen);
            if (isOpen) {
                ///点击打开
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                @WeakObj(self)
                [RaiN_NewSigninPresenter saveUsersignsetWithIsdailypopups:[NSString stringWithFormat:@"%@",_rightData[1]] andIssuspendremind:@"1" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        if(resultCode==SucceedCode)
                        {
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"1"];
                            [userDefaults setObject:@"1" forKey:[DataDealUitls getSetingKey:XuanfuBtn]];
                            [userDefaults synchronize];
                            
                        }else {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                            }else {
                                [selfWeak showToastMsg:data Duration:3.0f];
                            }
                            
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"0"];
                            [userDefaults synchronize];
                        }
                        NSIndexPath *thePath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                        NSArray *pathArr = @[thePath];
                        [_tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
                        
                    });
                }];
                
            }else {
                ///点击关闭
                
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                @WeakObj(self)
                [RaiN_NewSigninPresenter saveUsersignsetWithIsdailypopups:[NSString stringWithFormat:@"%@",_rightData[1]] andIssuspendremind:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [indicator stopAnimating];
                        if(resultCode==SucceedCode)
                        {
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"0"];
                            [userDefaults setObject:@"0" forKey:[DataDealUitls getSetingKey:XuanfuBtn]];
                            [userDefaults synchronize];
                            
                        }else {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                            }else {
                                [selfWeak showToastMsg:data Duration:3.0f];
                            }
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"1"];
                            [userDefaults synchronize];
                        }
                        NSIndexPath *thePath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                        NSArray *pathArr = @[thePath];
                        [_tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
                    });

                }];
            }
        };

        
        
        ///签到弹窗
    }else if (indexPath.row == 1) {
        
        cell.switchBlock = ^(BOOL isOpen) {
            NSLog(@"====%d",isOpen);
            if (isOpen) {
                ///点击打开
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                @WeakObj(self)
                [RaiN_NewSigninPresenter saveUsersignsetWithIsdailypopups:@"1" andIssuspendremind:[NSString stringWithFormat:@"%@",_rightData[0]] updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        if(resultCode==SucceedCode)
                        {
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"1"];
                            [userDefaults setObject:@"1" forKey:[DataDealUitls getSetingKey:TankuangAlert]];
                            [userDefaults synchronize];
                            
                        }else {
                            [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"0"];
                            [userDefaults synchronize];
                        }
                        NSIndexPath *thePath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                        NSArray *pathArr = @[thePath];
                        [_tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
                        
                    });
                }];

            }else {
                ///点击关闭
                
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                @WeakObj(self)
                [RaiN_NewSigninPresenter saveUsersignsetWithIsdailypopups:@"0" andIssuspendremind:[NSString stringWithFormat:@"%@",_rightData[0]] updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        if(resultCode==SucceedCode)
                        {
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"0"];
                            [userDefaults setObject:@"0" forKey:[DataDealUitls getSetingKey:TankuangAlert]];
                            [userDefaults synchronize];
                            
                        }else {
                            [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                            [_rightData replaceObjectAtIndex:indexPath.row withObject:@"1"];
                            [userDefaults synchronize];
                        }
                        NSIndexPath *thePath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                        NSArray *pathArr = @[thePath];
                        [_tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
                        
                    });
                }];
            }
        };
    }
    return cell;
}

@end
