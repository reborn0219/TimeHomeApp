//
//  L_HouseDetailViewController1.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailViewController1.h"
#import "L_HouseDetailBaseTVC1.h"
#import "L_HouseDetailBaseTVC2.h"
#import "L_HouseDetailBaseTVC3.h"
#import "L_HouseDetailBaseTVC4.h"
#import "ContactServiceVC.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_PopAlertView2.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "L_AuthoryMyRentorViewController.h"
#import "RaiN_FamilyAuthorizationListVC.h"

#import "L_CommunityAuthoryPresenters.h"

#import "CommunityManagerPresenters.h"
#import "THHouseReletViewController.h"

@interface L_HouseDetailViewController1 () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) L_HouseInfoModel *houseInfoModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 底部按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bottom_Button;

@property (weak, nonatomic) IBOutlet UIView *bottomBtn_BgView;

@property (nonatomic, strong) L_PowerListModel *powerModel;

@end

@implementation L_HouseDetailViewController1

#pragma mark - 房产详情

- (void)httpRequestForGetInfo {
    
    [L_CommunityAuthoryPresenters getResiInfoWithID:_theID UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (resultCode == SucceedCode) {
                
                _houseInfoModel = (L_HouseInfoModel *)data;
                _houseInfoModel.infoType = _type;
                
                if (_type == 4) {
                    _powerModel = _houseInfoModel.powerlist[0];
                }
                
                if (_type == 3) {
                    
                    if (_houseInfoModel.powerlist.count <= 0) {
                        
                        _type = 0;
                        _houseInfoModel.infoType = _type;

                    }
                    
                }

                [_tableView reloadData];

            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [_tableView.mj_header endRefreshing];
                [self setupBottomBtn];

            });
        
        });
        
    }];
    
}

- (IBAction)addBtnDidTouch:(UIButton *)sender {
    
    if (self.istodateshow.intValue == 1) {
        [self showToastMsg:[XYString IsNotNull:self.todateshow] Duration:3.0];
        return;
    }
    
    if (_type == 0) {
        
        NSLog(@"授权授权房产权限");
        
        [self gotoAuthory];
        
    }
    
    if (_type == 1) {
        
        NSLog(@"联系物业");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        ContactServiceVC * contactsVC = [storyboard instantiateViewControllerWithIdentifier:@"ContactServiceVC"];
        contactsVC.isFromBikeInfo = YES;
        contactsVC.communityID = _communityID;
        [self.navigationController pushViewController:contactsVC animated:YES];
        
    }
    
    if (_type == 2) {
        
        NSLog(@"重新认证");
        
        L_AddHouseForCertifyCommunityVC *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
        addVC.fromType = 1;
        addVC.communityID = _communityID;
        addVC.communityName = _communityName;
        [self.navigationController pushViewController:addVC animated:YES];
        
    }
    
    if (_type == 3) {
        
        NSLog(@"添加授权共享");
        
        [self gotoAuthory];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _houseInfoModel = [[L_HouseInfoModel alloc] init];
    _houseInfoModel.infoType = _type;
    _houseInfoModel.remark = _remark;
    _houseInfoModel.communityid = _communityID;
    _houseInfoModel.communityname = _communityName;
    _houseInfoModel.address = _address;
    _houseInfoModel.resiname = _resiname;
    _houseInfoModel.theID = _theID;
    
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;

    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailBaseTVC1" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailBaseTVC1"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailBaseTVC2" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailBaseTVC2"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailBaseTVC3" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailBaseTVC3"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailBaseTVC4" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailBaseTVC4"];

    [self setupBottomBtn];
    
    @WeakObj(self);
    if (_type == 0 || _type == 3 || _type == 4) {
        _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
            [selfWeak httpRequestForGetInfo];
        }];
    }

    
    if (_type == 0 || _type == 3 || _type == 4) {
        [_tableView.mj_header beginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kHouseInfoNeedRefresh object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHouseInfoNeedRefresh object:nil];
}

#pragma mark - 刷新数据

- (void)refreshData:(NSNotification *)notify {
    
    NSLog(@"notify.object===%@",notify.object);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *str = notify.object;
        _type = str.integerValue;
//        [self setupBottomBtn];
        
        [_tableView.mj_header beginRefreshing];
        
    });

}

#pragma mark - 底部按钮状态

