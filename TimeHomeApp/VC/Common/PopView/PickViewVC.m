//
//  PickViewVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PickViewVC.h"

@interface PickViewVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    /**
     *  要选择的数据
     */
    NSArray * pickerData;
    
}

@end

@implementation PickViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
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
#pragma mark -----------------初始化----------------
-(void)initView
{
    self.pickerView.delegate=self;
    self.pickerView.dataSource=self;
}



/**
 *  返回实例
 *
 *  @return return value description
 */
+(PickViewVC *)getInstance
{
    PickViewVC * alertVC= [[PickViewVC alloc] initWithNibName:@"PickViewVC" bundle:nil];
    return alertVC;
}

#pragma mark -----------------显示隐藏----------------
/**
 *  显示
 *
 *  @param parent <#parent description#>
 */
-(void)showPickView:(UIViewController *) parent pickData:(NSArray *)data
{
    pickerData=data;
    NSInteger index=[pickerData indexOfObject:self.selectStr];
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    self.view.backgroundColor=[UIColor clearColor];
    [parent presentViewController:self animated:YES completion:^{
        self.view.backgroundColor=RGBAFrom0X(0x000000, 0.4);
        [_pickerView selectRow:index inComponent:0 animated:NO];
    }];
}

/**
 *  显示
 *
 *  @param parent        parent description
 *  @param data          data description
 *  @param eventCallBack 事件回调
 */
-(void)showPickView:(UIViewController *) parent pickData:(NSArray *)data EventCallBack:(ViewsEventBlock)eventCallBack
{
    self.selectCallBack=eventCallBack;
    [self showPickView:parent pickData:data];
}


/**
 *  隐藏显示
 */
-(void)dismissPickView
{
    self.view.backgroundColor=[UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}
#pragma mark -----------------事件处理----------------
/**
 *  确定事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_OkEvent:(UIButton *)sender {
    [self dismissPickView];
    if(self.selectCallBack)
    {
        self.selectCallBack(_selectStr,sender,ALERT_OK);
    }
}

/**
 *  取消事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_CancelEvent:(UIButton *)sender {
    [self dismissPickView];
    if(self.selectCallBack)
    {
        self.selectCallBack(_selectStr,sender,ALERT_CANCEL);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissPickView];
}

#pragma mark ----------------UIPickerViewDataSource,UIPickerViewDelegate的实现-------------
/**
 *  选 中选择框第row行时执行的代码
 */
-(void)pickerView: (UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectStr=[pickerData objectAtIndex:row];
}
/**
 *  显示出来的每行的文本
 *
 */
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [pickerData objectAtIndex:row];
}
/**
 *  给选择框设置视图格式选项，可以是UIView以 及UIView的子类
 这个方法可以设置自定义的视图来取代默认的显示每行的样式
 *
 */
//- (UIView*)pickerView:(UIPickerView*)pickerView viewForRow:(NSInteger)row forComponent: (NSInteger)component reusingView:(UIView *)view
//{
//    
//    return view;
//}
/**
 *  设置行高 度
 *
 */
-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
/**
 *  设置行宽度
 *
 */
//-(CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger) component
//{
//    return  SCREEN_WIDTH;
//}

/**
 *  设置选择框中可供选择的行数
 一般都是一个，也可以同时选择两个或更多
 类似于选择时间的 那种，左右有两个轴同时进行选择。
 *
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return 1;
}
/**
 *  设置行数
 */
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerData count];
}


@end
