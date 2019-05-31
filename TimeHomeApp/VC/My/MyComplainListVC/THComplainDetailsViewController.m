//
//  THComplainDetailsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THComplainDetailsViewController.h"
#import "THMyrequiredTVCStyle1.h"
#import "THMyRequiredTVCStyle2.h"
#import "THMyRequiredTVCStyle3.h"
#import "THMyComplainPropertyReplysTVC.h"
#import "THMyrequiredTVCPicStyle1.h"

@interface THComplainDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THComplainDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:TouSu];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":TouSu}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投诉详情";

    [self createTableView];
    
}
- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerClass:[THMyrequiredTVCStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyrequiredTVCStyle1 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle2 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle2 class])];
    [_tableView registerClass:[THMyRequiredTVCStyle3 class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredTVCStyle3 class])];
    [_tableView registerClass:[THMyComplainPropertyReplysTVC class] forCellReuseIdentifier:NSStringFromClass([THMyComplainPropertyReplysTVC class])];
    [_tableView registerClass:[THMyrequiredTVCPicStyle1 class] forCellReuseIdentifier:NSStringFromClass([THMyrequiredTVCPicStyle1 class])];


    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_userComplaint.state.intValue == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    
    if (section == 1) {

        UILabel *sectionLabel = [[UILabel alloc]init];
        sectionLabel.text = @"物业回复服务";
        sectionLabel.font = DEFAULT_FONT(16);
        sectionLabel.textColor = TITLE_TEXT_COLOR;
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.equalTo(view).offset(15);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = TEXT_COLOR;
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionLabel.mas_right).offset(10);
            make.centerY.equalTo(sectionLabel.mas_centerY);
            make.right.equalTo(view).offset(-7);
            make.height.equalTo(@1);
        }];
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [THMyrequiredTVCStyle1 class];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            currentClass = [THMyRequiredTVCStyle2 class];
        }
        if (indexPath.row == 2) {
            
            currentClass = [THMyrequiredTVCPicStyle1 class];

//            currentClass = [THMyRequiredTVCStyle3 class];
        }
    }else {
        currentClass = [THMyComplainPropertyReplysTVC class];
    }
    
    return [_tableView cellHeightForIndexPath:indexPath model:_userComplaint keyPath:@"userComplaint2" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [THMyrequiredTVCStyle1 class];
    THMyrequiredTVCStyle1 *cell = nil;

    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            currentClass = [THMyRequiredTVCStyle2 class];
        }
        if (indexPath.row == 2) {
            currentClass = [THMyrequiredTVCPicStyle1 class];

//            currentClass = [THMyRequiredTVCStyle3 class];
        }
    }else {
        currentClass = [THMyComplainPropertyReplysTVC class];
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userComplaint2 = _userComplaint;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.section == 0 && indexPath.row == 2) {
        width = SCREEN_WIDTH/2-7;
    }
    if (indexPath.section == 1) {
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
