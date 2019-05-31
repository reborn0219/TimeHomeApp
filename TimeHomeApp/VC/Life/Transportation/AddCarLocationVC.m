//
//  AddCarLocationVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AddCarLocationVC.h"
#import "QrCodeScanningVC.h"
#import "RegularUtils.h"
#import "CarLocationPresenter.h"
@interface AddCarLocationVC ()<BackValueDelegate>
{
    
}

@end

@implementation AddCarLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.carModle!=nil)
    {
        self.TF_CarNum.text=self.carModle.card;
        self.TF_IMEI.text=self.carModle.imei;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------------事件----------------
///imei输入变化
- (IBAction)TFIMEIChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if (self.TF_IMEI.text.length>32) {
            self.TF_IMEI.text=[self.TF_IMEI.text substringToIndex:32];
        }
        
    }
}

/**

 */

- (IBAction)btn_ScanQRCodeEvent:(UIButton *)sender {
    if (![self canOpenCamera]) {
        return;
    }

    QrCodeScanningVC * QrCodeVc=[[QrCodeScanningVC alloc]init];
    QrCodeVc.delegate=self;
    [self.navigationController pushViewController:QrCodeVc animated:YES];
    
}
///车牌输入变化
- (IBAction)TF_CarNumChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if (self.TF_CarNum.text.length>7) {
            self.TF_CarNum.text=[self.TF_CarNum.text substringToIndex:7];
        }
        
    }

}

///提交
- (IBAction)btn_SumbitEvent:(UIButton *)sender {
    
    if(![RegularUtils isNumOrCharacter:self.TF_IMEI.text])
    {
        [self showToastMsg:@"IMEI必须是字母或数字" Duration:5];
        return;
    }
    if(![RegularUtils isCarNum:self.TF_CarNum.text])
    {
        [self showToastMsg:@"输入车牌格式不正确" Duration:5];
        return;
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    
    @WeakObj(self);
    
    CarLocationPresenter * clp=[CarLocationPresenter new];
    [clp addUserCarPositionForCard:self.TF_CarNum.text imei:self.TF_IMEI.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"添加成功" Duration:5.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else if(resultCode==FailureCode)
            {
                [selfWeak showToastMsg:data Duration:5.0];
                
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                
            }
        });

    }];
}

#pragma mark -------------扫完二维码回调-----------------

///扫完二维码回调
-(void)backValue:(NSString *)value
{
    self.TF_IMEI.text=value;
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
