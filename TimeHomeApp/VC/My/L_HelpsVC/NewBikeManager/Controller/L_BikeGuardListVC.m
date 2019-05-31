//
//  L_BikeGuardListVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeGuardListVC.h"

#import "L_NewAddBikesViewController.h"
#import "L_MyBikeListVC.h"
#import "L_BikeWarningRecordVC.h"
#import "L_BikeGuardListTVC.h"
#import "WebViewVC.h"

@interface L_BikeGuardListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation L_BikeGuardListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"biycle"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"biycle"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_BikeGuardListTVC" bundle:nil] forCellReuseIdentifier:@"L_BikeGuardListTVC"];

    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BikeGuardListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BikeGuardListTVC"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.top_Label.text = @"添加二轮车";
        cell.left_ImageView.image = [UIImage imageNamed:@"二轮车优化-添加二轮车"];
        cell.bottom_Label.text = @"您可以在这里添加您的二轮车记录，绑定防盗设备";
    }
    
    if (indexPath.section == 1) {
        cell.top_Label.text = @"我的二轮车";
        cell.left_ImageView.image = [UIImage imageNamed:@"二轮车优化-我的二轮车"];
        cell.bottom_Label.text = @"您可以在这里管理您的二轮车，锁车或定时锁车等操作";

    }
    
    if (indexPath.section == 2) {
        cell.top_Label.text = @"二轮车警报记录";
        cell.left_ImageView.image = [UIImage imageNamed:@"二轮车优化-二轮车警报记录"];
        cell.bottom_Label.text = @"您的车辆如果在锁定状态下被骑走，您会收到警报记录";

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        L_NewAddBikesViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
        addVC.hidesBottomBarWhenPushed = YES;
        addVC.fromType = 1;
        [self.navigationController pushViewController:addVC animated:YES];
        
    }
    
    if (indexPath.section == 1) {
        
        L_MyBikeListVC *bikeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyBikeListVC"];
        bikeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bikeVC animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        
        L_BikeWarningRecordVC *bikeWarningVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_BikeWarningRecordVC"];
        bikeWarningVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bikeWarningVC animated:YES];
        
    }
    
}

#pragma mark - 使用说明

- (IBAction)howToUseClick:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = [NSString stringWithFormat:@"%@/20170906/twoWheelVehicle.html",kH5_SEVER_URL];
    webVc.title = @"二轮车防盗使用说明";
    [self.navigationController pushViewController:webVc animated:YES];
    
}


@end
