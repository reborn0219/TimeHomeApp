//
//  L_NewMyCommunityCertifyVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewMyCommunityCertifyVC.h"
#import "L_BaseCommunityListTVC.h"

#import "L_NewMyHouseListViewController.h"
#import "THMyCarAuthorityListVC.h"
#import "THMyVisitorListsViewController.h"
#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "L_CommunityAuthoryPresenters.h"
#import "LS_VistorListVC.h"
#import "PANewHouseViewController.h"

@interface L_NewMyCommunityCertifyVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titles;
    AppDelegate *appDelegate;
    int certCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation L_NewMyCommunityCertifyVC

#pragma mark - 获得待认证的房产个数

- (void)httpRequestForCertCount {
    
    [L_CommunityAuthoryPresenters getWaitCertCountUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (resultCode == SucceedCode) {
                certCount = [data[@"map"][@"waitcertcount"] intValue];
                [_tableView reloadData];
            }
            
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self httpRequestForCertCount];

//    [TalkingData trackPageBegin:@"wodeshequ"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"wodeshequ"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = GetAppDelegates;
    
    certCount = 0;
    
    titles = @[@"我的房产",@"我的车位",@"访客通行记录",@"报修记录",@"投诉记录"];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_BaseCommunityListTVC" bundle:nil] forCellReuseIdentifier:@"L_BaseCommunityListTVC"];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_BaseCommunityListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BaseCommunityListTVC"];
    
    cell.dot_View.hidden = YES;
    cell.houseCount_Label.hidden = YES;
    cell.rightDetail_Label.hidden = YES;
    cell.bottomLine_View.hidden = NO;
    
    cell.leftTitle_Label.text = titles[indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.houseCount_Label.hidden = NO;
        cell.houseCount_Label.text = [NSString stringWithFormat:@"%d",certCount];
        cell.rightDetail_Label.hidden = NO;

    }else {
        
        if (indexPath.row == 3) {
            if (![XYString isBlankString:_showRepairMsg]) {
                cell.dot_View.hidden = NO;
            }
        }
        
        if (indexPath.row == 4) {
            cell.bottomLine_View.hidden = YES;
            if (![XYString isBlankString:_showComplainMsg]) {
                cell.dot_View.hidden = NO;
            }
        }
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //我的房产
        L_NewMyHouseListViewController *house = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
        //PANewHouseViewController * house = [[PANewHouseViewController alloc]init];
        [self.navigationController pushViewController:house animated:YES];
        
    }
    
    if (indexPath.row == 1) {
        //我的车位
        THMyCarAuthorityListVC *carVC = [[THMyCarAuthorityListVC alloc]init];
        [self.navigationController pushViewController:carVC animated:YES];
    }
    
    if (indexPath.row == 2) {
        //访客通行记录
        if(appDelegate.userData.openmap!=nil) {
            
            NSInteger flag=[[appDelegate.userData.openmap objectForKey:@"protraffic"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
            
        }
        
        LS_VistorListVC * lsVC = [[LS_VistorListVC alloc]init];
        [self.navigationController pushViewController:lsVC animated:YES];
        

//        THMyVisitorListsViewController *subVC = [[THMyVisitorListsViewController alloc]init];
//        [self.navigationController pushViewController:subVC animated:YES];
//        
    }
    
    if (indexPath.row == 3) {
        //报修记录
        if(appDelegate.userData.openmap!=nil) {
            
            NSInteger flag=[[appDelegate.userData.openmap objectForKey:@"proreserve"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
        if (![XYString isBlankString:_showRepairMsg]) {
            NSArray *array = [_showRepairMsg componentsSeparatedByString:@","];
            subVC.IdArray = array;
        }
        subVC.isFromMy = @"1";
        [self.navigationController pushViewController:subVC animated:YES];
        
    }
    
    if (indexPath.row == 4) {
        //投诉记录
        if(appDelegate.userData.openmap!=nil) {
            
            NSInteger flag=[[appDelegate.userData.openmap objectForKey:@"procomplaint"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        THMyComplainListViewController *complainVC = [[THMyComplainListViewController alloc]init];
        if (![XYString isBlankString:_showComplainMsg]) {
            NSArray *array = [_showComplainMsg componentsSeparatedByString:@","];
            complainVC.IdArray = array;
        }
        [self.navigationController pushViewController:complainVC animated:YES];
    }
    
}


@end
