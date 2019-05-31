//
//  RaiN_FamilyAuthorizationListVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_FamilyAuthorizationListVC.h"
#import "RaiN_FamilyListCell.h"
#import "RaiN_AddFamilyVC.h"
#import "WebViewVC.h"
#import "CommunityManagerPresenters.h"
#import "L_CommunityAuthoryPresenters.h"
@interface RaiN_FamilyAuthorizationListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation RaiN_FamilyAuthorizationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"授权给我的家人";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    [self initViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createDataSource];
}

- (void)initViews {
    ///导航按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    [button setTitle:@"帮助" forState:UIControlStateNormal];;
    button.titleLabel.font = DEFAULT_FONT(15);
    [button setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
    [button addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:@"RaiN_FamilyListCell" bundle:nil] forCellReuseIdentifier:@"RaiN_FamilyListCell"];
}

- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [L_CommunityAuthoryPresenters getResiHomeListWithID:_theID andUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                NSArray *arr = data[@"list"];
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:arr];
                if (selfWeak.dataSource.count <= 0) {

                    [selfWeak showNothingnessViewWithType:NoContentTypeCertify Msg:@"点击添加可以为家人授予房产权限" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        [selfWeak createDataSource];
                    }];
                    
                    if (SCREEN_HEIGHT >= 812) {
                        selfWeak.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 8 - statuBar_Height - 44 - bottomSafeArea_Height);
                        
                    }else {
                        selfWeak.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 8 - statuBar_Height - 44);
                    }
                    
                }else {
                    selfWeak.nothingnessView.hidden = YES;
                    [_tableView reloadData];
                }
            }
            else
            {
                [selfWeak showNothingnessViewWithType:NoContentTypeCertify Msg:@"点击添加可以为家人授予房产权限" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    [selfWeak createDataSource];
                }];
                if (SCREEN_HEIGHT >= 812) {
                    selfWeak.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 8 - statuBar_Height - 44 - bottomSafeArea_Height);
                    
                }else {
                    selfWeak.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 8 - statuBar_Height - 44);
                }
                
            }
        });
    }];
}


#pragma mark --- 列表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RaiN_FamilyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RaiN_FamilyListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = _dataSource[indexPath.row][@"remarkname"];
    cell.phoneNumber.text = _dataSource[indexPath.row][@"phone"];
    if (indexPath.row == _dataSource.count - 1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    
    @WeakObj(self)
    cell.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
      
        if (index == 0) {
            //编辑
            
            RaiN_AddFamilyVC *addFamily = [[RaiN_AddFamilyVC alloc] init];
            addFamily.msgArr = @[_dataSource[indexPath.row][@"remarkname"],_dataSource[indexPath.row][@"phone"]];
            addFamily.theID = _dataSource[indexPath.row][@"id"];
            [selfWeak.navigationController pushViewController:addFamily animated:YES];
            
        }else {
            
            //删除
            /**
             *  移除住宅授权信息
             */
            
            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
            NSString *string = [NSString stringWithFormat:@"是否移除%@  %@  的房产权限?",_dataSource[indexPath.row][@"remarkname"],_dataSource[indexPath.row][@"phone"]];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:DEFAULT_FONT(14)}];
            [attributeString addAttribute:NSForegroundColorAttributeName value:BLUE_TEXT_COLOR range:NSMakeRange(4,string.length-10)];
            
            [alertVC ShowAlert:self Title:@"移除" AttributeMsg:attributeString oneBtn:@"取消" otherBtn:@"确定"];
            [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                
                NSLog(@"index=%ld",(long)index);
                
                if (index == 1000) {
                    //确定
                    /**
                     *  移除住宅授权信息
                     */
                    
                    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                    [indicator startAnimating:selfWeak.tabBarController];
                    
                    [CommunityManagerPresenters deleteResidencePowerPowerid:_dataSource[indexPath.row][@"id"] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [indicator stopAnimating];
                            if(resultCode == SucceedCode)
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:kHouseInfoNeedRefresh object:@"3"];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];
                                
                                [selfWeak.dataSource removeObjectAtIndex:indexPath.row];
                                [selfWeak.tableView reloadData];
                                if (selfWeak.dataSource.count <= 0) {
                                    
                                    [selfWeak showNothingnessViewWithType:NoContentTypeCertify Msg:@"点击添加可以为家人授予房产权限" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                        [selfWeak createDataSource];
                                    }];
                                    selfWeak.nothingnessView.hidden = NO;
                                    selfWeak.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 8 - (44+statuBar_Height));
                                }else {
                                    selfWeak.nothingnessView.hidden = YES;
                                }
                                
                                
                            }
                            else
                            {
                                
                                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                            }
                        });
                        
                    }];

                }
                
            }];

        }
        
    };
    
    return cell;
}

#pragma mark ---- 按钮点击事件

/**
 导航右按钮
 */
- (void)helpClick {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = @"http://actives.usnoon.com/Actives/achtml/20170811/index.html";
    webVc.title=@"帮助";
    [self.navigationController pushViewController:webVc animated:YES];
}

/**
 添加按钮
 */
- (IBAction)addFamily:(id)sender {

    RaiN_AddFamilyVC *addFamily = [[RaiN_AddFamilyVC alloc] init];
    addFamily.msgArr = nil;
    addFamily.theID = _theID;
    [self.navigationController pushViewController:addFamily animated:YES];
}


@end
