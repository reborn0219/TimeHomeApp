//
//  VoicePopVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VoicePopVC.h"

@interface VoicePopVC ()
///语音动画显示
@property (weak, nonatomic) IBOutlet UIImageView *img_VoiceAnimation;
///提示语或识别文字
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;

@end

@implementation VoicePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -------初始化--------------


-(void)initView
{

}
/**
 *  返回实例
 *
 *  @return return value description
 */
+(VoicePopVC *)getInstance
{
    VoicePopVC * alertVC= [[VoicePopVC alloc] initWithNibName:@"VoicePopVC" bundle:nil];
    return alertVC;
}
/**
 *  单例方法
 *
 *  @return return value  返回类实例
 */
+ (VoicePopVC *)sharedVoicePopVC {
    static VoicePopVC * sharedVoicePopVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVoicePopVC = [[self alloc] initWithNibName:@"VoicePopVC" bundle:nil];
    });
    return sharedVoicePopVC;
}



#pragma mark----------------显示和隐藏------------------
/**
 *  显示
 *
 *  @param parent parent description
 */
-(void)ShowAlert:(UIViewController *)parent
{
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
    [parent presentViewController:self animated:YES completion:^{
        
    }];
    
}

/**
 *  隐藏显示
 */
-(void)dismissAlert
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}


#pragma mark ---------事件处理---------
///确定事件
- (IBAction)btn_OKEvent:(UIButton *)sender {
    [self dismissAlert];
    if(self.eventCallBack)
    {
        self.eventCallBack(nil,sender,1);
    }

}
///取消事件
- (IBAction)btn_CancelEvent:(UIButton *)sender {
    [self dismissAlert];
    if(self.eventCallBack)
    {
        self.eventCallBack(nil,sender,0);
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
