//
//  VehicleAlertVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleAlertVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
- (IBAction)confirmAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLayout;

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

//+(instancetype)shareVehicleAlert;
@property (nonatomic,copy)AlertBlock block;
-(void)showithTitle:(NSString * )title :(UIViewController *)VC ShowCancelBtn:(BOOL)isShow ISSuccess:(BOOL)isOK;
-(void)dismiss;

/**
 *  是否显示绑定
 */
-(void)showithTitle:(NSString *)title :(UIViewController *)VC  ShowCancelBtn:(BOOL)isShow ISBinding:(BOOL)isOK isLignt:(BOOL)light;

/**
 *  开闸失败联系物业
 */
-(void)showithTitle:(NSString *)title
     viewcontroller:(UIViewController *)VC
      ShowCancelBtn:(BOOL)isShow
            isFault:(BOOL)isFault;

@end
