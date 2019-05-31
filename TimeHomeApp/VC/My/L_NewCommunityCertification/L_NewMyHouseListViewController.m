//
//  L_NewMyHouseListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewMyHouseListViewController.h"
#import "L_BaseMyHouseListTVC.h"

#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_HouseDetailViewController1.h"
#import "L_HouseDetailViewController2.h"
#import "CommunityCertificationVC.h"
#import "THHouseAuthorityViewController.h"
#import "ChangAreaVC.h"

#import "L_PopAlertView2.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "CertificationPopupView.h"

#import "L_AuthoryMyRentorViewController.h"
#import "RaiN_FamilyAuthorizationListVC.h"
#import "L_CommunityAuthoryPresenters.h"


@interface L_NewMyHouseListViewController () <UITableViewDataSource, UITableViewDelegate>

/**
 无数据背景图
 */
@property (weak, nonatomic) IBOutlet UIView *noHouse_BgView;

/**
 认证其他社区
 */
@property (weak, nonatomic) IBOutlet UIView *houseTopView;
@property (weak, nonatomic) IBOutlet UIButton *noDataBottom_Btn;

@property (weak, nonatomic) IBOutlet UIButton *certificationCurretButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation L_NewMyHouseListViewController

#pragma mark - 业主社区房产数据

- (void)httpRequestForGetOwnerCertList {
    
    [L_CommunityAuthoryPresenters getOwnerCertresiUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:data];
                [_tableView reloadData];
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_tableView.mj_header endRefreshing];
                
            });
            
            if (_dataArray.count == 0) {
                _noHouse_BgView.hidden = NO;
                _tableView.hidden = YES;
            }else {
                _noHouse_BgView.hidden = YES;
            }
            
        });
        
    }];
    
}

#pragma mark - 添加认证新社区

- (IBAction)addCommunityCertify:(UIButton *)sender {
    
    NSLog(@"添加认证新社区");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    ChangAreaVC * areaVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
    areaVC.pageSourceType = PAGE_SOURCE_TYPE_COMMUNNITYAUTH;
    [self.navigationController pushViewController:areaVC animated:YES];
    
}

#pragma mark - 认证社区按钮

- (IBAction)twoBtnDidClick:(UIButton *)sender {
    //1.认证当前社区 2.认证其他社区
    
    if (sender.tag == 1) {
        //        _noHouse_BgView.hidden = YES;
        
        L_AddHouseForCertifyCommunityVC *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
        AppDelegate *appDlgt = GetAppDelegates;
        addVC.communityID = appDlgt.userData.communityid;
        addVC.communityName = appDlgt.userData.communityname;
        addVC.fromType = 2;
        [self.navigationController pushViewController:addVC animated:YES];
        
    }
    
    if (sender.tag == 2) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        ChangAreaVC * areaVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
        areaVC.pageSourceType = PAGE_SOURCE_TYPE_COMMUNNITYAUTH;
        [self.navigationController pushViewController:areaVC animated:YES];
        
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCertifyCommunityNeedRefresh object:nil];
}

#pragma mark - 刷新数据