- (void)setupBottomBtn {
    
    [_bottom_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottom_Button setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
    _bottom_Button.layer.cornerRadius = 2;
    if (_type == 0) {
        _bottomBtn_BgView.hidden = NO;
        [_bottom_Button setTitle:@"授 权 房 产 权 限" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (_type == 1) {
        _bottomBtn_BgView.hidden = NO;
        [_bottom_Button setTitle:@"联 系 物 业" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (_type == 2) {
        _bottomBtn_BgView.hidden = NO;
        [_bottom_Button setTitle:@"重 新 认 证" forState:UIControlStateNormal];
        [self setupRightNavBtn];
    }
    
    if (_type == 3) {
        _bottomBtn_BgView.hidden = NO;
        [_bottom_Button setTitle:@"添 加 授 权 共 享" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (_type == 4) {
        _bottomBtn_BgView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}


#pragma mark - 设置导航右按钮

- (void)setupRightNavBtn {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kNewRedColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = DEFAULT_FONT(14);
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn addTarget:self action:@selector(rightButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

- (void)rightButtonDidClick {
    
    NSLog(@"删除");
    
    L_PopAlertView2 *popView = [L_PopAlertView2 getInstance];
    [popView showVC:self withMsg:@"确定要删除此条记录吗？" cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        NSLog(@"回调");
        
        if (index == 1) {
            
            THIndicatorVCStart
            
            [L_CommunityAuthoryPresenters removeresicertWithID:_theID UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    THIndicatorVCStopAnimating
                    
                    if (resultCode == SucceedCode) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];

                        [self showToastMsg:data Duration:3.0];
                        [self.navigationController popViewControllerAnimated:YES];

                    }else {
                        [self showToastMsg:data Duration:3.0];
                    }
                    
                });
                
            }];
            
        }
        
    }];
    popView.msg_Label.textAlignment = NSTextAlignmentCenter;
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_type == 0 || _type == 1 || _type == 2) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        if (_type == 4) {
            return 1;
        }else {
            return _houseInfoModel.powerlist.count+1;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return _houseInfoModel.height;
    }else {
        if (_type == 4) {
//            L_PowerListModel *powerModel = _houseInfoModel.powerlist[0];
            if (_powerModel.height > 0) {
                return _powerModel.height;
            }else {
                return 120;
            }
        }else {
            if (indexPath.row == 0) {
                return 40;
            }
            return 42;
        }

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        L_HouseDetailBaseTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailBaseTVC1"];
        cell.certificationType = self.certificationType;
        cell.model = _houseInfoModel;
        return cell;
        
    }else {
        
        if (_type == 3) {
            
            if (indexPath.row == 0) {
                
                L_HouseDetailBaseTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailBaseTVC2"];
                
                return cell;
                
            }else {
                
                L_HouseDetailBaseTVC3 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailBaseTVC3"];
                
                cell.bottomLine.hidden = NO;

                if (indexPath.row == _houseInfoModel.powerlist.count) {
                    cell.bottomLine.hidden = YES;
                }
                
                if (_houseInfoModel.powerlist.count > 0) {
                    L_PowerListModel *powerModel = _houseInfoModel.powerlist[indexPath.row - 1];
                    cell.model = powerModel;
                }
                
                return cell;
                
            }
            
        }else {
            
            L_HouseDetailBaseTVC4 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailBaseTVC4"];
            
//            L_PowerListModel *powerModel = _houseInfoModel.powerlist[0];
            _powerModel.rentbegindate = _houseInfoModel.rentbegindate;
            _powerModel.rentenddate = _houseInfoModel.rentenddate;
            cell.model = _powerModel;
            
            cell.selectBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
              
                NSLog(@"点击了%ld",(long)index);
                //出租  1. 移除 2.续租
                
                if (self.istodateshow.intValue == 1) {
                    [self showToastMsg:[XYString IsNotNull:self.todateshow] Duration:3.0];
                    return;
                }
                
                if (index == 1) {
                    
                    //移除
                    CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                    NSString *string = [NSString stringWithFormat:@"是否移除%@  %@  的房产权限?",_powerModel.remarkname,_powerModel.phone];
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:DEFAULT_FONT(14)}];
                    [attributeString addAttribute:NSForegroundColorAttributeName value:BLUE_TEXT_COLOR range:NSMakeRange(4,string.length-10)];
                    
                    [alertVC ShowAlert:self Title:@"移除" AttributeMsg:attributeString oneBtn:@"取消" otherBtn:@"确定"];
                    [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                     {
                         NSLog(@"index=%ld",(long)index);
                         if (index == 1000) {
                             //确定
                             /**
                              *  移除住宅授权信息
                              */

                             THIndicatorVCStart
                             [CommunityManagerPresenters deleteResidencePowerPowerid:_powerModel.theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     THIndicatorVCStopAnimating
                                     
                                     if(resultCode == SucceedCode) {
                                         
                                         [self showToastMsg:@"移除成功" Duration:3.0];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];

                                         _type = 0;
                                         
                                         [self setupBottomBtn];

                                         [_tableView reloadData];
                                         
                                     }else {
                                         [self showToastMsg:data Duration:3.0];
                                     }
                                 });
                                 
                             }];
                             
                         }
                         
                     }];

                }
                
                if (index == 2) {
                    
                    THHouseReletViewController *reletVC = [[THHouseReletViewController alloc]init];
                    reletVC.type = 0;
                    /**
                     *  回调刷新数据
                     */
                    reletVC.callBack = ^(){
                        
                        [self httpRequestForGetInfo];
                        
                    };
                    reletVC.theID = _houseInfoModel.theID;
                    
                    NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_houseInfoModel.rentenddate] withFormat:@"yyyy-MM-dd hh:mm:ss"];
                    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
