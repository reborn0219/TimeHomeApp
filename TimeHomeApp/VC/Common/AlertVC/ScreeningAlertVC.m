//
//  ScreeningAlertVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ScreeningAlertVC.h"

@interface ScreeningAlertVC ()
{
    NSArray * buttonArr;
    
}
@end

@implementation ScreeningAlertVC
#pragma mark - 单例初始化
+(instancetype)shareScreeningVC
{
    static ScreeningAlertVC * shareActionSheetVC = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        shareActionSheetVC = [[self alloc] initWithNibName:@"ScreeningAlertVC" bundle:nil];
    });
    
    return shareActionSheetVC;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    buttonArr = @[_btn_1,_btn_2,_btn_3];
    
    [self initThreeBtns];
}
-(void)setFirstSelected:(NSInteger)tag
{
    [self initThreeBtns];

    if (tag==0) {
        _btn_1.layer.borderWidth = 1;
        _btn_1.layer.borderColor = UIColorFromRGB(0xAB131F).CGColor;
        [_btn_1 setTitleColor:UIColorFromRGB(0xAB131F) forState:UIControlStateNormal];
        [_btn_1 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_查看全部_已选中"] forState:UIControlStateNormal];

    }else if(tag == 1)
    {
        _btn_2.layer.borderWidth = 1;
        _btn_2.layer.borderColor = UIColorFromRGB(0xAB131F).CGColor;
        [_btn_2 setTitleColor:UIColorFromRGB(0xAB131F) forState:UIControlStateNormal];
        [_btn_2 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_只看男_未选中"] forState:UIControlStateNormal];

    }else if(tag == 2)
    {
        _btn_3.layer.borderWidth = 1;
        _btn_3.layer.borderColor = UIColorFromRGB(0xAB131F).CGColor;
        [_btn_3 setTitleColor:UIColorFromRGB(0xAB131F) forState:UIControlStateNormal];
        [_btn_3 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_只看女_未选中"] forState:UIControlStateNormal];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)initThreeBtns
{
    for (int i = 0; i<buttonArr.count; i++) {
        
        UIButton * secBtn = [buttonArr objectAtIndex:i];
        secBtn.layer.borderColor = UIColorFromRGB(0x8e8e8e).CGColor;
        secBtn.layer.borderWidth = 0;
        [secBtn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
        
        [_btn_1 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_查看全部_未选中"] forState:UIControlStateNormal];
        [_btn_2 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_只看男_未选中"] forState:UIControlStateNormal];
        [_btn_3 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_只看女_未选中"] forState:UIControlStateNormal];
    }

}

- (IBAction)screeningAction:(id)sender {
    [self initThreeBtns];
    
    
    
    UIButton * tempBtn = (UIButton *)sender;
    if(tempBtn.tag==1000){
        _btn_1.layer.borderWidth = 1;
        _btn_1.layer.borderColor = UIColorFromRGB(0xAB131F).CGColor;
        [_btn_1 setTitleColor:UIColorFromRGB(0xAB131F) forState:UIControlStateNormal];
        [_btn_1 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_查看全部_已选中"] forState:UIControlStateNormal];
        
    }
    if(tempBtn.tag==1001){
        _btn_2.layer.borderColor = UIColorFromRGB(0xAB131F).CGColor;
        [_btn_2 setTitleColor:UIColorFromRGB(0xAB131F) forState:UIControlStateNormal];
        _btn_2.layer.borderWidth = 1;
        [_btn_2 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_只看男_已选中"] forState:UIControlStateNormal];

    }
    if(tempBtn.tag==1002){
        _btn_3.layer.borderColor = UIColorFromRGB(0xAB131F).CGColor;
        [_btn_3 setTitleColor:UIColorFromRGB(0xAB131F) forState:UIControlStateNormal];
        _btn_3.layer.borderWidth = 1;
        [_btn_3 setImage:[UIImage imageNamed:@"邻圈_邻友列表_筛选_只看女_已选中"] forState:UIControlStateNormal];

    }
    NSLog(@"---%ld",(long)tempBtn.tag);
    
    
    self.block(nil,nil,tempBtn.tag);
    [self dismiss];
}

-(void)dismiss
{
    [[ScreeningAlertVC shareScreeningVC] dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)showInVC:(UIViewController *)VC
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
    [VC presentViewController:self animated:YES completion:^{
        
    }];
    
}
@end
