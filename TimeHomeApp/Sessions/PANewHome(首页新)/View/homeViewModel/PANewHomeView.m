//
//  PANewHomeView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeView.h"
#import "PANewHomeBannerView.h"
#import "PAHomeMenuCell.h"
#import "HomeCentralMenuCell.h"
#import "PANewHomeService.h"
#import "PANewHomeNoticeCell.h"
#import "PANewHomeAlertView.h"

@interface PANewHomeView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) PANewHomeService *service;
@property (nonatomic, strong)UITableView * homeTableView;
@property (nonatomic, strong)PANewHomeBannerView * bannerView;
@property (nonatomic,strong) PANewHomeAlertView *alertView;
@end

@implementation PANewHomeView
- (instancetype)init{
    if (self = [super init]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    
    [self addSubview:self.homeTableView];
    // 增加Banner
    UIView * banner = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (kScreenWidth-20)/2.2+20)];
    banner.backgroundColor = UIColorHex(0xF1F1F1);
    self.homeTableView.tableHeaderView = banner;
    [banner addSubview:self.bannerView];
    
    //中间菜单
    [self.homeTableView registerNib:[UINib nibWithNibName:@"HomeCentralMenuCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCentralMenuCell"];
    //增加功能
    [self.homeTableView registerNib:[UINib nibWithNibName:@"PAHomeMenuCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PAHomeMenuCell"];
    //增加公告
    [self.homeTableView registerNib:[UINib nibWithNibName:@"PANewHomeNoticeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PANewHomeNoticeCell"];
    //增加alert
    [self.viewController.tabBarController.view addSubview:self.alertView];
}


#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        return 60;
    }else if(indexPath.row == 0)
    {
        return 180;

    }else if (indexPath.row == 2){
        return 200;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        PAHomeMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PAHomeMenuCell"];
        @WeakObj(self);
        [cell createDataSource:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            [selfWeak.homeTableView reloadData];
        }];
        return cell;
        
    }else if (indexPath.row == 1) {
        
        PANewHomeNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PANewHomeNoticeCell"];
        [self.service loadNoticeSuccess:^(PABaseRequestService *service) {
            [cell setNotificArray:self.service.noticeArray];
        } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        }];
        return cell;
        
    }else if(indexPath.row == 2){
        
        HomeCentralMenuCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCentralMenuCell"];
        return cell;

    }
    return [UITableViewCell new];
  

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel pushNavigation];
}

#pragma mark - init
- (UITableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _homeTableView.delegate = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.estimatedRowHeight = 180;
        _homeTableView.rowHeight = UITableViewAutomaticDimension;
        _homeTableView.dataSource = self;
    }
    return _homeTableView;
}
- (PANewHomeBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[PANewHomeBannerView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, (kScreenWidth-20)/2.2)];
    }
    return _bannerView;
}

-(PANewHomeAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[PANewHomeAlertView alloc]init];
    }
    return _alertView;
}

-(PANewHomeService *)service{
    if (!_service) {
        _service = [[PANewHomeService alloc]init];
    }
    return _service;
}

#pragma mark -Actions
- (void)updateHomeView{
    
    [self.homeTableView reloadData];
    
    @weakify(self);
    [self.service loadBannerSuccess:^(PABaseRequestService *service) {
        @strongify(self);
        [self.bannerView updateWithBannerArray:self.service.bannerArray];
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        @strongify(self);
        [self.bannerView updateWithBannerArray:self.service.bannerArray];
    }];
    
    [self.service loadAlertSuccess:^(PABaseRequestService *service) {
        @strongify(self);
        [self.alertView refreshUIWithAlertDict:self.service.alertDict];
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
    
    //block回调事件
    self.bannerView.callback = ^(UIViewController *controller) {
        if (weak_self.viewModel.bannerBlock) {
            weak_self.viewModel.bannerBlock(controller, nil, 0);
        }
    };
    
    self.alertView.callback = ^(UIViewController *controller) {
        if (weak_self.viewModel.bannerBlock) {
            weak_self.viewModel.bannerBlock(controller, nil, 0);
        }
    };
}


@end