- (void)refreshData {
    
    NSLog(@"收到通知");
    
    _noHouse_BgView.hidden = YES;
    _tableView.hidden = NO;
    
    [_tableView.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"wodefangchan"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"wodefangchan"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    _noDataBottom_Btn.layer.borderColor = PREPARE_MAIN_BLUE_COLOR.CGColor;
    [self.noDataBottom_Btn setTitleColor:PREPARE_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    _noDataBottom_Btn.layer.borderWidth = 1.f;
    
    [self.certificationCurretButton setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
    self.noDataBottom_Btn.layer.cornerRadius = 2;
    self.certificationCurretButton.layer.cornerRadius = 2;
    [self.houseTopView setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_BaseMyHouseListTVC" bundle:nil] forCellReuseIdentifier:@"L_BaseMyHouseListTVC"];
    
    _dataArray = [[NSMutableArray alloc] init];
    _noHouse_BgView.hidden = YES;
    _tableView.hidden = NO;
    
    @WeakObj(self)
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        selfWeak.tableView.hidden = NO;
        [selfWeak httpRequestForGetOwnerCertList];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    [self setupRightNavBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kCertifyCommunityNeedRefresh object:nil];
    
    if (_fromType == 4 || _fromType == 5 || _fromType == 6) {
        
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (tempMarr.count > 0) {
            
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            
            [self.navigationController setViewControllers:tempMarr animated:NO];
            
        }
        
    }
    
}
/**
 需要刷新
 */
- (void)needRefreshData {
    
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 设置导航右按钮

- (void)setupRightNavBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"认证特权" forState:UIControlStateNormal];
    [rightBtn setTitleColor:PREPARE_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = DEFAULT_FONT(14);
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn addTarget:self action:@selector(rightButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

- (void)rightButtonDidClick {
    NSLog(@"认证特权");
    
    if ([_iscurrentVC integerValue]== 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        CertificationPopupView * certificationV = [[CertificationPopupView alloc]init];
        certificationV.type = 1;
        [certificationV showVC:self event:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            
        }];
        
        
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_MyHouseListModel *model = _dataArray[indexPath.section];
    
    return 143;
    
    if (model.state.intValue == 0) {
        return 143-28;
    }else {
        return 143;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BaseMyHouseListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BaseMyHouseListTVC"];
    
    if (_dataArray.count > 0) {
        
        L_MyHouseListModel *model = _dataArray[indexPath.section];
        cell.model = model;
        
        @WeakObj(self);
        cell.cellBtnDidClickBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            NSString * houseID = model.theID;
            if(index == 2){
                
                //撤销
                [selfWeak deleteOneCertificationRecordID:houseID Type:2];
                return ;
                
            }else if (index == 3){
                //删除
                [selfWeak deleteOneCertificationRecordID:houseID Type:3];
                
                return;
            }
            if (model.certtype.intValue == 1) {
                
                //是否业主 1 当前房产业主 0 被授权人
                if (model.isowner.intValue == 1) {
                    
                    //0 未认证 1 认证成功 2 认证失败 90 审核中
                    if (model.state.intValue == 1) {
                        NSLog(@"去授权");
                        
                        [self gotoAuthorywithIndex:indexPath];
                        
                    }
                    
                }
                
            }
            
            if (model.certtype.intValue == 1) {
                
                //是否业主 1 当前房产业主 0 被授权人
                if (model.isowner.intValue == 1) {
                    
                    //0 未认证 1 认证成功 2 认证失败 90 审核中
                    if (model.state.intValue == 0) {
                        
                        NSLog(@"马上认证");
                        
                        THIndicatorVCStart
                        [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:model.communityid UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                THIndicatorVCStopAnimating
                                
                                if (resultCode == SucceedCode) {
                                    
                                    NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                                    NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                                    
                                    if (houseArr.count > 0) {
                                        
                                        //---有房产----
                                        L_CertifyHoustListViewController *houseListVC = [self.storyboard  instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                                        houseListVC.fromType = 2;
                                        houseListVC.houseArr = houseArr;
                                        houseListVC.carArr = carArr;
                                        houseListVC.communityID = model.communityid;
                                        houseListVC.communityName = model.communityname;
                                        [self.navigationController pushViewController:houseListVC animated:YES];
                                        
                                    }else {
                                        
                                        //---无房产----
                                        L_AddHouseForCertifyCommunityVC *addVC = [self.storyboard  instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                                        addVC.communityID = model.communityid;
                                        addVC.communityName = model.communityname;
                                        addVC.fromType = 2;
                                        [self.navigationController pushViewController:addVC animated:YES];
                                        
                                    }
                                    
                                    //                                    }
                                    
                                }else {
                                    [self showToastMsg:data Duration:3.0];
                                }
                                
                            });
                            
                        }];
                        
                    }
                    
                }
                
            }
            
        };
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataArray.count > 0) {
        L_BaseMyHouseListTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
        L_MyHouseListModel *model = _dataArray[indexPath.section];
        
        if (model.isNew) {
            // 新社区不允许跳转
            return;
        }
        //        if (model.istodateshow.intValue == 1) {
        //            [self showToastMsg:[XYString IsNotNull:model.todateshow] Duration:3.0];
        //            return;
        //        }
        
        //    /**
        //     是否业主 1 当前房产业主 0 被授权人
        //     */
        //    @property (nonatomic, strong) NSString *isowner;
        //    /**
        //     认证类型：1 房产 0 业主申请
        //     */
        //    @property (nonatomic, strong) NSString *certtype;
        //    /**
        //     授权类型 0 业主 1 共享 2 出租
        //     */
        //    @property (nonatomic, strong) NSString *type;
        //    /**
        //     0 未认证 1 认证成功 2 认证失败 90 审核中
        //     */
        //    @property (nonatomic, strong) NSString *state;
        
        if (model.certtype.intValue == 0) {
            
            if (model.state.intValue == 2) {
                
                L_HouseDetailViewController1 *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController1"];
                houseDetailVC.certificationType = cell.certificationType;
                houseDetailVC.type = 2;
                houseDetailVC.address = model.address;
                houseDetailVC.resiname = model.resiname;
                houseDetailVC.communityID = model.communityid;
                houseDetailVC.communityName = model.communityname;
                houseDetailVC.theID = model.theID;
                houseDetailVC.remark = model.remark;
                
                houseDetailVC.istodateshow = model.istodateshow;
                houseDetailVC.todateshow = model.todateshow;
                
                [self.navigationController pushViewController:houseDetailVC animated:YES];
                
            }
            
            if (model.state.intValue == 90) {
                
                L_HouseDetailViewController1 *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController1"];
                houseDetailVC.certificationType = cell.certificationType;
                houseDetailVC.type = 1;
                houseDetailVC.address = model.address;
                houseDetailVC.resiname = model.resiname;
                houseDetailVC.communityID = model.communityid;
                houseDetailVC.communityName = model.communityname;
                houseDetailVC.theID = model.theID;
                
                houseDetailVC.istodateshow = model.istodateshow;
                houseDetailVC.todateshow = model.todateshow;
                
                [self.navigationController pushViewController:houseDetailVC animated:YES];
                
            }
            
        }else {
            
            //是否业主 1 当前房产业主 0 被授权人
            if (model.isowner.intValue == 1) {
                
                //model.state 0 未认证 1 认证成功
                
                if (model.state.intValue == 1) {
                    
                    //授权类型 0 业主 1 共享 2 出租
                    if (model.type.intValue == 1) {
                        
                        L_HouseDetailViewController1 *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController1"];
                        houseDetailVC.type = 3;
                        houseDetailVC.certificationType = cell.certificationType;
                        houseDetailVC.communityID = model.communityid;
                        houseDetailVC.communityName = model.communityname;
                        houseDetailVC.theID = model.theID;
                        
                        houseDetailVC.istodateshow = model.istodateshow;
                        houseDetailVC.todateshow = model.todateshow;
                        
                        [self.navigationController pushViewController:houseDetailVC animated:YES];
                        return;
                    }
                    
                    if (model.type.intValue == 2) {
                        
                        L_HouseDetailViewController1 *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController1"];
                        houseDetailVC.type = 4;
                        houseDetailVC.certificationType = cell.certificationType;
                        houseDetailVC.communityID = model.communityid;
                        houseDetailVC.communityName = model.communityname;
                        houseDetailVC.theID = model.theID;
                        
                        houseDetailVC.istodateshow = model.istodateshow;
                        houseDetailVC.todateshow = model.todateshow;
                        
                        [self.navigationController pushViewController:houseDetailVC animated:YES];
                        return;
                    }
                    
                    L_HouseDetailViewController1 *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController1"];
                    houseDetailVC.type = 0;
                    houseDetailVC.certificationType = cell.certificationType;
                    houseDetailVC.communityID = model.communityid;
                    houseDetailVC.communityName = model.communityname;
                    houseDetailVC.theID = model.theID;
                    
                    houseDetailVC.istodateshow = model.istodateshow;
                    houseDetailVC.todateshow = model.todateshow;
                    
                    [self.navigationController pushViewController:houseDetailVC animated:YES];
                    
                }
                
            }
            
            if (model.isowner.intValue == 0) {
                
                //授权类型 0 业主 1 共享 2 出租
                if (model.type.intValue == 1) {
                    
                    L_HouseDetailViewController2 *houseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController2"];
                    houseVC.type = 2;
                    houseVC.theID = model.theID;
                    [self.navigationController pushViewController:houseVC animated:YES];
                    
                }
                
                if (model.type.intValue == 2) {
                    
                    L_HouseDetailViewController2 *houseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HouseDetailViewController2"];
                    houseVC.type = 1;
                    houseVC.theID = model.theID;
                    [self.navigationController pushViewController:houseVC animated:YES];
                    
                }
                
            }
            
        }
        
    }
    
}

#pragma mark - 去授权

- (void)gotoAuthorywithIndex:(NSIndexPath *)indexPath {
    
    L_MyHouseListModel *model = _dataArray[indexPath.section];
    
    if (model.istodateshow.intValue == 1) {
        [self showToastMsg:[XYString IsNotNull:model.todateshow] Duration:3.0];
        return;
    }
    
    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
        
        switch (index) {
            case 0:
            {
                /** 授权给我的家人 */
                RaiN_FamilyAuthorizationListVC *familyList = [[RaiN_FamilyAuthorizationListVC alloc] init];
                
                familyList.theID = model.theID;
                
                [self.navigationController pushViewController:familyList animated:YES];
            }
                break;
            case 1:
            {
                /** 授权给我的租户 */
                L_AuthoryMyRentorViewController *authoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AuthoryMyRentorViewController"];
                authoryVC.theID = model.theID;
                [self.navigationController pushViewController:authoryVC animated:YES];
                
            }
                break;
            default:
                break;
        }
        
    };
    
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        NSLog(@"animation complete");
    };
    
    NSArray *items =
    @[MMItemMake(@"授权给我的家人", MMItemTypeNormal, block),
      MMItemMake(@"授权给我的租户", MMItemTypeNormal, block)];
    
    [[[MMSheetView alloc] initWithTitle:@""
                                  items:items] showWithBlock:completeBlock];
    
}

- (void)deleteOneCertificationRecordID:(NSString *)houseID Type:(NSInteger)type{
    
    NSString * str = @"";
    
    if(type == 2){
        //撤销
        
        str = @"确定要撤销此条记录吗？";
    }else{
        //删除
        str = @"确定要删除此条记录吗？";
        
    }
    NSLog(@"删除");
    @WeakObj(self);
    L_PopAlertView2 *popView = [L_PopAlertView2 getInstance];
    [popView showVC:self withMsg:str cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        NSLog(@"回调");
        
        if (index == 1) {
            
            THIndicatorVCStart
            
            [L_CommunityAuthoryPresenters removeresicertWithID:houseID UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    THIndicatorVCStopAnimating
                    
                    if (resultCode == SucceedCode) {
                        
                        
                        [selfWeak needRefreshData];
                        [selfWeak showToastMsg:data Duration:3.0];
                        
                    }else {
                        [selfWeak showToastMsg:data Duration:3.0];
                    }
                    
                });
                
            }];
            
        }
        
    }];
    popView.msg_Label.textAlignment = NSTextAlignmentCenter;
    
}

@end
