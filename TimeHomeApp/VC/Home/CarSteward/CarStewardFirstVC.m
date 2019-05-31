//
//  CarStewardFirstVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarStewardFirstVC.h"
#import "CarStewardCell1.h"
#import "CarStewardCell2.h"
#import "CarStewardCell3.h"
#import "CarStewardCell5.h"
#import "VehicleManagementVC.h"

#import "AddCarController.h"

#import "CarDetectionController.h"
#import "FuelConsumptionViewController.h"
#import "OBDDetails.h"
#import "PopListVC.h"
#import "ShowMapVC.h"
#import "GetAddressMapVC.h"
#import "rightPushCarNumber.h"
#import "CarPositioning.h"
#import "ZSY_CarAlarmVC.h"

#import "ZSY_CarHomePageShowModel.h"
#import "CarManagerPresenter.h"
#import "DateUitls.h"
#import "DateTimeUtils.h"

#define W [UIScreen mainScreen].bounds.size.width/4
@interface CarStewardFirstVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    
    ///省简称数组
    NSArray *provinceArray;
    ///字母数组
    NSMutableArray *charArray;
    
    NSString * first;
    NSString * second;
    
    NSString * Carnum;
    NSString * Remarks;
    
    NSTimer * _NSTimer;
    

}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)ZSY_CarHomePageShowModel *model;
@property (nonatomic, strong)UITableView * dropDownTableView;
@property (nonatomic, strong)NSMutableArray * dropDownDataSource;
@property (nonatomic, strong)NSMutableArray * rightDataSource;

@property (nonatomic, strong)UIView *myView;
@property (nonatomic , strong)UIView *gesturesView;

/** 
 * cell2
 **/
@property (nonatomic, strong)NSMutableArray *cell2LeftLabel;
@property (nonatomic, strong)NSMutableArray *cell2LeftEngLabel;
@property (nonatomic, strong)NSMutableArray *cell2LeftImage;

@property (nonatomic, strong)NSMutableArray *cell2RightLabel;
@property (nonatomic, strong)NSMutableArray *cell2RightEngLabel;
@property (nonatomic, strong)NSMutableArray *cell2RightImage;

/**
 * cell4
 **/
@property (nonatomic, strong)NSMutableArray *cell4LeftImage;
@property (nonatomic, strong)NSMutableArray *cell4LeftLabel;
@property (nonatomic, strong)NSMutableArray *cell4RightButton;

@property (nonatomic , strong)rightPushCarNumber *rightView; //点击切换按钮弹出的view

@end

@implementation CarStewardFirstVC

#pragma --------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"汽车管家";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.rightBarButtonItem = [self barButton];
    [self createTableView];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"switchCarTongZhi" object:nil];
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_NSTimer invalidate];

    _NSTimer = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_NSTimer invalidate];
    _NSTimer = nil;
//    [TalkingData trackPageEnd:@"qicheguanjia"];
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self createRightDataSource];//切换右边view的数据
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
//    [TalkingData trackPageBegin:@"qicheguanjia"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
    [self createDataSource];
    [_rightView removeFromSuperview];
    
}

/**导航右按钮*/
- (UIBarButtonItem *)barButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 15, 15);
    
    [button setBackgroundImage:[UIImage imageNamed:@"车辆管理"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setCars) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return rightButton;
}


/**
 * 通知处理
 **/
- (void)tongzhi:(NSNotification *)text{
    
    
    NSLog(@"%@",text.userInfo[@"textOne"]);
    NSLog(@"－－－－－接收到通知------");
    _carNumberStr = text.userInfo[@"textOne"];
    
    [_tableView reloadData];
    
    if (_carNumberStr.length != 0) {
        
        @WeakObj(self)
        [CarManagerPresenter getChangeCarWithYourCarID:_carNumberStr Block:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(),^ {
                if (resultCode == SucceedCode) {
                    NSLog(@"成功");
                    _carNumberStr = @"";
                    [selfWeak createDataSource];
                }
            });
        }];
    }
    
    [_gesturesView removeFromSuperview];
    
}

/**
 * 首页Cell5S刷新一次
 **/
