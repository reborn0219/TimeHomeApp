//
//  L_GarageTimePopVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GarageTimePopVC.h"

@interface L_GarageTimePopVC () <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>
{
    NSArray *hoursArray;
    NSArray *minutesArray;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    BOOL isOnly;
}
@end

@implementation L_GarageTimePopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    isOnly = NO;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    hoursArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    minutesArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    [self pickerView:_pickerView didSelectRow:hourIndex inComponent:0];
    [self pickerView:_pickerView didSelectRow:minuteIndex inComponent:1];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.timeBgView]) {
        return NO;
    }
    return YES;
}

#pragma mark - <UIPickerViewDelegate, UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
//没个表盘有几行数据（rows）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows = hoursArray.count * 50;
            break;
        case 1:
            rows = minutesArray.count * 50;
            break;
        default:
            break;
    }
    return rows;
    
}
//每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString * title = nil;
    switch (component) {
        case 0:
            title = hoursArray[row % hoursArray.count];
            break;
        case 1:
            title = minutesArray[row % minutesArray.count];
            break;
        default:
            break;
    }
    return title;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {

        
        [pickerView selectRow:row % [hoursArray count] + hoursArray.count*25 inComponent:component animated:false];

        
        hourIndex = [pickerView selectedRowInComponent:0] % hoursArray.count;

    }else {

        [pickerView selectRow:row % [minutesArray count] + minutesArray.count*25 inComponent:component animated:false];

        minuteIndex = [pickerView selectedRowInComponent:1] % minutesArray.count;
        
    }

}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.font = DEFAULT_FONT(22);
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = TITLE_TEXT_COLOR;
    }

    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    [self changeSpearatorLineColor];


    return pickerLabel;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor {

    NSMutableArray *lineFrameArray = [[NSMutableArray alloc] init];
    
    for(UIView *speartorView in _pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            [lineFrameArray addObject:NSStringFromCGRect(speartorView.frame)];
            speartorView.backgroundColor = [UIColor clearColor];//分割线设置
        }
    }
    
//    static dispatch_once_t once;
//    //只执行一次
//    dispatch_once(&once, ^{
    
//    });
    if (!isOnly) {
        
        for (int i = 0; i < 4; i ++) {
            
            CGRect firstFrame = CGRectFromString(lineFrameArray[i/2]);
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = kNewRedColor;
            [_pickerView addSubview:lineView];
            lineView.frame = CGRectMake((_pickerView.frame.size.width-120)/4. + i%2*(((_pickerView.frame.size.width-120)/4.) * 2 + 60), firstFrame.origin.y, 60, 1);
            
        }
        isOnly = YES;

    }
    
}

- (IBAction)timeVCButtonsDidTouch:(UIButton *)sender {
    
    if (sender.tag == 3) {
        //确定
        if (self.confirmButtonCallBack) {
            self.confirmButtonCallBack([NSString stringWithFormat:@"%@:%@",hoursArray[hourIndex % hoursArray.count],minutesArray[minuteIndex % minutesArray.count]]);
        }
        
    }
    
    [self dismissVC];
}

#pragma mark - 返回实例
+ (L_GarageTimePopVC *)getInstance {
    L_GarageTimePopVC * garageTimePopVC= [[L_GarageTimePopVC alloc] initWithNibName:@"L_GarageTimePopVC" bundle:nil];
    return garageTimePopVC;
}

#pragma mark - 显示
- (void)showVC:(UIViewController *)parent withHour:(NSString *)hour withMinute:(NSString *)minute cellEvent:(ConfirmButtonCallBack)eventCallBack {
    
    if (![XYString isBlankString:hour]) {
        hourIndex = hour.integerValue;
    }else {
        hourIndex = 0;
    }
    
    if (![XYString isBlankString:minute]) {
        minuteIndex = minute.integerValue;
    }else {
        minuteIndex = 0;
    }
    
    self.confirmButtonCallBack = eventCallBack;
    
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
    [parent presentViewController:self animated:NO completion:^{
        
    }];
}

#pragma mark - 隐藏显示
-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
