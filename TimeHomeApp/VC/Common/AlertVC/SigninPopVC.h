//
//  SigninPopVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninPopVC : UIViewController


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_center_layout;
@property (weak, nonatomic) IBOutlet UICollectionView *sigininCollectionV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lb_back_view_layout_top;
@property (nonatomic, copy) UIViewController *nextVC;
/**
 初始化
 @return self
 */
@property (weak, nonatomic) IBOutlet UIImageView *signinPopImg;
@property (weak, nonatomic) IBOutlet UILabel *signinPopLb;
@property (weak, nonatomic) IBOutlet UILabel *signinNumLb;
@property (weak, nonatomic) IBOutlet UILabel *againSignumLb;
@property (weak, nonatomic) IBOutlet UIButton *siginBtn;
@property (weak, nonatomic) IBOutlet UIView *signinPopView;

+(instancetype)shareSigninPopVC;
@property (nonatomic,copy)ViewsEventBlock block;
-(void)showInVC:(UIViewController *)VC with:(NSDictionary *)dic;
-(void)dismiss;

@end
