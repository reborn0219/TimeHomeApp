//
//  ZSY_AddNewAddressVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_AddNewAddressVC.h"
#import "MySettingAndOtherLogin.h"
#import "GetAreaListModel.h"
#import "AppDelegate.h"
@interface ZSY_AddNewAddressVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) NSDictionary *pickerDic;
@property(nonatomic,strong) NSArray *provinceArr; //省
@property(nonatomic,strong) NSArray *cityArr; //市
@property(nonatomic,strong) NSArray *countyArr;//区，县
@property (strong, nonatomic) NSArray *selectedArray;

@end

@implementation ZSY_AddNewAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [self clearSpearatorLine];
    
    if (SCREEN_HEIGHT <= 480) {
        
    }else if (SCREEN_HEIGHT <= 568) {
        
    }else if (SCREEN_HEIGHT <= 667) {
        _lineWhiteViewHeight.constant = 30.0;
        _labelHeight.constant = 30.0;
        
    }else {
        
    }
    _l1.hidden = YES;
    _l2.hidden = YES;
    _l3.hidden = YES;
    _l1.textColor = kNewRedColor;
    _l1.adjustsFontSizeToFitWidth = YES;
    [_l1 setFont:DEFAULT_FONT(15)];
    _l2.textColor = kNewRedColor;
    _l2.adjustsFontSizeToFitWidth = YES;
    [_l2 setFont:DEFAULT_FONT(15)];
    _l3.textColor = kNewRedColor;
    _l3.adjustsFontSizeToFitWidth = YES;
    [_l3 setFont:DEFAULT_FONT(15)];
    
    _topGrayView.backgroundColor = BLACKGROUND_COLOR;
    _bottomGrayView.backgroundColor = BLACKGROUND_COLOR;
    [_okButton setBackgroundColor:kNewRedColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createDataSource];
}
- (void)createDataSource {
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin GetAreaListWithUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                selfWeak.pickerDic = (NSDictionary *)data;
                //                selfWeak.provinceArr = [GetAreaListModel mj_objectArrayWithKeyValuesArray:[selfWeak.pickerDic objectForKey:@"list"]];
                selfWeak.provinceArr = [_pickerDic objectForKey:@"list"];
                
                self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic objectForKey:@"list"] objectAtIndex:0]];
                if (self.selectedArray.count > 0) {
                    self.cityArr = [[self.selectedArray objectAtIndex:1] allKeys];
                }
                
                if (self.cityArr.count > 0) {
                    self.countyArr = [[self.selectedArray objectAtIndex:2] objectForKey:[self.cityArr objectAtIndex:0]];
                }
                
            }else {
                [AppDelegate showToastMsg:(NSString *)data Duration:3.0];
            }
        });
    }];
#if 0
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.provinceArr = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArr = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArr.count > 0) {
        self.countyArr = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:0]];
    }
#endif
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.provinceArr.count;
    } else if (component == 1) {
        return self.cityArr.count;
    } else {
        return self.countyArr.count;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArr objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArr objectAtIndex:row];
    } else {
        return [self.countyArr objectAtIndex:row];
    }
}




- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    
    return (_pickerView.frame.size.width)/3;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
//    _l3.hidden = NO;
//    _l2.hidden = NO;
//    _l1.hidden = NO;
    UILabel *label = (UILabel *)[_pickerView viewForRow:row forComponent:component];
    
    label.textColor = [UIColor redColor];
    if (component == 0) {
        
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArr objectAtIndex:row]];
        
        if (self.selectedArray.count > 0) {
            self.cityArr = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArr = nil;
        }
        
        if (self.cityArr.count > 0) {
            self.countyArr = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:0]];
        } else {
            self.countyArr = nil;
        }
        
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:2];
    }
    
    
    if (component == 1) {
        
        if (self.selectedArray.count > 0 && self.cityArr.count > 0) {
            self.countyArr = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:row]];
        } else {
            self.countyArr = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];
    
    if (component == 2) {
        UILabel *label = (UILabel *)[_pickerView viewForRow:row forComponent:2];
        
        label.textColor = [UIColor redColor];
    }
    _l1.text = [NSString stringWithFormat:@"%@",[self.provinceArr objectAtIndex:[_pickerView selectedRowInComponent:0]]];
    _l2.text = [NSString stringWithFormat:@"%@",[self.cityArr objectAtIndex:[_pickerView selectedRowInComponent:1]]];
    _l3.text = [NSString stringWithFormat:@"%@",[self.countyArr objectAtIndex:[_pickerView selectedRowInComponent:2]]];
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    ///隐藏选中的分割线
    ((UIView *)[_pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    ((UIView *)[_pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.tag = row + 1;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:DEFAULT_FONT(15)];
        [pickerLabel setTextColor:[UIColor darkTextColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
    
}

- (void)clearSpearatorLine
{
    [_pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}
+(instancetype)shareaddNewAddressVC {
    static ZSY_AddNewAddressVC * pickerViewVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        pickerViewVC = [[self alloc] initWithNibName:@"ZSY_AddNewAddressVC" bundle:nil];
        
    });
    return pickerViewVC;
}
-(void)show:(UIViewController * )VC {
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
-(void)dismiss {
    
  [self dismissViewControllerAnimated:NO completion:nil];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
    
}



- (IBAction)click:(id)sender {
    if (self.block) {
        NSString *str = [self.provinceArr objectAtIndex:[_pickerView selectedRowInComponent:0]];
        NSString *str2 =  [self.cityArr objectAtIndex:[_pickerView selectedRowInComponent:1]];
        NSString *str3 = [self.countyArr objectAtIndex:[_pickerView selectedRowInComponent:2]];
        NSString *text = [NSString stringWithFormat:@"%@,%@,%@",str,str2,str3];
        
//        NSString *IDstr = [self.provinceArr[1] objectAtIndex:[_pickerView selectedRowInComponent:0]];
//        NSString *IDstr2 =  [self.cityArr[0] objectAtIndex:[_pickerView selectedRowInComponent:1]];
//        NSString *IDstr3 =  [self.cityArr[0] objectAtIndex:[_pickerView selectedRowInComponent:2]];
        self.block(text,nil,1);
        
    }
    [self dismiss];
}


@end
