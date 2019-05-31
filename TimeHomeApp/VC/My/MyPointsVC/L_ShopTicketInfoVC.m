//
//  L_ShopTicketInfoVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ShopTicketInfoVC.h"
#import "RoundButton.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "WebViewVC.h"

@interface L_ShopTicketInfoVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayout;
/** 使用规则 */
@property (weak, nonatomic) IBOutlet UILabel *regular_Label;

/**
 获得时间
 */
@property (weak, nonatomic) IBOutlet UILabel *getTime_Label;

/**
 去使用按钮
 */
@property (weak, nonatomic) IBOutlet RoundButton *gotoUse_Button;

/**
 可用 不可用状态
 */
@property (weak, nonatomic) IBOutlet UILabel *state_Label;

/**
 商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *name_Label;

/**
 有效期
 */
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

@end

@implementation L_ShopTicketInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.backgroundColor = BLACKGROUND_COLOR;
    _scrollView.scrollEnabled = YES;
    _contentViewHeightLayout.constant = SCREEN_HEIGHT - (44+statuBar_Height) - 7;
    
    _state_Label.layer.cornerRadius = 10;
    _state_Label.layer.borderWidth = 1;
    _state_Label.layer.borderColor = kNewRedColor.CGColor;
    
    _name_Label.text = [XYString IsNotNull:_couponModel.couponname];
    
    NSString *startTime = @"";
    NSString *endTime = @"";
    
    if (![XYString isBlankString:_couponModel.starttime]) {
        
        if (_couponModel.starttime.length >= 10) {
            startTime = [_couponModel.starttime substringToIndex:10];
        }else {
            startTime = _couponModel.starttime;
        }
        
    }
    if (![XYString isBlankString:_couponModel.endtime]) {
        
        if (_couponModel.endtime.length >= 10) {
            endTime = [_couponModel.endtime substringToIndex:10];
        }else {
            endTime = _couponModel.endtime;
        }
        
    }
    
    NSDate *startDate = [XYString NSStringToDate:startTime withFormat:@"YYYY-MM-dd"];
    startTime = [XYString NSDateToString:startDate withFormat:@"YYYY.MM.dd"];
    
    NSDate *endDate = [XYString NSStringToDate:endTime withFormat:@"YYYY-MM-dd"];
    endTime = [XYString NSDateToString:endDate withFormat:@"YYYY.MM.dd"];
    
    _time_Label.text = [NSString stringWithFormat:@"有效时间:%@-%@",[XYString IsNotNull:startTime],[XYString IsNotNull:endTime]];
    
    NSString *getTimeStr = @"";
    if (![XYString isBlankString:_couponModel.systime]) {
        if (_couponModel.systime.length >= 16) {
            getTimeStr = [_couponModel.systime substringToIndex:16];
        }else {
            getTimeStr = _couponModel.systime;
        }
    }
    _getTime_Label.text = [NSString stringWithFormat:@"获得时间:%@",getTimeStr];
    
    //可使用0      商城已使用 1      未生效 2     已失效 3
    if (_couponModel.couponstate.intValue == 0) {
        _state_Label.text = @"可用";
        _state_Label.textColor = kNewRedColor;
        _state_Label.layer.borderColor = kNewRedColor.CGColor;
        _gotoUse_Button.hidden = NO;
    }
    if (_couponModel.couponstate.intValue == 1) {
        _state_Label.text = @"已用";
        _state_Label.textColor = TITLE_TEXT_COLOR;
        _state_Label.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        _gotoUse_Button.hidden = YES;
    }
    if (_couponModel.couponstate.intValue == 2) {
        _state_Label.text = @"未生效";
        _state_Label.textColor = TITLE_TEXT_COLOR;
        _state_Label.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        _gotoUse_Button.hidden = YES;
    }
    if (_couponModel.couponstate.intValue == 3) {
        _state_Label.text = @"已失效";
        _state_Label.textColor = TITLE_TEXT_COLOR;
        _state_Label.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        _gotoUse_Button.hidden = YES;
    }
    
//    NSString *str = @"1.可用于积分商城中付费商品的金额抵用\n2.可叠加使用\n3.兑换商品付费金额不低于1元\n4.不找零，不折现\n5.请于10月30日之前兑换使用，过期商品券将作废;";
//    _regular_Label.text = str;
    
    _regular_Label.text = [XYString IsNotNull:_couponModel.couponrule];
    
    [UILabel changeLineSpaceForLabel:_regular_Label WithSpace:5];
    
    [self.view layoutIfNeeded];
}

- (IBAction)gotoUseButtonDidTouch:(RoundButton *)sender {
    
    NSLog(@"去使用");

    [self gotoExchangeInfoWithID:_couponModel.couponid];
    
}

// MARK: - 详情入口
-(void)gotoExchangeInfoWithID:(NSString *)theid {
    
    AppDelegate *appDlgt = GetAppDelegates;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    NSString *url = [NSString stringWithFormat:@"%@/mobile/index.php?app=member&act=login&token=%@&userid=%@&allow=1&ret_url=%%2Fmobile%%2Findex.php%%3Fapp%%3Dgoods%%26coupon_id%%3D",kShopSEVER_URL,appDlgt.userData.token,appDlgt.userData.userID];
    url = [url stringByAppendingString:theid];
    
    webVc.url = url;
    
    webVc.isNoRefresh = YES;
    webVc.isHiddenBar = YES;
    webVc.talkingName = JiFenShangCheng;
    
    webVc.shopCallBack = ^() {
        NSLog(@"回调");
    };
    
    webVc.title=@"商城";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

@end
