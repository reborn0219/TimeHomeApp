//
//  RedPacketsAlertVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RedPacketsAlertVC.h"
#import "RedPacketsVC.h"
#import "BBSMainPresenters.h"

@interface RedPacketsAlertVC ()
{
    UIViewController * beforeVC;
    NSDictionary *infoDict;
}

/**
 开字 下方约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openButtonBottomConstraint;
/**
 开字宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openButtonWidthConstraint;
/**
 开字高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openButtonHeightConstraint;

/**
 看大家手气按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *otherInfoButton;

/**
 开字 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *openButton;

/**
 背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *redBackgroundImageView;

@end

@implementation RedPacketsAlertVC

/**
 领取红包

 @param redID 红包id
 */
- (void)httpRequestForReceiveWithRedID:(NSString *)redID {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters redReceivered:redID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if (resultCode == SucceedCode) {
                
                [self dismiss];

                RedPacketsVC * rpVC = [[RedPacketsVC alloc]init];
                rpVC.redid = redID;
                [beforeVC.navigationController pushViewController:rpVC animated:YES];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

#pragma mark - lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    //红包高度
    CGFloat h = (SCREEN_WIDTH-40)/538*698;
    
    _checkBtn_layout_top.constant = h/2-120+h/12;
    _headerV.layer.cornerRadius = 40;
    _headerImgV.layer.masksToBounds = YES;
    _headerImgV.layer.cornerRadius = 37;
    
    [_headerImgV sd_setImageWithURL:[NSURL URLWithString:infoDict[@"userpic"]] placeholderImage:kHeaderPlaceHolder];
    _nickeLb.text = [XYString IsNotNull:infoDict[@"nickname"]];
    
    if ([infoDict[@"type"] integerValue] == 1) {
        
        CGFloat openButtonWidth = (SCREEN_WIDTH - 40) /540 *220;
        
        //开
        _redMsgLb.text = @"平安社区 祝大家开心每一天";
        _redMsgLb.textColor = kNewYellowColor;
        _redMsgLb.font = DEFAULT_FONT(14);
        
        _openButtonBottomConstraint.constant = (SCREEN_HEIGHT-h)/2. + h/7.;
        _openButtonWidthConstraint.constant = openButtonWidth;
        _openButtonHeightConstraint.constant = openButtonWidth;
        _openButton.hidden = NO;
        _redBackgroundImageView.image = [UIImage imageNamed:@"抢红包背景-开"];
        _otherInfoButton.hidden = YES;
        
    }
    
    if ([infoDict[@"type"] integerValue] == 2) {
        //看看大家手气
        _redMsgLb.text = @"手慢了，红包派送完了";
        _redMsgLb.textColor = [UIColor whiteColor];
        _redMsgLb.font = DEFAULT_BOLDFONT(20);

        _openButton.hidden = YES;
        _redBackgroundImageView.image = [UIImage imageNamed:@"抢红包背景"];
        _otherInfoButton.hidden = NO;
        [_otherInfoButton setTitle:@"看看大家手气>" forState:UIControlStateNormal];
        
    }
    
    if ([infoDict[@"type"] integerValue] == 3) {
        //红包过期了 看看大家手气
        _redMsgLb.text = @"手慢了，红包派送完了";
        _redMsgLb.textColor = [UIColor whiteColor];
        _redMsgLb.font = DEFAULT_BOLDFONT(20);

        _openButton.hidden = YES;
        _redBackgroundImageView.image = [UIImage imageNamed:@"抢红包背景"];
        _otherInfoButton.hidden = NO;
        [_otherInfoButton setTitle:@"红包过期了 看看大家手气>" forState:UIControlStateNormal];
        
    }
//    if ([infoDict[@"type"] integerValue] == 4) {
//        //已关闭
//        _redMsgLb.text = @"红包已关闭";
//        _redMsgLb.textColor = [UIColor whiteColor];
//        _redMsgLb.font = DEFAULT_BOLDFONT(20);
//        
//        _openButton.hidden = YES;
//        _redBackgroundImageView.image = [UIImage imageNamed:@"抢红包背景"];
//        _otherInfoButton.hidden = YES;
//        
//    }
//    if ([infoDict[@"type"] integerValue] == 5) {
//        //已删除
//        _redMsgLb.text = @"红包已删除";
//        _redMsgLb.textColor = [UIColor whiteColor];
//        _redMsgLb.font = DEFAULT_BOLDFONT(20);
//        
//        _openButton.hidden = YES;
//        _redBackgroundImageView.image = [UIImage imageNamed:@"抢红包背景"];
//        _otherInfoButton.hidden = YES;
//        
//    }
    
}
#pragma mark - 开红包
- (IBAction)openButtonDidTouch:(UIButton *)sender {
    NSLog(@"开红包");
    
    NSString *redID = infoDict[@"redid"];
    if ([XYString isBlankString:redID]) {
        [self showToastMsg:@"获取红包信息失败" Duration:3.0];
        return;
    }
    
    [self httpRequestForReceiveWithRedID:redID];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

#pragma mark - 跳转红包领取详情页
- (IBAction)checkBtnAction:(id)sender {
    
    NSString *redID = infoDict[@"redid"];
    if ([XYString isBlankString:redID]) {
        [self showToastMsg:@"获取红包信息失败" Duration:3.0];
        return;
    }
    
    [self dismiss];

    RedPacketsVC * rpVC = [[RedPacketsVC alloc]init];
    rpVC.redid = redID;
    [beforeVC.navigationController pushViewController:rpVC animated:YES];
    
}

#pragma mark - 关闭
- (IBAction)closeBtnAction:(id)sender {
    [self dismiss];
}
#pragma mark - 初始化
+(instancetype)shareRedPacketsAlert {
    
    RedPacketsAlertVC * shareRedPacketsAlert= [[RedPacketsAlertVC alloc] initWithNibName:@"RedPacketsAlertVC" bundle:nil];
    return shareRedPacketsAlert;
    
//    static RedPacketsAlertVC * shareRedPacketsAlert = nil;
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        
//        shareRedPacketsAlert = [[self alloc] initWithNibName:@"RedPacketsAlertVC" bundle:nil];
//        
//    });
//    return shareRedPacketsAlert;
    
}
-(void)showInVC:(UIViewController *)VC with:(NSDictionary *)dic {
    
    beforeVC = VC;
    
    infoDict = dic;
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];
}
#pragma mark - 关闭VC
-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
