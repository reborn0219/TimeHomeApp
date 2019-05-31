//
//  RaiN_TheQrCodeAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaiN_TheQrCodeAlert : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

+(instancetype)shareRaiN_TheQrCodeAlert;

-(void)showInVC:(UIViewController *)VC WithData:(id)data;
@end
