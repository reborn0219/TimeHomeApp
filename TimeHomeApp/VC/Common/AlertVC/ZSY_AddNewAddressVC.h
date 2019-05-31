//
//  ZSY_AddNewAddressVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_AddNewAddressVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *lineWhiteView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *topGrayView;
@property (weak, nonatomic) IBOutlet UIView *bottomGrayView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UILabel *l3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWhiteViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@property (nonatomic,copy)ViewsEventBlock block;
+(instancetype)shareaddNewAddressVC;
-(void)show:(UIViewController * )VC;
-(void)dismiss;
@end
