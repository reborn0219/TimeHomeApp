//
//  L_NewMyCommunityVertifyVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewMyCommunityVertifyVC.h"
#import "L_NewCommunityVertifyListTVC.h"
#import "THMyVisitorListsViewController.h"
#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "L_MyCurrentCommunityVC.h"
#import "L_NewMyCommunityHouseVC.h"
#import "THMyCarAuthorityListVC.h"
#import "THMySubRegionListViewController.h"
#import "THMyHouseAuthorityViewController.h"

@interface L_NewMyCommunityVertifyVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *titleImgArr;
    AppDelegate *appDelegate;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation L_NewMyCommunityVertifyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    appDelegate = GetAppDelegates;

    titleArr = @[@[@"社区认证"],@[@"房产出租",@"车位出租",@"访客通行"],@[@"报修",@"投诉"]];
    titleImgArr = @[@[@"业主认证--我的--社区认证图标"],@[@"业主认证--我的-房产出租图标",@"业主认证--我的--车位出租图标",@"业主认证--我的--访客通行图标"],@[@"业主认证--我的--报修图标",@"业主认证--我的--投诉图标"]];

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewCommunityVertifyListTVC" bundle:nil] forCellReuseIdentifier:@"L_NewCommunityVertifyListTVC"];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_NewCommunityVertifyListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewCommunityVertifyListTVC"];
    
    cell.leftTitleLabel.text = titleArr[indexPath.section][indexPath.row];
    cell.leftImg.image = [UIImage imageNamed:titleImgArr[indexPath.section][indexPath.row]];
    cell.dotImg.hidden = YES;
    cell.bottomLineView.hidden = YES;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0|| indexPath.row == 1) {
            cell.bottomLineView.hidden = NO;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.bottomLineView.hidden = NO;
            
            if (![XYString isBlankString:_showRepairMsg]) {
                cell.dotImg.hidden = NO;
            }
            
        }
        
        if (indexPath.row == 1) {
            if (![XYString isBlankString:_showComplainMsg]) {
                cell.dotImg.hidden = NO;
            }
        }
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
//        L_MyCurrentCommunityVC *communityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyCurrentCommunityVC"];
//        [self.navigationController pushViewController:communityVC animated:YES];
        //我的小区
        THMySubRegionListViewController *subVC = [[THMySubRegionListViewController alloc]init];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
//            L_NewMyCommunityHouseVC *houseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewMyCommunityHouseVC"];
//            [self.navigationController pushViewController:houseVC animated:YES];
            //房产权限
            THMyHouseAuthorityViewController *houseVC = [[THMyHouseAuthorityViewController alloc]init];
            [self.navigationController pushViewController:houseVC animated:YES];
        }
        
        if (indexPath.row == 1) {
            NSLog(@"车位权限");
            //车位权限
            THMyCarAuthorityListVC *carVC = [[THMyCarAuthorityListVC alloc]init];
            [self.navigationController pushViewController:carVC animated:YES];
        }
        
        if (indexPath.row == 2) {
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
        
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
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
            [self.navigationController pushViewController:subVC animated:YES];
            
        }
        
        if (indexPath.row == 1) {
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
    
}


@end
