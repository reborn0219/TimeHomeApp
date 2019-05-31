//
//  communityCertificationVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CommunityCertificationVC.h"

///系统设置接口
#import "AppSystemSetPresenters.h"
#import "MainTabBars.h"

///聊天
#import "ChatPresenter.h"
#import "Gam_Chat.h"
#import "DataOperation.h"
#import "XMMessage.h"

///工具类
#import "DateUitls.h"

///九宫格cell 和 headerView
#import "NibCell.h"
#import "CertificationHeaderView.h"
#import "CertificationSuccessfulVC.h"
#import "CertificationPrivilegeHeaderView.h"

#import "SubmittedToExamineAlert.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_NewMyHouseListViewController.h"

#import "L_CommunityAuthoryPresenters.h"

@interface CommunityCertificationVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
}
@end

@implementation CommunityCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    [self setViews];
    
    ///创建collection和数据
    [self createCollection];
    [self createDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_pushType isEqualToString:@"1"]) {
        
//        [TalkingData trackPageBegin:@"renzhengtequan"];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([_pushType isEqualToString:@"1"]) {
        
//        [TalkingData trackPageEnd:@"renzhengtequan"];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([_pushType isEqualToString:@"0"]) {
        /** rootViewController不允许侧滑 */
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/**
 UI设置
 */
- (void)setViews {
    
    if ([_pushType isEqualToString:@"0"]) {
        self.navigationItem.title = @"社区认证";
        ///导航按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        [button setTitle:@"暂不认证" forState:UIControlStateNormal];;
        button.titleLabel.font = DEFAULT_FONT(15);
        [button setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        [button addTarget:self action:@selector(noCertification:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 15, 15);
        UIImage *image = [UIImage imageNamed:@"业主认证关闭"];
        [leftButton setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = backButton;
 
    }else {
        self.navigationItem.title = @"社区认证特权";
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 25, 25);
        UIImage *image = [UIImage imageNamed:@"返回"];
        [leftButton setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
}


#pragma mark ------ 创建九宫格 and dataSource

/**
 九宫格
 */
- (void)createCollection {
    
    UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
//    NSInteger interSpacing = 20;
//    NSInteger lineSpacing = 30;
//    viewFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - interSpacing * 2 - 30 )/3 - 1 , (SCREEN_WIDTH - interSpacing * 3)/3 - 1);
    NSInteger interSpacing = 10;
    NSInteger lineSpacing = 30;
    viewFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - interSpacing * 2 - 40 )/3.6 - 1 , (SCREEN_WIDTH - interSpacing * 3)/4.5 - 1);
    if ([_pushType isEqualToString:@"0"]) {
        viewFlowLayout.headerReferenceSize=CGSizeMake(SCREEN_WIDTH, 275); //设置collectionView头视图的大小
    }else {
        viewFlowLayout.headerReferenceSize=CGSizeMake(SCREEN_WIDTH, 230); //设置collectionView头视图的大小
    }
    
    viewFlowLayout.minimumInteritemSpacing = interSpacing;
    viewFlowLayout.minimumLineSpacing = lineSpacing;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = viewFlowLayout;
    _collectionView.showsHorizontalScrollIndicator = NO; // 去掉滚动条
    _collectionView.showsVerticalScrollIndicator = NO; // 去掉滚动条
    [_collectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"NibCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"CertificationHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CertificationHeaderView"];
    [_collectionView registerNib:[UINib nibWithNibName:@"CertificationPrivilegeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CertificationPrivilegeHeaderView"];
    
}
/**
 数据源
 */
- (void)createDataSource {
    if (!imageArr) {
        imageArr = [[NSMutableArray alloc] init];
    }
    
    [imageArr addObjectsFromArray:@[@"专属服务",@"智能门禁",@"邀请同行",@"在线报修",@"意见建议",@"共享房产",@"智能梯控",@"发帖",@"更多"]];
    
    if (!titleArr) {
        titleArr = [[NSMutableArray alloc] init];
    }
    
    [titleArr addObjectsFromArray:@[@"专属标识",@"智能门禁",@"邀请访客",@"在线报修",@"投诉建议",@"房产共享",@"智能梯控",@"发帖特权",@"敬请期待"]];
}


#pragma mark ---- 九宫格代理

#pragma mark -- collectiuonViewDelegate,collectiuonViewDateSource


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            if ([_pushType isEqualToString:@"0"]) {
                
                ///注册页跳转的头视图（注册成功后跳转的页面）
                CertificationHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CertificationHeaderView" forIndexPath:indexPath];
                
                ///一键认证
                header.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    THIndicatorVCStart
                    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            THIndicatorVCStopAnimating
                            
                            AppDelegate *appDlgt = GetAppDelegates;

                            if (resultCode == SucceedCode) {
                                
                                NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                                
                                if (isownercert.intValue == 1) {
                                    
                                    [self showToastMsg:@"当前社区已认证过房产，您可以去我的房产中，认证新的房产" Duration:3.0];
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
                                        [self.navigationController pushViewController:houseListVC animated:YES];
                                        
                                    }else {
                                        
                                        //---无房产----
                                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                        L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                                        addVC.communityID = appDlgt.userData.communityid;
                                        addVC.communityName = appDlgt.userData.communityname;
                                        addVC.pushType = @"0";
                                        [self.navigationController pushViewController:addVC animated:YES];
                                        
                                    }
                                    
                                }
                                
                            }else {
                                [self showToastMsg:data Duration:3.0];
                            }
                            
                        });
                        
                    }];
                    
                };
                
                return header;
                
            }else {
                ///其他页跳转的头视图（认证特权,包含步骤）
                CertificationPrivilegeHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CertificationPrivilegeHeaderView" forIndexPath:indexPath];
                
                @WeakObj(self)
                header.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    if (index == 0) {
                        ///一键认证
                        
                        THIndicatorVCStart
                        [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                THIndicatorVCStopAnimating
                                
                                AppDelegate *appDlgt = GetAppDelegates;

                                if (resultCode == SucceedCode) {
                                    
                                    NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                                    
                                    if (isownercert.intValue == 1) {
                                        
                                        [self showToastMsg:@"当前社区已认证过房产，您可以去我的房产中，认证新的房产" Duration:3.0];
                                        return ;
                                        
                                    }else {
                                    
                                        NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                                        NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                                        
                                        if (houseArr.count > 0) {
                                            
                                            //---有房产----
                                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                            L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                                            houseListVC.fromType = _fromType;
                                            houseListVC.houseArr = houseArr;
                                            houseListVC.carArr = carArr;
                                            houseListVC.communityID = appDlgt.userData.communityid;
                                            houseListVC.communityName = appDlgt.userData.communityname;
                                            [self.navigationController pushViewController:houseListVC animated:YES];
                                            
                                        }else {
                                            
                                            //---无房产----
                                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                            L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                                            addVC.communityID = appDlgt.userData.communityid;
                                            addVC.communityName = appDlgt.userData.communityname;
                                            addVC.fromType = _fromType;
                                            [self.navigationController pushViewController:addVC animated:YES];
                                            
                                        }
                                        
                                    }
                                    
                                }else {
                                    [self showToastMsg:data Duration:3.0];
                                }
                                
                            });
                            
                        }];

                    }else {
                        ///查看我的房产
                        NSLog(@"查看我的房产");
                        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                        NSString *isHave;
                        for (UIViewController *vc in marr) {
                            if ([vc isKindOfClass:[L_NewMyHouseListViewController class]]) {
                                isHave = @"1";
                                break;
                            }
                        }
                        ///如果栈中有我的房产页面，则pop，反之，push
                        if ([isHave isEqualToString:@"1"]) {
                            
                         [selfWeak.navigationController popViewControllerAnimated:YES];
                            
                        }else {
                            
                        
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                            L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                            houseListVC.iscurrentVC = @"1";
                            [selfWeak.navigationController pushViewController:houseListVC animated:YES];
                            
                            
                        }
                    }
                };
                
                return header;
                
            }

        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NibCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NibCell" forIndexPath:indexPath];
    cell.iconImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.textLabel.text = titleArr[indexPath.row];
    return cell;
    
}

#pragma mark ------ 按钮点击事件

//导航右按钮
- (void)noCertification:(UIButton *)button {

    AppDelegate *appDelegate = GetAppDelegates;
    ///绑定标签
    [AppSystemSetPresenters getBindingTag];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
    MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
    appDelegate.window.rootViewController=MainTabBar;
    
    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
    [MainTabBar.view.window.layer addAnimation:animation forKey:nil];

}

/**
 导航返回按钮
 */
- (void)backButtonClick {
    
    if ([_pushType isEqualToString:@"0"]) {
        
        AppDelegate *appDelegate = GetAppDelegates;
        ///绑定标签
        [AppSystemSetPresenters getBindingTag];
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
        MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
        appDelegate.window.rootViewController=MainTabBar;
        
        CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
        [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
