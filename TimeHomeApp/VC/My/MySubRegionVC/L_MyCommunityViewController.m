//
//  L_MyCommunityViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyCommunityViewController.h"

//VC
#import "THMySubRegionListViewController.h"
#import "THMyVisitorListsViewController.h"
#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "THMyHouseAuthorityViewController.h"
#import "THMyCarAuthorityListVC.h"

//TVC
#import "L_BaseLabelTVC.h"

@interface L_MyCommunityViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titles;
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation L_MyCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = GetAppDelegates;
    titles = @[@"社区认证",@"我的房产",@"我的车位",@"访客通行记录",@"报修记录",@"投诉记录"];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_BaseLabelTVC" bundle:nil] forCellReuseIdentifier:@"L_BaseLabelTVC"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BaseLabelTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BaseLabelTVC"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftLabel.text = titles[indexPath.row];
    
    cell.bottomLineView.hidden = NO;

    if (indexPath.row == titles.count - 1) {
        cell.bottomLineView.hidden = YES;
    }

    if (indexPath.row == 4) {
        if (![XYString isBlankString:_showRepairMsg]) {
            cell.dotImageView.hidden = NO;
        }
        cell.bottomLineView.hidden = NO;
    }
    
    if (indexPath.row == 5) {
        if (![XYString isBlankString:_showComplainMsg]) {
            cell.dotImageView.hidden = NO;
        }
    }
        
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSLog(@"社区认证");
        //我的小区
        THMySubRegionListViewController *subVC = [[THMySubRegionListViewController alloc]init];
        [self.navigationController pushViewController:subVC animated:YES];
    }

    if (indexPath.row == 1) {
        NSLog(@"房产权限");
        //房产权限
        THMyHouseAuthorityViewController *houseVC = [[THMyHouseAuthorityViewController alloc]init];
        [self.navigationController pushViewController:houseVC animated:YES];
    }
    if (indexPath.row == 2) {
        NSLog(@"车位权限");
        //车位权限
        THMyCarAuthorityListVC *carVC = [[THMyCarAuthorityListVC alloc]init];
        [self.navigationController pushViewController:carVC animated:YES];
    }
    if (indexPath.row == 3) {
        NSLog(@"访客通行");
        //我的访客
        if(appDelegate.userData.openmap!=nil) {
            
            NSInteger flag=[[appDelegate.userData.openmap objectForKey:@"protraffic"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
            
        }
        
        //我的访客
        THMyVisitorListsViewController *subVC = [[THMyVisitorListsViewController alloc]init];
        [self.navigationController pushViewController:subVC animated:YES];
    }

    if (indexPath.row == 4) {
        NSLog(@"报修");
        //我的维修
        if(appDelegate.userData.openmap!=nil) {
            
            NSInteger flag=[[appDelegate.userData.openmap objectForKey:@"proreserve"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        //我的维修
        THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
        if (![XYString isBlankString:_showRepairMsg]) {
            NSArray *array = [_showRepairMsg componentsSeparatedByString:@","];
            subVC.IdArray = array;
        }
//        subVC.isFromMy = @"1";
        [self.navigationController pushViewController:subVC animated:YES];
    }
    if (indexPath.row == 5) {
        NSLog(@"投诉");
        //我的投诉
        if(appDelegate.userData.openmap!=nil) {
            
            NSInteger flag=[[appDelegate.userData.openmap objectForKey:@"procomplaint"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        //我的投诉
        THMyComplainListViewController *complainVC = [[THMyComplainListViewController alloc]init];
        if (![XYString isBlankString:_showComplainMsg]) {
            NSArray *array = [_showComplainMsg componentsSeparatedByString:@","];
            complainVC.IdArray = array;
        }
        [self.navigationController pushViewController:complainVC animated:YES];
    }
    
    
}

@end
