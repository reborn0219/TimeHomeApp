//
//  L_AddHouseForCertifyCommunityVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_CertifyAddBaseTVC1.h"
#import "L_CertifyAddBaseTVC2.h"
#import "L_HouseDetailViewController2.h"
#import "SubmittedToExamineAlert.h"
#import "CertificationSuccessfulVC.h"

#import "L_CommunityAuthoryPresenters.h"
#import "AppSystemSetPresenters.h"
#import "MainTabBars.h"
#import "ContactServiceVC.h"

#import "ContactServiceVC.h"
#import "L_NewMyHouseListViewController.h"

@interface L_AddHouseForCertifyCommunityVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titles;
    //姓名 楼栋 单元 房间
    NSString *xingming;
    NSString *loudong;
    NSString *danyuan;
    NSString *fangjian;
    AppDelegate *appDlgt;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation L_AddHouseForCertifyCommunityVC

#pragma mark - 按钮点击

- (IBAction)certifyCommunityDidTouch:(UIButton *)sender {
    
    NSLog(@"申请认证");
    
    //页面跳转
    
    [self.view endEditing:YES];
    
    if ([XYString isBlankString:xingming]) {
        [self showToastMsg:@"您还没有填写姓名" Duration:3.0];
        return;
    }
    if ([XYString isBlankString:loudong]) {
        [self showToastMsg:@"您还没有填写楼栋名称" Duration:3.0];
        return;
    }
    if ([XYString isBlankString:danyuan]) {
        [self showToastMsg:@"您还没有填写单元名称" Duration:3.0];
        return;
    }
    if ([XYString isBlankString:fangjian]) {
        [self showToastMsg:@"您还没有填写房间号" Duration:3.0];
        return;
    }
    
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters indentResiCertWithOwnerName:xingming buildName:loudong unitName:danyuan roomNum:fangjian communityID:_communityID UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                if ([_pushType isEqualToString:@"0"]) {
                    //显示弹窗
                    ///认证成功
                    SubmittedToExamineAlert *alert = [SubmittedToExamineAlert shareNewAlert];
                    alert.isHiddenBtn = YES;
                    [alert showInVC:self];
                    alert.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        if (index == 0) {
                            AppDelegate *appDelegate = GetAppDelegates;
                            ///绑定标签
                            [AppSystemSetPresenters getBindingTag];
                            
                            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                            MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                            appDelegate.window.rootViewController=MainTabBar;
                            
                            CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                            [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
                        }
                        
                    };
                    
                }else {
                    
                    if (_fromType == 1 || _fromType == 2 || _fromType == 3) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];
                    }

                    //显示弹窗
                    ///认证成功
                    SubmittedToExamineAlert *alert = [SubmittedToExamineAlert shareNewAlert];
                    alert.isHiddenBtn = NO;
                    [alert showInVC:self];
                    [alert.enterBtn setTitle:@"联系物业" forState:UIControlStateNormal];
                    alert.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        //0.联系物业 1.查看我的房产
                        NSLog(@"联系物业");
                        if (index == 0) {
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                            ContactServiceVC * contactsVC = [storyboard instantiateViewControllerWithIdentifier:@"ContactServiceVC"];
                            contactsVC.isFromBikeInfo = YES;
                            contactsVC.communityID = _communityID;
                            contactsVC.fromType = _fromType;
                            contactsVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:contactsVC animated:YES];
                            
                        }
                        if (index == 1) {

                            //查看我的房产
                            if (_fromType == 1 || _fromType == 3) {
                                
                                NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                                if (tempMarr.count > 0) {
                                    
                                    [tempMarr removeObjectAtIndex:tempMarr.count-2];
                                    [self.navigationController setViewControllers:tempMarr animated:NO];
                                    
                                }
                                
                                [self.navigationController popViewControllerAnimated:YES];

                            }else if (_fromType == 2) {
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            }else {
                                
                                //查看我的房产
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                                houseListVC.fromType = 5;
                                houseListVC.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:houseListVC animated:YES];
                                
                            }

                        }
                        
                    };

//                    NSString *errmsg = [data objectForKey:@"errmsg"];
//                    [self showToastMsg:errmsg Duration:3.0];

                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"faqirenzheng"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"faqirenzheng"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    titles = @[@"社       区",@"电       话",@"业主姓名",@"楼栋名称",@"单元名称",@"房 间 号"];
    
    appDlgt = GetAppDelegates;
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];

    [_tableView registerNib:[UINib nibWithNibName:@"L_CertifyAddBaseTVC1" bundle:nil] forCellReuseIdentifier:@"L_CertifyAddBaseTVC1"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_CertifyAddBaseTVC2" bundle:nil] forCellReuseIdentifier:@"L_CertifyAddBaseTVC2"];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < 2) {
        
        L_CertifyAddBaseTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CertifyAddBaseTVC1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTitle_Label.text = titles[indexPath.row];
        
        if (indexPath.row == 0) {
//            cell.rightTitle_Label.text = @"春江花园";
            if ([XYString isBlankString:_communityName]) {
                cell.rightTitle_Label.text = appDlgt.userData.communityname;
            }else {
                cell.rightTitle_Label.text = _communityName;
            }
        }
        if (indexPath.row == 1) {
//            cell.rightTitle_Label.text = @"18604121111";
            cell.rightTitle_Label.text = appDlgt.userData.phone;
        }
        
        return cell;
        
    }else {
        
        L_CertifyAddBaseTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CertifyAddBaseTVC2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTitle_Label.text = titles[indexPath.row];

        switch (indexPath.row) {
            case 2:
            {
                cell.right_TF.placeholder = @"您的姓名";
                cell.type = 2;
                cell.textFieldBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                  
                    xingming = data;
                };
            }
                break;
            case 3:
            {
                cell.right_TF.placeholder = @"请输入楼栋";
                cell.type = 1;
                cell.textFieldBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    loudong = data;
                };
            }
                break;
            case 4:
            {
                cell.right_TF.placeholder = @"请输入单元";
                cell.type = 1;
                cell.textFieldBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    danyuan = data;
                };
            }
                break;
            case 5:
            {
                cell.right_TF.placeholder = @"请输入房间号";
                cell.type = 1;
                cell.textFieldBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    fangjian = data;
                };
            }
                break;
                
            default:
                break;
        }
        
        return cell;
        
    }

}


@end
