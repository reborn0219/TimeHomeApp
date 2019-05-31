//
//  ZSY_CarAlarmVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_CarAlarmVC.h"
#import "ZSY_CarAlarmCell.h"
#import "CarManagerPresenter.h"
#import "ZSY_carWarnlistModel.h"
#import "VehicleAlertVC.h"
@interface ZSY_CarAlarmVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *page;
@end

@implementation ZSY_CarAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    self.navigationItem.title = @"报警信息";
    
    [self createTableView];
    [self createDataSource];

    if (_dataSource.count == 0) {
        
    }else {
        
        [self barButton];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
/**导航右按钮*/
- (void)barButton{
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 25, 25);
//
//    [button setTitle:@"清空" forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"汽车管家-车辆设置-删除车辆图标"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear:)];
    self.navigationItem.rightBarButtonItem = rightButton;

}

#pragma mark -- createTableView and dataSource

///tableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    ///注册
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_CarAlarmCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)createDataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray new];
    }
    _page = @"1";
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CarManagerPresenter getCarAlarmInfoWithYourCarID:_uCarID andPage:_page andBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                int page = [_page intValue];
                page++;
                _page = [NSString stringWithFormat:@"%d",page];
                
                NSDictionary *dict = (NSDictionary *)data;
                
                
                [_dataSource removeAllObjects];
                NSArray *array = [ZSY_carWarnlistModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"list"]];
                
                
                
                [_dataSource addObjectsFromArray:array];
                

                
                [selfWeak.tableView reloadData];
                
            }else {
                
//                [self showToastMsg:@"暂无数据" Duration:3.0];
            }
            
            if (_dataSource.count == 0) {
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];
                selfWeak.tableView.hidden = YES;
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
//                self.navigationItem.rightBarButtonItem = nil;

            }else {
                selfWeak.tableView.hidden = NO;
                
            }
            
        });

    }];
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSY_carWarnlistModel *carWarn = _dataSource[indexPath.row];
    
    _warnID = carWarn.ID;
    
    ZSY_CarAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.leftTitleLabel.text = carWarn.typeName;
    cell.conteneLabel.text = carWarn.content;
    
    /**
     * 时间处理
     **/
    NSArray *arr = [carWarn.systime componentsSeparatedByString:@" "];
    NSString *year = arr[0];
    NSString *time = arr[1];
    NSString *showYear = [year stringByReplacingOccurrencesOfString:@"" withString:@"/"];
    time = [time substringToIndex:5];
    
    cell.yearLabel.text = showYear;
    cell.timeLabel.text = time;
    
    if (_dataSource.count == 0) {
        
        cell.deleteButton.hidden = YES;
    }
//    cell.leftTitleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    [cell.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- 按钮点击

/**
 *导航右按钮
 **/
- (void)clear:(UIBarButtonItem *)rightBar {
    
    if (_dataSource.count != 0) {
        VehicleAlertVC * vc = [[VehicleAlertVC alloc] init];
        [vc showithTitle:@"是否清空" :self ShowCancelBtn:YES ISSuccess:NO];
        vc.block = ^(NSInteger type)
        {
            if (type == 1) {
                
                @WeakObj(self);
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                [indicator startAnimating:self.tabBarController];
                [CarManagerPresenter clearAllAlarmInfoWithBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];

                        if(resultCode == SucceedCode) {
                            
                            [selfWeak.tableView reloadData];
                            NSLog(@"已经清空");

                        }
                        
                    });
                    
                }];
                
            }
            
        };

    }else {
        
        return;
    }
    
    
    NSLog(@"清空");
}


/**
 * 删除
 **/
- (void)delete:(UIButton *)button {
    
    VehicleAlertVC * vc = [[VehicleAlertVC alloc] init];
    [vc showithTitle:@"是否删除" :self ShowCancelBtn:YES ISSuccess:NO];
    vc.block = ^(NSInteger type)
    {
        if (type == 1) {
            //删除
            
            @WeakObj(self);
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
            [indicator startAnimating:self.tabBarController];
            [CarManagerPresenter clearOneAlarmInfoWithWarnID:_warnID andBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];

                    if(resultCode == SucceedCode) {
                        
                        [selfWeak.tableView reloadData];
                        NSLog(@"删除成功");
                    }

                });
                
            }];

        }
        
    };
    
}



@end
