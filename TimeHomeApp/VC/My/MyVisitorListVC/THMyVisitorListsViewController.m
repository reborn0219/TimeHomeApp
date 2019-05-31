//
//  THMyVisitorListsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyVisitorListsViewController.h"
#import "THBaseTableViewCell.h"
#import "MineTVC.h"
#import "THMyVisitorDetailsViewController.h"

/**
 *  网络请求
 */
#import "UserTrafficPresenter.h"
#import "AppSystemSetPresenters.h"

@interface THMyVisitorListsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  请求数据
     */
    NSMutableArray *dataArray;
    NSArray *leftImages;
    /**
     *  当前日期
     */
    NSString *beginDateString;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMyVisitorListsViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [_tableView.mj_header beginRefreshing];
    
//    [TalkingData trackPageBegin:@"fangke"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:FangKe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"fangke"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":FangKe}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"访客通行记录";
    dataArray = [[NSMutableArray alloc]init];
    beginDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
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
 *  我的访客列表请求数据
 */
- (void)httpRequest {
    
//     @WeakObj(self);
//    [UserTrafficPresenter getUserTrafficForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if (_tableView.mj_header.isRefreshing) {
//                [_tableView.mj_header endRefreshing];
//            }
//            
//            if(resultCode == SucceedCode)
//            {
//                [dataArray removeAllObjects];
//                [dataArray addObjectsFromArray:data];
//                [selfWeak.tableView reloadData];
//                _tableView.hidden = NO;
//            }
//            else
//            {
//                [dataArray removeAllObjects];
//                [selfWeak.tableView reloadData];
//                _tableView.hidden = NO;
//
////                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
//            }
//            if (dataArray.count == 0) {
//                _tableView.hidden = YES;
//                [selfWeak showNothingnessView:@"暂无数据" Msg:@"您还没有访客" eventCallBack:nil];
//                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
//
//            }
//        });
//        
//    }];
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[MineTVC class] forCellReuseIdentifier:NSStringFromClass([MineTVC class])];
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequest];
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseTableViewCellStyle = BaseTableViewCellStyleImageValue1;
    
    if (dataArray.count > 0) {
        UserVisitor *visitor = dataArray[indexPath.section];
        
        NSString *dateString = [visitor.visitdate substringToIndex:10];
        
        NSDate *date = [XYString NSStringToDate:dateString withFormat:@"yyyy-MM-dd"];
        //    NSString *currentDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
        NSDate *currentDate = [XYString NSStringToDate:beginDateString withFormat:@"yyyy-MM-dd"];
        int isOld = [XYString CompareOneDay:currentDate withAnotherDay:date];
        
        if (isOld == 1) {
            cell.contentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        }else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        
        if (indexPath.row == 1) {
            cell.arrowImage.hidden = YES;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@到访",dateString];
            cell.leftLabel.font = DEFAULT_FONT(14);
        }
        if (indexPath.row == 0) {
            
            if (visitor.type.intValue == 2) {
                cell.leftImageView.image = [UIImage imageNamed:@"我的访客_访客详情_访客车牌"];
                cell.leftLabel.text = visitor.visitcard;
            }else {
                if (![XYString isBlankString:visitor.visitname]) {
                    cell.leftImageView.image = [UIImage imageNamed:@"我的访客_访客详情_访客姓名"];
                    cell.leftLabel.text = visitor.visitname;
                    
                }else if (![XYString isBlankString:visitor.visitphone]) {
                    
                    cell.leftImageView.image = [UIImage imageNamed:@"我的访客_访客详情_访客手机"];
                    cell.leftLabel.text = visitor.visitphone;
                    
                }else if (![XYString isBlankString:visitor.visitcard]) {
                    
                    cell.leftImageView.image = [UIImage imageNamed:@"我的访客_访客详情_访客车牌"];
                    cell.leftLabel.text = visitor.visitcard;
                    
                }
            }
            
            
        }
    }
    

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    @WeakObj(self);

    //访客详情
    THMyVisitorDetailsViewController *visitorDetailsVC = [[THMyVisitorDetailsViewController alloc]init];
    UserVisitor *visitor = dataArray[indexPath.section];
    visitorDetailsVC.visitor = visitor;
    visitorDetailsVC.callBack = ^(){
      
        [selfWeak.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:visitorDetailsVC animated:YES];

    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    
    UserVisitor *visitor = dataArray[indexPath.section];
    
    NSString *dateString = [visitor.visitdate substringToIndex:10];
    
    NSDate *date = [XYString NSStringToDate:dateString withFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [XYString NSDateToString:[NSDate date] withFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [XYString NSStringToDate:currentDateString withFormat:@"yyyy-MM-dd"];
    int isOld = [XYString CompareOneDay:currentDate withAnotherDay:date];
    
    if (isOld == 1) {
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