-(void)updateCarInfo
{
    [CarManagerPresenter updataCarInfoWithID:_model.ID AndBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        if (resultCode ==SucceedCode ) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary * dic = data;
                
                
                
                _model.speed = [NSString stringWithFormat:@"%@",([dic objectForKey:@"speed"]==nil?@"0":[dic objectForKey:@"speed"])];
                
                _model.rpm = [NSString stringWithFormat:@"%@",([dic objectForKey:@"rpm"]==nil?@"0":[dic objectForKey:@"rpm"])];
                
                
                _model.temperature = [NSString stringWithFormat:@"%@",([dic objectForKey:@"temperature"]==nil?@"0":[dic objectForKey:@"temperature"])];

                
                _model.voltage = [NSString stringWithFormat:@"%@",([dic objectForKey:@"voltage"]==nil?@"0":[dic objectForKey:@"voltage"])];
                _model.online = [NSString stringWithFormat:@"%@",([dic objectForKey:@"online"]==nil?@"0":[dic objectForKey:@"online"])];
                _model.lastontime = [NSString stringWithFormat:@"%@",([dic objectForKey:@"lastime"]==nil?@"0":[dic objectForKey:@"lastime"])];
                
                _model.oilconsumption = [NSString stringWithFormat:@"%@",([dic objectForKey:@"oilconsumption"]==nil?@"0":[dic objectForKey:@"oilconsumption"])];
                
                _model.warncount = [NSString stringWithFormat:@"%@",([dic objectForKey:@"warncount"]==nil?@"0":[dic objectForKey:@"warncount"])];
                
                
                [_cell4ShowArr removeAllObjects];
                [_cell2LeftShowArr removeAllObjects];
                
                /**
                 * cell2数据
                 **/
                //时速 温度
                NSString *speed = _model.speed;
                NSString *temperature = _model.temperature;
                
                //转速 电压
                NSString *rpm = _model.rpm;
                NSString *voltage = _model.voltage;
                [_cell2LeftShowArr addObjectsFromArray:@[@[speed,temperature],@[rpm,voltage]]];
                
                
                /**
                 * cell4
                 **/
                
                ///油耗
                NSString *oilconsumption = _model.oilconsumption;
                
                
                NSString *str = _model.lastontime;
                
                NSString *dateContent = @"";
                NSString * newSystime = [str substringWithRange:NSMakeRange(0,19)];
                dateContent = [DateTimeUtils StringFromDateTime:[XYString  NSStringToDate:newSystime]];
                
                ///未读报警个数
                NSString *warncount = _model.warncount;
                
                ///车况
                NSString *online = _model.online;
                if ([_model.online isEqualToString:@"0"]) {
                    online = @"熄火";
                }else if ([_model.online isEqualToString:@"1"]) {
                    online = @"正常";
                }else  {
                    online = @"暂无";
                }
                
                [_cell4ShowArr addObjectsFromArray:@[online,dateContent,oilconsumption,warncount]];
                [_tableView reloadData];
                
            });
        }else if (FailureCode) {
        
            
        }

    }];
}



#pragma mark -- createTableView And DataSource
/**
 * 创建tableView
 */
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - 5 - (44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"CarStewardCell1" bundle:nil] forCellReuseIdentifier:@"Cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"CarStewardCell2" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"CarStewardCell3" bundle:nil] forCellReuseIdentifier:@"Cell3"];
    [_tableView registerNib:[UINib nibWithNibName:@"CarStewardCell5" bundle:nil] forCellReuseIdentifier:@"Cell5"];
    
}

/** 
 * tableView数据
 */
- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    if (!_cell2LeftShowArr) {
        _cell2LeftShowArr = [NSMutableArray new];
    }
    if (!_cell4ShowArr) {
        _cell4ShowArr = [NSMutableArray new];
    }

    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    [CarManagerPresenter getChangeCarWithBlock:^(id  _Nullable data, ResultCode resultCode)
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                
                NSDictionary *dict = (NSDictionary *)data;
                [_dataSource removeAllObjects];
                
                NSLog(@"-----%@",[dict objectForKey:@"map"]);
                _model = [ZSY_CarHomePageShowModel mj_objectWithKeyValues:[dict objectForKey:@"map"]];
                [_dataSource addObject:_model]; //dataSource用于判断控件的显示和隐藏
                 /**
                  * cell2数据
                  **/
                 //时速 温度
                NSString *speed = _model.speed;
                NSString *temperature = _model.temperature;
                
                 //转速 电压
                NSString *rpm = _model.rpm;
                NSString *voltage = _model.voltage;
                [_cell2LeftShowArr addObjectsFromArray:@[@[speed,temperature],@[rpm,voltage]]];
                    
                    
                    /**
                     * cell4
                     **/
                    
                    ///油耗
                NSString *oilconsumption = _model.oilconsumption;

               
                NSString *str = _model.lastontime;
                
                NSString *dateContent = @"";
                NSString * newSystime = [str substringWithRange:NSMakeRange(0,19)];
                dateContent = [DateTimeUtils StringFromDateTime:[XYString  NSStringToDate:newSystime]];

                    ///未读报警个数
                NSString *warncount = _model.warncount;

                    ///车况
                NSString *online = _model.online;
                if ([_model.online isEqualToString:@"0"]) {
                    online = @"熄火";
                }else if ([_model.online isEqualToString:@"1"]) {
                    online = @"正常";
                }else if ([_model.online isEqualToString:@"-1"])  {
                    online = @"暂无";
                }
                [_cell4ShowArr addObjectsFromArray:@[online,dateContent,oilconsumption,warncount]];

                    /**
                     * cell1
                     **/
                selfWeak.carNameStr = _model.card;
//
                selfWeak.picUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"picurl"]];
                
                [selfWeak.tableView reloadData];

                selfWeak.uCarID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                
                if (_model.isbinding.boolValue) {
                    if (_NSTimer == nil) {
                        
                        _NSTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                    target:self
                                                                  selector:@selector(updateCarInfo)
                                                                  userInfo:nil
                                                                   repeats:YES];
                    }
                    [_NSTimer fire];

                }
                
                

            }else if(FailureCode){
                
                [_cell2LeftShowArr removeAllObjects];
                [_cell4ShowArr removeAllObjects];
                
            }
        });
    }];

    
    /** cell2 */
    if (!_cell2LeftLabel) {
        _cell2LeftLabel = [NSMutableArray arrayWithObjects:@"时速",@"冷却液温度", nil];
    }
    if (!_cell2LeftEngLabel) {
        _cell2LeftEngLabel = [NSMutableArray arrayWithObjects:@"(km/h)",@"(℃)", nil];
    }
    if (!_cell2LeftImage) {
        _cell2LeftImage = [NSMutableArray arrayWithObjects:@"汽车管家_图标_时速.png",@"汽车管家_图标_温度.png", nil];
    }
    
    if (!_cell2RightLabel) {
        _cell2RightLabel = [NSMutableArray arrayWithObjects:@"发动机转速",@"电瓶电压", nil];
    }
    if (!_cell2RightEngLabel) {
        _cell2RightEngLabel = [NSMutableArray arrayWithObjects:@"(rpm)",@"(V)", nil];
    }
    if (!_cell2RightImage) {
        _cell2RightImage = [NSMutableArray arrayWithObjects:@"汽车管家_图标_转速.png",@"汽车管家_图标_电压.png", nil];
    }
    /** cell4 */
    if (!_cell4LeftLabel) {
        _cell4LeftLabel = [NSMutableArray arrayWithObjects:@"车况",@"熄火",@"油耗", @"报警",nil];
    }
    if (!_cell4LeftImage) {
        _cell4LeftImage = [NSMutableArray arrayWithObjects:@"汽车管家_图标_车况.png",@"汽车管家_图标_熄火.png",@"汽车管家_图标_油耗.png",@"汽车管家_图标_报警.png", nil];
    }
    if (!_cell4RightButton) {
        _cell4RightButton = [NSMutableArray arrayWithObjects:@"车况检测",@"车辆定位",@"里程油耗",@"报警信息", nil];//@"违章查询",
    }
    
    
}


/**
 * 右侧view的数据
 **/
- (void)createRightDataSource {
    
    if (!_rightDataSource) {
        _rightDataSource = [[NSMutableArray alloc] init];
    }
    //    @WeakObj(_tableView);
    [CarManagerPresenter getCarlist:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                
                NSArray *arr = [LS_CarInfoModel mj_objectArrayWithKeyValuesArray:data];
                [_rightDataSource addObject:arr];
                
            }
        });
    }];
    
    
}



