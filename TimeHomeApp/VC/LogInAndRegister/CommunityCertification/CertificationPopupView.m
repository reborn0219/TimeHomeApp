//
//  CertificationPopupView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/3/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CertificationPopupView.h"
#import "L_CommunityAuthoryPresenters.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_NewMyHouseListViewController.h"

@interface CertificationPopupView ()
@property (weak, nonatomic) IBOutlet UIView *oneKeyView;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (weak, nonatomic) IBOutlet UIButton *oneKeyButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewBottomLayout;
@property (nonatomic, strong) UIViewController *lastVC;
@end

@implementation CertificationPopupView


- (IBAction)cancelAction:(id)sender {
    
    if (self.callBlock) {
        self.callBlock(nil, nil, 0);
    }
    [self dismissVC];
}
- (IBAction)bottomAction:(id)sender {
    
    if (self.callBlock) {
        self.callBlock(nil, nil, 2);
    }
    [self dismissVC];

    if (self.type == 1) {
        
        if ([self.lastVC isKindOfClass:[L_NewMyHouseListViewController class]]) {
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
        L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
        houseListVC.iscurrentVC = @"1";
        [self.lastVC.navigationController pushViewController:houseListVC animated:YES];
        
    }

}
- (IBAction)oneKeyAction:(id)sender {
    
    if (self.callBlock) {
        self.callBlock(nil, nil, 1);
    }
    [self dismissVC];
    [self certificationJumpToRequestAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.backView.layer.cornerRadius = 15;
    self.oneKeyButton.layer.cornerRadius = 20;
    
    /// 渐变色layer
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = CGRectMake(0, 0, SCREEN_WIDTH-(38+26)*2, 40);
    colorLayer.colors = @[(__bridge id)UIColorFromRGB(0x5AB8F3).CGColor,
                          (__bridge id)UIColorFromRGB(0x2D82E3).CGColor];
    colorLayer.startPoint = CGPointMake(0, 0.5);
    colorLayer.endPoint   = CGPointMake(1, 0.5);
    colorLayer.cornerRadius = 20;
    
    [self.oneKeyButton.layer addSublayer:colorLayer];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (SCREEN_WIDTH == 414) {
        
        self.centerViewBottomLayout.constant = 50;
        
    }else if (SCREEN_WIDTH == 375){
        
        self.centerViewBottomLayout.constant = 30;

    }else if (SCREEN_WIDTH == 320)
    {
        self.centerViewBottomLayout.constant = 10;

    }
    
    if (self.type == 1) {
        
        [self.oneKeyView setHidden:NO];
        [self.welcomeView setHidden:YES];
        [self.oneKeyButton setTitle:@"一键认证当前社区" forState:UIControlStateNormal];
        [self.bottomButton setTitle:@"查看我的房产" forState:UIControlStateNormal];

    }else{
        
        [self.oneKeyView setHidden:YES];
        [self.welcomeView setHidden:NO];
        [self.oneKeyButton setTitle:@"一键认证" forState:UIControlStateNormal];
        [self.bottomButton setTitle:@"暂不认证" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showVC:(UIViewController *)parent event:(ViewsEventBlock)eventCallBack {
    
    self.lastVC = parent;
    self.callBlock = eventCallBack;
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    
}

#pragma mark - 隐藏显示

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)certificationJumpToRequestAction{
    
    @WeakObj(self)
    if (self.type == 0) {
        ///注册页跳转的头视图（注册成功后跳转的页面）
        ///一键认证
        THIndicatorVCStart
        [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    THIndicatorVCStopAnimating
                    
                    AppDelegate *appDlgt = GetAppDelegates;
                    
                    if (resultCode == SucceedCode) {
                        
                        NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                        
                        if (isownercert.intValue == 1) {
                            
                            [AppDelegate showToastMsg:@"当前社区已认证过房产，您可以去我的房产中，认证新的房产" Duration:3.0];
                            return ;
                            
                        }else {
                            
                            NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                            NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                            
                            if (houseArr.count > 0) {
                                
                                //---有房产----
                                UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                                houseListVC.type = 1;
                                houseListVC.houseArr = houseArr;
                                houseListVC.carArr = carArr;
                                houseListVC.communityID = appDlgt.userData.communityid;
                                houseListVC.communityName = appDlgt.userData.communityname;
                                [selfWeak.lastVC.navigationController pushViewController:houseListVC animated:YES];
                                
                            }else {
                                
                                //---无房产----
                                UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                                addVC.communityID = appDlgt.userData.communityid;
                                addVC.communityName = appDlgt.userData.communityname;
                                addVC.pushType = [NSString stringWithFormat:@"%ld",selfWeak.type];
                                [selfWeak.lastVC.navigationController pushViewController:addVC animated:YES];
                                
                            }
                            
                        }
                        
                    }else {
                        [AppDelegate showToastMsg:data Duration:3.0];
                    }
                    
                    });
            }];
                               
        
    }else {
        
        ///其他页跳转的头视图（认证特权,包含步骤）
        THIndicatorVCStart
        [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
            dispatch_async(dispatch_get_main_queue(), ^{
                        
                THIndicatorVCStopAnimating
                AppDelegate *appDlgt = GetAppDelegates;
                        
                if (resultCode == SucceedCode) {
                            
                    NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                            
                    if (isownercert.intValue == 1) {
                                
                        [AppDelegate showToastMsg:@"当前社区已认证过房产，您可以去我的房产中，认证新的房产" Duration:3.0];
                        return ;
                                
                    }else{
                                
                        NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                        NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                        
                        if (houseArr.count > 0) {
                            
                            //---有房产----
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                            L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                            houseListVC.fromType = 3;
                            houseListVC.houseArr = houseArr;
                            houseListVC.carArr = carArr;
                            houseListVC.communityID = appDlgt.userData.communityid;
                            houseListVC.communityName = appDlgt.userData.communityname;
                            [selfWeak.lastVC.navigationController pushViewController:houseListVC animated:YES];
                            
                        }else {
                            
                            //---无房产----
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                            L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                            addVC.communityID = appDlgt.userData.communityid;
                            addVC.communityName = appDlgt.userData.communityname;
                            addVC.fromType = 3;
                            [selfWeak.lastVC.navigationController pushViewController:addVC animated:YES];
                            
                        }
                                
                    }
                            
                }else{
                            [AppDelegate showToastMsg:data Duration:3.0];
                }
                        
            });
                    
        }];
        
    }

}
@end
