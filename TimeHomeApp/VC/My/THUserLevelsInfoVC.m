//
//  THUserLevelsInfoVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THUserLevelsInfoVC.h"
#import "THMyLevelStyle1.h"
#import "THMyLevelStyle2.h"
/**
 *  网络请求
 */
#import "UserPointAndMoneyPresenters.h"

@interface THUserLevelsInfoVC () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  用户数据
     */
    UserData *userData;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THUserLevelsInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户等级";
    AppDelegate *appDelegate = GetAppDelegates;
    userData = appDelegate.userData;
    [self createTableView];

    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    [UserPointAndMoneyPresenters getIntegralRuleUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                userData = data;
                [selfWeak.tableView reloadData];
            }
            else
            {
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
        });
        
    }];

}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THMyLevelStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyLevelStyle1 class])];
    [_tableView registerClass:[THMyLevelStyle2 class] forCellReuseIdentifier:NSStringFromClass([THMyLevelStyle2 class])];

    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [THMyLevelStyle1 class];
    if (indexPath.section == 1) {
        currentClass = [THMyLevelStyle2 class];
    }
    return [_tableView cellHeightForIndexPath:indexPath model:userData keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [THMyLevelStyle1 class];
    THMyLevelStyle1 *cell = nil;
    if (indexPath.section == 1) {
        currentClass = [THMyLevelStyle2 class];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = userData;
    
    return cell;
}




@end
