//
//  AreaSelectListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AreaSelectListViewController.h"
/**
 *  网络请求
 */
#import "BMCityPresenter.h"
#import "AppSystemSetPresenters.h"

@interface AreaSelectListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    AppDelegate *appDelegate;
    /**
     *  请求数据
     */
    NSMutableArray *dataArray;
    /**
     *  选中的行
     */
    NSInteger selectRow;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AreaSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择区域";
    appDelegate = GetAppDelegates;
    [self createTableView];
    [self httpRequest];
    
}

/**
 *  获得城市区域（/sysarea/getcitycounty）
 */
- (void)httpRequest {

    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    [BMCityPresenter getCityCounty:^(id  _Nullable data, ResultCode resultCode) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                dataArray = [[NSMutableArray alloc]init];
                [dataArray addObjectsFromArray:data];
                [selfWeak.tableView reloadData];
                selfWeak.tableView.hidden = NO;
                [selfWeak hiddenNothingnessView];
            }
            else
            {
//                [selfWeak showToastMsg:data Duration:5.0];
            }
            if (dataArray.count == 0) {
                selfWeak.tableView.hidden = YES;
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"当前城市没有可选择的区域" eventCallBack:nil];
            }

        });

    } withCityID:appDelegate.userData.cityid];
    
}


/** 创建tableView */
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = LINE_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
//    LifeIDNameModel *model = dataArray[indexPath.row];
    if ([NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"id"]].intValue == self.areaID.intValue) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"生活_勾选"]];
        imageView.frame = CGRectMake(0, 0, 20, 20);
        cell.accessoryView = imageView;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    cell.textLabel.text = [dataArray[indexPath.row] objectForKey:@"name"];
    cell.textLabel.textColor = TITLE_TEXT_COLOR;
    cell.textLabel.font = DEFAULT_FONT(16);
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LifeIDNameModel *model = dataArray[indexPath.row];
    
    if (self.callBack) {
        self.callBack([NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"id"]],[dataArray[indexPath.row] objectForKey:@"name"]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
