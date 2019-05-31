//
//  PACertificationAlertManager.m
//  TimeHomeApp
//
//  Created by ning on 2018/7/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACertificationAlertManager.h"
#import "MessageAlert.h"
#import "L_NewMyHouseListViewController.h"
#import "L_CommunityAuthoryPresenters.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_CertifyHoustListViewController.h"

@interface PACertificationAlertManager()
@property (nonatomic,strong)  BaseViewController *controller;
@end

@implementation PACertificationAlertManager

#pragma mark - Lifecycle
- (instancetype)initWithVC:(BaseViewController *)VC{
    self = [super init];
    if(self){
        self.controller = VC;
    }
    return self;
}

#pragma mark - Actions
/**
 检验认证权限
 */
-(void)certificationPopupType:(NSInteger)type{
    @WeakObj(self);
    if (type == 0) {
        ///未认证
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        [msgAlert showInVC:self.controller withTitle:@"请先认证为本小区的业主，您才可以使用此功能" andCancelBtnTitle:@"" andOtherBtnTitle:@"去认证"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
            if (index==Ok_Type) {
                NSLog(@"---跳转认证");
                [selfWeak goToCertification];
            }
        };
    }else if (type == 9) {
        ///审核中
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        [msgAlert showInVC:self.controller withTitle:@"当前社区已提交过认证，请耐心等待物业为您审核通过后即可正常使用" andCancelBtnTitle:@"" andOtherBtnTitle:@"去我的房产"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
            if (index==Ok_Type) {
                NSLog(@"---跳转我的房产");
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                houseListVC.iscurrentVC = @"1";
                [selfWeak.controller.navigationController pushViewController:houseListVC animated:YES];
            }
        };
    }
}

/**
 跳转认证页
 */
- (void)goToCertification{
    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultCode == SucceedCode) {
                NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                AppDelegate *appDlgt = GetAppDelegates;
                if (houseArr.count > 0) {
                    //---有房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                    houseListVC.fromType = 5;
                    houseListVC.houseArr = houseArr;
                    houseListVC.carArr = carArr;
                    houseListVC.communityID = appDlgt.userData.communityid;
                    houseListVC.communityName = appDlgt.userData.communityname;
                    [houseListVC setHidesBottomBarWhenPushed:YES];
                    [self.controller.navigationController pushViewController:houseListVC animated:YES];
                }else {
                    //---无房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                    addVC.fromType = 5;
                    addVC.communityID = appDlgt.userData.communityid;
                    addVC.communityName = appDlgt.userData.communityname;
                    [addVC setHidesBottomBarWhenPushed:YES];
                    [self.controller.navigationController pushViewController:addVC animated:YES];
                }
            }else {
                [self.controller showToastMsg:data Duration:3.0];
            }
        });
    }];
}

@end
