//
//  THMyVisitorDetailsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyVisitorDetailsViewController.h"
#import "THBaseTableViewCell.h"

#import "AppSystemSetPresenters.h"

@interface THMyVisitorDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *leftImages;//左边的图片数组
    NSArray *leftTitles;//左边的标题数组
    NSArray *rightDetails;//模拟用户数据
    /**
     *  当前日期
     */
    NSString *beginDateString;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMyVisitorDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:FangKe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":FangKe}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"访客详情";
    beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    [self setUpArrays];

    [self createTableView];
    
    [self getAppsystemTime];

}
/**
 *  获取当前时间
 */
- (void)getAppsystemTime {
    
//    @WeakObj(self);
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [AppSystemSetPresenters getSystemTimeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                if (![XYString isBlankString:data]) {
                    beginDateString = [(NSString *)data substringToIndex:10];
                }else {
                    beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
                }
            }
            else
            {
                beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            [_tableView reloadData];
            
        });
        
    }];
    
}

/**
 *  初始化数组
 */
- (void)setUpArrays {
    
    leftImages = @[@"我的访客_访客详情_访问地址",@"我的访客_访客详情_到访日期",@"我的访客_访客详情_访客车牌",@"我的访客_访客详情_拥有权限",@"我的访客_访客详情_访客手机",@"我的访客_访客详情_访客姓名"];
    leftTitles = @[@"访问地址:  ",@"到访日期:  ",@"到访车辆:  ",@"拥有权限:  ",@"访客手机:  ",@"访客姓名:  "];
    
    NSString *string1 = @"";
    string1 = [XYString IsNotNull:_visitor.communityname];
    string1 = [string1 stringByAppendingFormat:@" %@",[XYString IsNotNull:_visitor.residencename]];
    
    NSString *string2 = @"";
    
    NSString *dateString = [_visitor.visitdate substringToIndex:10];
//    NSDate *date = [XYString NSStringToDate:_visitor.visitdate withFormat:@"yyyy-MM-dd"];
//    NSString *dateString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
    string2 = [XYString IsNotNull:dateString];
    
    NSString *string3 = @"";
    string3 = [XYString IsNotNull:_visitor.visitcard];

    NSString *string4 = @"";
    if (_visitor.power.intValue == 0) {
        string4 = @"小区门";
    }
    if (_visitor.power.intValue == 1) {
        string4 = @"小区门 单元门";
    }
    if (_visitor.power.intValue == 2) {
        string4 = @"小区门 单元门 电梯门";
    }
    NSString *string5 = @"";
    string5 = [XYString IsNotNull:_visitor.visitphone];
    
    NSString *string6 = @"";
    string6 = [XYString IsNotNull:_visitor.visitname];
    
    rightDetails = @[string1,string2,string3,string4,string5,string6];
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rightDetails.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == rightDetails.count) {
        return 50;
    }else if ([XYString isBlankString:rightDetails[indexPath.row]]) {
        return 0;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    NSString *dateString = [_visitor.visitdate substringToIndex:10];
    NSDate *date = [XYString NSStringToDate:dateString withFormat:@"yyyy-MM-dd"];
//    NSString *currentDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [XYString NSStringToDate:beginDateString withFormat:@"yyyy-MM-dd"];
    int isOld = [XYString CompareOneDay:currentDate withAnotherDay:date];
    
    if (isOld == 1) {
        return 0;
    }
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    
    NSString *dateString = [_visitor.visitdate substringToIndex:10];
    NSDate *date = [XYString NSStringToDate:dateString withFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [XYString NSStringToDate:currentDateString withFormat:@"yyyy-MM-dd"];
    int isOld = [XYString CompareOneDay:currentDate withAnotherDay:date];
    
    if (isOld != 1) {
        UIButton *cxsqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cxsqButton setBackgroundColor:kNewRedColor];
        [cxsqButton setTitle:@"撤 销 申 请" forState:UIControlStateNormal];
        cxsqButton.titleLabel.font = DEFAULT_BOLDFONT(16);
        [cxsqButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:cxsqButton];
        [cxsqButton addTarget:self action:@selector(cxsqButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cxsqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(20);
            make.width.equalTo(@(WidthSpace(584)));
            make.height.equalTo(@(WidthSpace(64)));
            make.centerX.equalTo(view.mas_centerX);
        }];
    }
    
    return view;
}
/**
 *  撤销申请
 */
- (void)cxsqButtonClick {
    @WeakObj(self);
    CommonAlertVC *alertVC = [CommonAlertVC getInstance];
    [alertVC ShowAlert:self Title:@"撤销申请" Msg:@"是否撤销该访客通行申请" oneBtn:@"取消" otherBtn:@"确定"];
    alertVC.eventCallBack = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){

        if (index == 1000) {
            //确定
            
//            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
//            [indicator startAnimating:selfWeak.tabBarController];
            [UserTrafficPresenter removeTrafficForID:_visitor.theID upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

                dispatch_async(dispatch_get_main_queue(), ^{
//                    [indicator stopAnimating];
                    if(resultCode == SucceedCode)
                    {
                        [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                        if (selfWeak.callBack) {
                            selfWeak.callBack();
                        }
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                    }
                });

            }];
            
        }
        if (index == 1001) {
            //取消
        }
        
    };
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < leftImages.count) {
        
        if ([XYString isBlankString:rightDetails[indexPath.row]]) {
            cell.baseTableViewCellStyle = BaseTableViewCellStyleImageValue1;
            cell.arrowImage.hidden      = YES;
            cell.leftImageView.hidden   = YES;
            cell.leftLabel.hidden       = YES;
            
        }else {
            cell.baseTableViewCellStyle = BaseTableViewCellStyleImageValue1;
            cell.arrowImage.hidden      = YES;
            cell.leftImageView.hidden   = NO;
            cell.leftLabel.hidden       = NO;
            cell.leftImageView.image    = [UIImage imageNamed:leftImages[indexPath.row]];
            cell.leftLabel.font         = DEFAULT_FONT(14);
            cell.leftLabel.text         = [NSString stringWithFormat:@"%@%@",leftTitles[indexPath.row],rightDetails[indexPath.row]];
            cell.leftLabel.numberOfLines=0;
        }
        
    }else {
        THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.baseTableViewCellStyle = BaseTableViewCellStyleImageValue1;
        cell.arrowImage.hidden      = YES;

        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;

    if (indexPath.row == leftImages.count) {
        width = SCREEN_WIDTH/2-7;
    }
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