#pragma mark -- UITableViewDelegate,UITableViewDataSource   列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else {
        return (3 + _cell4LeftLabel.count);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 80;
    }else {
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            return 120;
        }else if (indexPath.row == 2) {
            
            return 60;
        }else {
            
            return 60;
        }
    }
    
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        
        ///车牌展示
        CarStewardCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///添加按钮
        [cell.addButton addTarget:self action:@selector(addCarCLick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.rightButton addTarget:self action:@selector(rightChangeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.carNumberLabel.text = _carNameStr;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.picurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];

        /**有数据显示车牌号，没数据隐藏*/
        if (_dataSource.count == 0) {
            [cell labelShow];
        }else {
            [cell labelHidden];
        }
        return cell;
        
        
    }else {
        if (indexPath.row == 2) {
            
            ///OBD
            CarStewardCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.leftButton addTarget:self action:@selector(cell3LeftButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        
            
            if (_dataSource.count == 0) {
                [cell setButton];
            }else {
                
                [cell setButtonYes];
            }

            
            return cell;
            
            
        }else if(indexPath.row == 0 || indexPath.row == 1){
            
            ///车辆详情数据
            CarStewardCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.leftlabel1.text = [NSString stringWithFormat:@"%@",_cell2LeftLabel[indexPath.row]];
            cell.leftLabel2.text = [NSString stringWithFormat:@"%@",_cell2LeftEngLabel[indexPath.row]];
            cell.leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_cell2LeftImage[indexPath.row]]];
            
            
            cell.rightLabel1.text = [NSString stringWithFormat:@"%@",_cell2RightLabel[indexPath.row]];
            cell.rightLabel2.text = [NSString stringWithFormat:@"%@",_cell2RightEngLabel[indexPath.row]];
            cell.rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_cell2RightImage[indexPath.row]]];
            
            ///没有数据隐藏展示label
            if (_dataSource.count == 0) {
                [cell setLabelHidden];

            }else {
                cell.leftShowLabel.hidden = NO;
                cell.rightShowLabel.hidden = NO;
                
                
                
                
                if (indexPath.row == 0) {
                    
                    cell.leftShowLabel.text = _model.speed;
                    NSLog(@"%@",_model.speed);
                    if ([XYString isBlankString:_model.speed]) {
                        cell.leftShowLabel.text = @"";
                    }
                 
                    cell.rightShowLabel.text = _model.rpm;
                    if ([XYString isBlankString:_model.rpm]) {
                         cell.rightShowLabel.text = @"";
                    }
                    
                    ///非绑定不显示数据
                    if (_model.isbinding.boolValue) {
                        
                    }else {
                        
                        cell.leftShowLabel.text = @"";
                        cell.rightShowLabel.text = @"";
                    }

                }else if (indexPath.row == 1) {
                    
                    cell.leftShowLabel.text = _model.temperature;
                    
                    if ([XYString isBlankString:_model.temperature]) {
                        cell.leftShowLabel.text = @"";
                    }

                    cell.rightShowLabel.text = _model.voltage;
                    if ([XYString isBlankString:_model.voltage]) {
                        cell.rightShowLabel.text = @"";
                    }
                    
                    ///非绑定不显示数据
                    if (_model.isbinding.boolValue) {
                        
                    }else {
                        
                        cell.leftShowLabel.text = @"";
                        cell.rightShowLabel.text = @"";
                    }

                }
            }
            
            return cell;
        }
        else {
            
            ///定位、报警等
            CarStewardCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell5"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (_dataSource.count == 0) {
                [cell viewHidden];//隐藏控件
            }else {
            
                [cell viewShow];
                if ([cell.rightButton.titleLabel.text isEqualToString:@"报警信息"]) {
                    [cell.rightButton setTitle:@"报警查询" forState:UIControlStateNormal];
                }
                
                cell.stateLabel.text = _cell4ShowArr[indexPath.row - 3];
            }
            
            if ([cell.leftLabel.text isEqualToString:@"熄火"]) {
                cell.stateLabel.numberOfLines = 0;
                cell.stateLabel.font = [UIFont systemFontOfSize:10];
                
            }
            
            [cell.rightButton setTitle:[NSString stringWithFormat:@"%@",_cell4RightButton[indexPath.row - 3]] forState:UIControlStateNormal]; //这里需要减去前边的cell个数
            cell.leftImageView.image = [UIImage imageNamed:_cell4LeftImage[indexPath.row - 3]];
            cell.leftLabel.text = [NSString stringWithFormat:@"%@",_cell4LeftLabel[indexPath.row - 3]];
            
            ///非绑定不显示数据
            if (_model.isbinding.boolValue) {
                
                
            }else {
                
                cell.stateLabel.text = @"";
            }

            
            if (SCREEN_WIDTH <= 320) {
                cell.rightButton.titleLabel.font = [UIFont systemFontOfSize:10];
                cell.leftLabel.font = [UIFont boldSystemFontOfSize:13];
            }else {
                cell.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
                cell.leftLabel.font = [UIFont boldSystemFontOfSize:14];
            }
            
            [cell.rightButton addTarget:self action:@selector(rightButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}



#pragma mark --手势
- (void)createGesturesWithView:(UIView *)view {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    
    swipeGesture.delegate = self;
    
    [view addGestureRecognizer:swipeGesture];
}


//手势事件
- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGesture {
    
    
    /**
     *右滑事件
     **/
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if (_rightView.frame.size.width == W) {
            
            self.leftHidden = NO;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _rightView.frame = CGRectMake(CGRectGetMaxX(self.view.frame),0, 0, SCREEN_HEIGHT + 49);
                [_gesturesView removeFromSuperview];
                
            } completion:^(BOOL finished) {
                ///动画完成后移除view
                [_rightView removeFromSuperview];
            }];
        
        }
    }
}

