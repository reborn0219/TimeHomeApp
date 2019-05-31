//
//  L_CarErrorApplyViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarErrorApplyViewController.h"
#import "KeyboardCollectionCell.h"
#import "L_CarErrorAlertVC.h"

#import "L_CarErrorPresenter.h"
#import "CommunityManagerPresenters.h"
#import "SysPresenter.h"

#import "PopListVC.h"

#import "L_CarNumberErrorViewController.h"
#import "RegularUtils.h"

#import "L_CarlistPopVC.h"

@interface L_CarErrorApplyViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;/** 高度 */

@property (weak, nonatomic) IBOutlet UIButton *contactPropertyBtn;/** 联系物业 */

@property (nonatomic, strong) NSString *propertyPhone;/** 物业电话 */

@property (weak, nonatomic) IBOutlet UITextField *phoneNum_TF;/** 手机号 */

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSArray *gateArray;/** 门口数组 */

@property (nonatomic, strong) NSArray *carNumArray;/** 车牌数组 */
@property (nonatomic, strong) NSString *currentCarNum;/** 当前选中的车牌号 */

@property (nonatomic, strong) L_CorrgateModel *currentGateModel;/** 当前选择的门口model */

@property (weak, nonatomic) IBOutlet UILabel *gate_Label;/** 选择门口 */
@property (weak, nonatomic) IBOutlet UILabel *rightCarNum_Label;/** 正确车牌号 */

@end

@implementation L_CarErrorApplyViewController

#pragma mark - 接口请求
/**
 获得车牌纠错需要的门口
 
 @param card 车牌号
 */
- (void)httpRequestForGetCorrgateWithCard:(NSString *)card {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_CarErrorPresenter getcorrgateWithCard:card updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                _gateArray = (NSArray *)data;
                if (_gateArray.count > 0) {
                    [self showPopViewWithType:1];
                }else {
                    _gate_Label.text = @"无";
                    [self showToastMsg:@"暂无门口信息" Duration:3.0];
                }
                
            }else {
                
                _gate_Label.text = @"无";
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}

/**
 保存车牌纠错申请
 
 @param card 车牌号
 @param aisleid 门口进口id
 */
- (void)httpRequestForSaveApplyWithCard:(NSString *)card withAisleid:(NSString *)aisleid {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_CarErrorPresenter saveApplyWithCard:card withAisleid:aisleid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                _currentCarNum = @"";
                _gate_Label.text = @"";
                _rightCarNum_Label.text = @"";
                
                _currentGateModel = [[L_CorrgateModel alloc] init];
                
                [[L_CarErrorAlertVC getInstance] showVC:self withMsg:nil withType:1 withBlock:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    L_CarNumberErrorViewController *carErrorVC = (L_CarNumberErrorViewController *)self.parentViewController;
                    [carErrorVC secondBtnDidTouch];
                    
                }];
                
            }else {
                
                if ([data isKindOfClass:[NSString class]]) {
                    [self showToastMsg:data Duration:3.0];
                }else {
                    
                    if (data==nil || ![data isKindOfClass:[NSDictionary class]]) {
                        return ;
                    }
                    NSString * errmsg = [data objectForKey:@"errmsg"];
                    if (![XYString isBlankString:errmsg]) {
                        [[L_CarErrorAlertVC getInstance] showVC:self withMsg:errmsg withType:2 withBlock:nil];
                    }
                    
                }
                
            }
            
        });
        
    }];
    
}

/**
 获取物业电话
 */
- (void)httpRequestForGetPropertyPhones {
    
    [CommunityManagerPresenters getPropertyPhoneUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSArray *arr = (NSArray *)data;
                if (arr.count > 0) {
                    _propertyPhone = [XYString IsNotNull:arr[0][@"telephone"]];
                }
                if ([XYString isBlankString:_propertyPhone]) {
                    _contactPropertyBtn.hidden = YES;
                }else {
                    _contactPropertyBtn.hidden = NO;
                }
                
            }else {
                _contactPropertyBtn.hidden = YES;
            }
            
        });
        
    }];
    
}

/**
 获得当前用户关联车牌列表
 */
- (void)httpRequestForGetCorrardList {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [L_CarErrorPresenter getCorrardUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                _carNumArray = (NSArray *)data;
                if (_carNumArray.count > 0) {
                    [self showPopViewWithType:2];
                }else {
                    _rightCarNum_Label.text = @"无";
                    [self showToastMsg:@"暂无车牌号信息" Duration:3.0];
                }
                
            }else {
                
                _rightCarNum_Label.text = @"无";
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}

/**
 获得当前车牌的保存状态
 
 @param card 车牌号
 */
- (void)httpRequestForGetCardStateWithCard:(NSString *)card {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [L_CarErrorPresenter getCardStateWithCard:card UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                _currentCarNum = card;
                _rightCarNum_Label.text = [XYString IsNotNull:_currentCarNum];
                
            }else {
                
                _currentCarNum = @"";
                _rightCarNum_Label.text = @"无";
                
                if ([data isKindOfClass:[NSString class]]) {
                    [self showToastMsg:data Duration:3.0];
                }else {
                    
                    if (data==nil || ![data isKindOfClass:[NSDictionary class]]) {
                        return ;
                    }
                    NSString * errmsg = [data objectForKey:@"errmsg"];
                    if (![XYString isBlankString:errmsg]) {
                        [[L_CarErrorAlertVC getInstance] showVC:self withMsg:errmsg withType:2 withBlock:nil];
                    }
                    
                }
                
            }
            
        });
        
    }];
    
}

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SCREEN_HEIGHT == 480) {
        _heightLayoutConstraint.constant = 480;
    }else {
        _heightLayoutConstraint.constant = SCREEN_HEIGHT - (44+statuBar_Height) - 56 - 8;
    }
    
    _contactPropertyBtn.hidden = YES;
    _propertyPhone = @"";
    _gate_Label.text = @"";
    _rightCarNum_Label.text = @"";
    _currentCarNum = @"";
    
    [self httpRequestForGetPropertyPhones];/** 获取物业电话 */
    
    _phoneNum_TF.enabled = NO;
    AppDelegate *appDglt = GetAppDelegates;
    _phoneNum_TF.text = [XYString IsNotNull:appDglt.userData.phone];
    
}

