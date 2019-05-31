//
//  RaiN_NewOnlineServiceVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/9/5.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "UserReserveInfo.h"

/**
 新版在线报修
 */
@interface RaiN_NewOnlineServiceVC : THBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseTheFacilitiesBtn;

/**
 textView
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textViewNumber;


/**
 照片
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *priceView;

@property (weak, nonatomic) IBOutlet UILabel *priceUnitslabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIButton *priceViewSubmitBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitViewSubmitBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *chooseAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *chooseAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet UIView *addressBgView;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theViewHeight;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (nonatomic,copy)NSString *fromType;//0公共  1家用
/// 0. 新发布 1.驳回的维修进行修改，带数据
@property(nonatomic,assign) int jmpCode;
/**
 *  用户报修信息model
 */
@property (nonatomic, strong) UserReserveInfo *userInfo;

@property (nonatomic,copy)NSString *isFormMy;//0否1是
@end
