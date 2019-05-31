//
//  L_NewMyCommunityHouseVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewMyCommunityHouseVC.h"
#import "L_MyCommunityHouseListTVC.h"
#import "L_RentDetailViewController.h"
#import "L_PeopleRentEditViewController.h"
#import "L_ReletHouseViewController.h"
#import "L_AddHouseViewController.h"

@interface L_NewMyCommunityHouseVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 添加房产按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addHouseButton;

@end

@implementation L_NewMyCommunityHouseVC
// MARK: - 添加房产
- (IBAction)addHouseButtonDidTouch:(UIButton *)sender {
    NSLog(@"添加房产");
    
    L_AddHouseViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddHouseViewController"];
    [self.navigationController pushViewController:addVC animated:YES];
}

// MARK: - 无数据时显示视图
- (void)setupNodataView {
    
    _tableView.hidden = YES;
    _addHouseButton.hidden = YES;
    [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有任何认证房产" SubMsg:nil btnTitle:@"添加房产" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index == 0) {
            L_AddHouseViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddHouseViewController"];
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        OwnerResidence *model = [[OwnerResidence alloc] init];
        model.type = [NSString stringWithFormat:@"%d",i%5+1];
        [_dataArray addObject:model];
    }
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyCommunityHouseListTVC" bundle:nil] forCellReuseIdentifier:@"L_MyCommunityHouseListTVC"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view= [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OwnerResidence *model = _dataArray[indexPath.section];
    return model.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_MyCommunityHouseListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyCommunityHouseListTVC"];
    
    OwnerResidence *model = _dataArray[indexPath.section];
    cell.type = model.type.integerValue;
    cell.residenceModel = model;
    
    cell.buttonTouchBlock = ^(NSInteger buttonIndex) {
        /** 1.移除 2.续租 */
        if (buttonIndex == 1) {
            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
            [alertVC ShowAlert:self Title:@"提  示" Msg:@"移除该权限后,受租方将失去该房产的门禁和电梯权限,是否移除?" oneBtn:@"取消" otherBtn:@"确定"];
            
            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                
                if (index == 1000) {
                    //确定
                    
                }
                
            };
        }
        
        if (buttonIndex == 2) {
            L_ReletHouseViewController *releVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_ReletHouseViewController"];
            [self.navigationController pushViewController:releVC animated:YES];
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        L_PeopleRentEditViewController *rentEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_PeopleRentEditViewController"];
        [self.navigationController pushViewController:rentEditVC animated:YES];
    }else {
        L_RentDetailViewController *rentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_RentDetailViewController"];
        rentVC.rentState = indexPath.section % 3 + 1;
        [self.navigationController pushViewController:rentVC animated:YES];
    }
    
}


@end