#pragma mark - 显示弹窗

/**
 显示弹窗
 
 @param type 1.大门弹框 2.正确车牌号弹窗
 */
- (void)showPopViewWithType:(int)type {
    
    if (type == 1) {
        
        if (_gateArray.count <= 0) {
            return;
        }
        
        NSInteger heigth= [_gateArray count]>10?(SCREEN_HEIGHT/2):(_gateArray.count*50.0);
        
        L_CarlistPopVC *popVC = [L_CarlistPopVC getInstance];
        
        popVC.heightLayout.constant = heigth;
        
        [popVC showVC:self withDataArray:_gateArray withType:1 cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            L_CorrgateModel *gateModel = (L_CorrgateModel *)data;
            _currentGateModel = gateModel;
            _gate_Label.text = [XYString IsNotNull:_currentGateModel.aislename];
            
        }];
        
//        PopListVC * popList = [PopListVC getInstance];
//        popList.nsLay_TableHeigth.constant=heigth;
//        @WeakObj(popList);
//        [popList showVC:self listData:_gateArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
//            
//            L_CorrgateModel *gateModel = (L_CorrgateModel *)data;
//            _currentGateModel = gateModel;
//            _gate_Label.text = [XYString IsNotNull:_currentGateModel.aislename];
//            [popListWeak dismissVC];
//            NSLog(@"gateModel.aislename==%@",gateModel.aislename);
//            
//        } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
//            
//            UITableViewCell * cell=(UITableViewCell *)view;
//            L_CorrgateModel *gateModel = (L_CorrgateModel *)data;
//            cell.textLabel.text = [XYString IsNotNull:gateModel.aislename];
//            cell.textLabel.numberOfLines = 1;
//            
//        }];
        
    }
    
    if (type == 2) {
        
        if (_carNumArray.count <= 0) {
            return;
        }
        
        NSInteger heigth= [_carNumArray count]>10?(SCREEN_HEIGHT/2):(_carNumArray.count*50.0);
        
//        L_CarlistPopVC *popVC = [L_CarlistPopVC getInstance];
//        popVC.heightLayout.constant = heigth;
//        
//        [popVC showVC:self withDataArray:_carNumArray withType:2 cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
//            
//            NSDictionary *carNumDict = (NSDictionary *)data;
//            [self httpRequestForGetCardStateWithCard:[XYString IsNotNull:carNumDict[@"card"]]];
//            
//        }];
        
        PopListVC * popList = [PopListVC getInstance];
        
        popList.nsLay_TableHeigth.constant=heigth;
        
        @WeakObj(popList);
        [popList showVC:self listData:_carNumArray cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
            
            NSDictionary *carNumDict = (NSDictionary *)data;
            [popListWeak dismissVC];
            
            [self httpRequestForGetCardStateWithCard:[XYString IsNotNull:carNumDict[@"card"]]];
            
        } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
            
            UITableViewCell * cell=(UITableViewCell *)view;
            NSDictionary *carNumDict = (NSDictionary *)data;
            cell.textLabel.text = [XYString IsNotNull:carNumDict[@"card"]];
            cell.textLabel.numberOfLines = 1;
            
        }];
        
    }
    
}

#pragma mark - 按钮点击

- (IBAction)allBtnsDidTouch:(UIButton *)sender {
    
    /** tag 1.提交纠错申请 2.联系物业 3.选择门口 4.正确车牌号 */
    
    if (sender.tag == 1) {
        
        if ([XYString isBlankString:_currentCarNum]) {
            [self showToastMsg:@"请选择正确车牌号" Duration:3.0];
            return;
        }
        
        if ([XYString isBlankString:_currentGateModel.theID]) {
            [self showToastMsg:@"请选择门口" Duration:3.0];
            return;
        }
        
        /** 保存车牌纠错申请 */
        [self httpRequestForSaveApplyWithCard:_currentCarNum withAisleid:_currentGateModel.theID];
        
    }
    
    if (sender.tag == 2) {
        
        /** 物业电话 */
        [SysPresenter callPhoneStr:_propertyPhone withVC:self];
        
    }
    
    if (sender.tag == 3) {
        
        /** 选择门口 */
        if ([XYString isBlankString:_currentCarNum]) {
            [self showToastMsg:@"请选择正确车牌号" Duration:3.0];
            return;
        }
        
        /** 获得车牌纠错需要的门口 */
        [self httpRequestForGetCorrgateWithCard:_currentCarNum];
    }
    
    if (sender.tag == 4) {
        
        /** 正确车牌号 */
        [self httpRequestForGetCorrardList];
        
    }
    
}

@end

