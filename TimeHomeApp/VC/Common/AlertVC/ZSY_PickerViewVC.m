//
//  ZSY_PickerViewVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_PickerViewVC.h"

@interface ZSY_PickerViewVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) NSDictionary *pickerDic;
@property(nonatomic,strong) NSArray *provinceArr; //省
@property(nonatomic,strong) NSArray *cityArr; //市
@property(nonatomic,strong) NSArray *countyArr;//区，县
@property (strong, nonatomic) NSArray *selectedArray;

@property(nonatomic,strong) NSMutableArray *selectedSource;
@end

@implementation ZSY_PickerViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = BLACKGROUND_COLOR;
    _pickerView.showsSelectionIndicator = YES;
    _redView.backgroundColor = kNewRedColor;
}

- (void)createDataSource {
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


// 获得第component列的当前选中的行号
- (NSInteger)selectedRowInComponent:(NSInteger)component {
    NSInteger i = component;
    
    return i;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    
    return (_pickerView.frame.size.width)/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
    
    return 20;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//        if (row == _selectedRow) {
//            pickerLabel.textColor = [UIColor redColor];
//        }
        
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
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
        
    }
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
    
        if (self.selectedArray.count > 0 && self.cityArr.count > 0) {
            self.countyArr = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArr objectAtIndex:row]];
        } else {
            self.countyArr = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];

    
    
    
}
+(instancetype)sharePickerViewVC {
    static ZSY_PickerViewVC * pickerViewVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        pickerViewVC = [[self alloc] initWithNibName:@"ZSY_PickerViewVC" bundle:nil];
        
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
- (IBAction)okButtonClick:(id)sender {
    if (self.block) {
        NSString *str = [self.provinceArr objectAtIndex:[_pickerView selectedRowInComponent:0]];
        NSString *str2 =  [self.cityArr objectAtIndex:[_pickerView selectedRowInComponent:1]];
        NSString *str3 = [self.countyArr objectAtIndex:[_pickerView selectedRowInComponent:2]];
        
        NSString *text = [NSString stringWithFormat:@"%@,%@,%@",str,str2,str3];
        self.block(text,nil,1);
        
    }
     [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