//                    NSDate *nextDate2 = [NSDate dateWithTimeInterval:24*60*60*2 sinceDate:date];//后二天
                    
                    NSString *nextDateString = [XYString NSDateToString:nextDate withFormat:@"yyyy-MM-dd hh:mm:ss"];
//                    NSString *nextDate2String = [XYString NSDateToString:nextDate2 withFormat:@"yyyy-MM-dd hh:mm:ss"];
                    
                    NSDate *newdate = [XYString addMonthCount:1 fromDate:nextDate];
                    
                    NSLog(@"newdate =%@",newdate);
                    
                    NSString *nextDate2String = [XYString NSDateToString:newdate withFormat:@"yyyy-MM-dd hh:mm:ss"];

                    reletVC.rentbegindate = nextDateString;
                    reletVC.rentenddate = nextDate2String;
                    [self.navigationController pushViewController:reletVC animated:YES];
                    
                }
                
            };
            
            return cell;
            
        }
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_type == 3) {
        
        if (indexPath.row > 0) {
            NSLog(@"共享移除");
            
            if (self.istodateshow.intValue == 1) {
                [self showToastMsg:[XYString IsNotNull:self.todateshow] Duration:3.0];
                return;
            }
            
            L_PowerListModel *powerModel = _houseInfoModel.powerlist[indexPath.row - 1];

            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
            NSString *string = [NSString stringWithFormat:@"是否移除%@  %@  的房产权限?",powerModel.remarkname,powerModel.phone];
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
                     
                     THIndicatorVCStart
                     [CommunityManagerPresenters deleteResidencePowerPowerid:powerModel.theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             THIndicatorVCStopAnimating
                             
                             if(resultCode == SucceedCode) {
                                 
                                 [self showToastMsg:@"移除成功" Duration:3.0];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kCertifyCommunityNeedRefresh object:nil];

                                 NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:_houseInfoModel.powerlist];
                                 [mutableArr removeObjectAtIndex:indexPath.row - 1];
                                 _houseInfoModel.powerlist = [mutableArr copy];
                                 
                                 if (_houseInfoModel.powerlist.count > 0) {
                                     _type = 3;
                                 }else {
                                     _type = 0;
                                 }
                                 
                                 [self setupBottomBtn];

                                 [_tableView reloadData];
                                 
//                                 [_tableView.mj_header beginRefreshing];
                                 
                             }else {
                                 
                                 [self showToastMsg:data Duration:2.0];
                                 
                             }
                             
                         });
                         
                     }];
                     
                 }
                 
             }];

            
        }
    }
    
}

#pragma mark - 去授权

- (void)gotoAuthory {
    
    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
        
        switch (index) {
            case 0:
            {
                /** 授权给我的家人 */
                RaiN_FamilyAuthorizationListVC *familyList = [[RaiN_FamilyAuthorizationListVC alloc] init];
                familyList.theID = _houseInfoModel.theID;
                [self.navigationController pushViewController:familyList animated:YES];
                
            }
                break;
            case 1:
            {
                /** 授权给我的租户 */
                L_AuthoryMyRentorViewController *authoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AuthoryMyRentorViewController"];
                
//                if (_houseInfoModel.powerlist.count > 0) {
//                    authoryVC.isNeedMsg = YES;
//                }else {
//                    authoryVC.isNeedMsg = NO;
//                }
                
                //0 已通过认证 1 审核中 2 未通过审核 3 已通过认证 共享 4 已通过认证 出租
                if (_type == 3) {
                    authoryVC.isNeedMsg = YES;
                }else {
                    authoryVC.isNeedMsg = NO;
                }
                
                authoryVC.type = 1;
                authoryVC.theID = _houseInfoModel.theID;

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

@end
