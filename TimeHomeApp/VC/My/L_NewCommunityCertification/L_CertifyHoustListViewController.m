//
//  L_CertifyHoustListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CertifyHoustListViewController.h"

#import "L_CertifyListBaseTVC1.h"
#import "L_CertifyListBaseTVC2.h"
#import "L_PopAlertView1.h"
#import "L_PopAlertView2.h"
#import "CertificationSuccessfulVC.h"
#import "L_CommunityAuthoryPresenters.h"
#import "AppSystemSetPresenters.h"
#import "MainTabBars.h"

@interface L_CertifyHoustListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation L_CertifyHoustListViewController

#pragma mark - 一键认证请求

- (void)httpRequestForAkeyCert {
    
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters akeyCertWithCommunityid:_communityID UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                if (_fromType == 1 || _fromType == 2 || _fromType == 3) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];
                }
                NSString *errmsg = [data objectForKey:@"errmsg"];
                [self showToastMsg:errmsg Duration:3.0];
                
                CertificationSuccessfulVC *success = [[CertificationSuccessfulVC alloc] init];
                if (_type == 1) {
                    success.pushType = @"0";
                    success.isMyPush = @"0";
                }else {
                    success.pushType = @"1";
                    //1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
                    if (_fromType == 1 || _fromType == 2 || _fromType == 3) {
                        success.isMyPush = @"1";
                    }else {
                        success.isMyPush = @"0";
                    }
                }
                success.fromType = _fromType;
                success.communityName = _communityName;
                [self.navigationController pushViewController:success animated:YES];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

- (void)backButtonClick {
    
    if (_type == 1) {
        
        L_PopAlertView2 *popView = [L_PopAlertView2 getInstance];
        [popView showVC:self withMsg:@"还没完成业主认证，确定要进入平安社区吗？" cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            NSLog(@"回调");
            
            if (index == 1) {
                AppDelegate *appDelegate = GetAppDelegates;
                ///绑定标签
                [AppSystemSetPresenters getBindingTag];
                
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                appDelegate.window.rootViewController=MainTabBar;
                
                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
            }
        }];
        
    }else {
        
        [super backButtonClick];
        
    }
    
}

#pragma mark - 申请认证
- (IBAction)certifyBtnDidTouch:(UIButton *)sender {
    
    NSLog(@"申请认证");

    [self httpRequestForAkeyCert];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"L_CertifyListBaseTVC1" bundle:nil] forCellReuseIdentifier:@"L_CertifyListBaseTVC1"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_CertifyListBaseTVC2" bundle:nil] forCellReuseIdentifier:@"L_CertifyListBaseTVC2"];
    
    [self setupRightNavBtn];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"faqirenzheng"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"faqirenzheng"];
}

#pragma mark - 设置导航右按钮

- (void)setupRightNavBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"社区认证-问题"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}
- (void)rightButtonDidClick {
    NSLog(@"导航右按钮点击");
    if (_type == 1) {
        
        L_PopAlertView1 *popView = [L_PopAlertView1 getInstance];
        [popView showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            NSLog(@"回调");
            if (index == 2) {
                AppDelegate *appDelegate = GetAppDelegates;
                ///绑定标签
                [AppSystemSetPresenters getBindingTag];
                
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                appDelegate.window.rootViewController=MainTabBar;
                
                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
            }
        }];
        
    }else {
        
        L_PopAlertView1 *popView = [L_PopAlertView1 getInstance];
        popView.type = 1;
        [popView showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            NSLog(@"回调");
        }];
        
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _houseArr.count + _carArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section < _houseArr.count) {
        L_ResiListModel *model = _houseArr[indexPath.section];
        return model.height;
    }else {
        L_ResiCarListModel *model = _carArr[indexPath.section-_houseArr.count];
        return model.height;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < _houseArr.count) {
        
        L_CertifyListBaseTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CertifyListBaseTVC1"];
        
        L_ResiListModel *model = _houseArr[indexPath.section];
        cell.model = model;
        
        return cell;
        
    }else {
        
        L_CertifyListBaseTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CertifyListBaseTVC2"];
        
        L_ResiCarListModel *model = _carArr[indexPath.section-_houseArr.count];
        cell.model = model;
        
        return cell;
        
    }

}



@end