#pragma amrk --------------- 按钮点击 ------------------

#pragma mark --- 导航右边按钮点击事件
///设置
- (void)setCars {
    VehicleManagementVC * setVC = [[VehicleManagementVC alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    setVC.isNothing = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}


#pragma amrk -- 列表按钮点击事件 切换  添加 车况按钮
/**
 * 切换按钮
 **/
- (void)rightChangeButton:(UIButton *)button {
    
    if (!_rightView) {
        _rightView = [[rightPushCarNumber alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame),0, 0, SCREEN_HEIGHT + 49)];
    }
    
    _rightView.tag = 222;
    [self.view addSubview:_rightView];
    _rightView.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        _rightView.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - W, 0, W, SCREEN_HEIGHT + 49);
        _rightView.shadowHidden = NO; // 阴影,默认为YES
        _rightView.userInteractionEnabled = YES;
        
        
        /**手势View*/
        _gesturesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - W, [UIScreen mainScreen].bounds.size.height)];
        _gesturesView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_gesturesView];
        
        [self createGesturesWithView:_gesturesView];
    }];
    NSLog(@"切换");
    
}

/**
 * cell1 添加按钮
 **/
- (void)addCarCLick:(UIButton *)button {
    
    
    AddCarController *addCar = [[AddCarController alloc] initWithNibName:@"AddCarController" bundle:nil];
    addCar.from = add;
    [self.navigationController pushViewController:addCar animated:YES];
}

/**
 * 车况等按钮点击
 **/
- (void)rightButtonClcik:(UIButton *)button {
    
    ///车况检测
    if ([button.titleLabel.text isEqualToString:@"车况检测"]) {
        
        CarDetectionController *carDetection = [[CarDetectionController alloc] init];
        
        /** carid传值 */
        carDetection.ucarid = _model.ID;
        /** 车牌号传值 */
        carDetection.carNum = _carNameStr;
        [self.navigationController pushViewController:carDetection animated:YES];
        
        ///车辆定位
    }else if ([button.titleLabel.text isEqualToString:@"车辆定位"]) {
        
        CarPositioning *carPosition = [[CarPositioning alloc] init];
        carPosition.carID = _model.ID;
        
        [self.navigationController pushViewController:carPosition animated:YES];
        NSLog(@"定位");
        
    }else if ([button.titleLabel.text isEqualToString:@"里程油耗"]) {
        
        ///油耗
        FuelConsumptionViewController *fuelMileage = [[FuelConsumptionViewController alloc] init];
        [fuelMileage getLicencePlate:_carNameStr ucarid:_model.ID];
        [self.navigationController pushViewController:fuelMileage animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"报警信息"]) {
        
        ///报警信息
        ZSY_CarAlarmVC *alarm = [[ZSY_CarAlarmVC alloc] init];
        alarm.uCarID = _model.ID;
        [self.navigationController pushViewController:alarm animated:YES];
        NSLog(@"报警");
    }
}

/**
 * OBD按钮(详细参数)
 **/
- (void)cell3LeftButtonCLick:(UIButton *)button {
    
    OBDDetails *OBD = [[OBDDetails alloc] init];
    OBD.uCarID = _model.ID;
    [self.navigationController pushViewController:OBD animated:YES];
}

@end
