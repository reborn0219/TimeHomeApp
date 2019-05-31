//
//  PricePopVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PricePopVC.h"
#import "TTRangeSlider.h"

@interface PricePopVC ()<TTRangeSliderDelegate>
{
    NSString * selectMinStr;
    NSString * selectMaxStr;
}
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;

/**
 *  显示文字描述
 */
@property (weak, nonatomic) IBOutlet UIView *view_LabView;

/**
 *  滑杆
 */
@property (weak, nonatomic) IBOutlet TTRangeSlider *slider;

/**
 *  滑杆左边距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_Left;
/**
 *  滑杆右边距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_Right;

@end

@implementation PricePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------------初始化------------
-(void)initView
{
    self.slider.delegate=self;
    self.slider.handleColor= [UIColor whiteColor];
    self.slider.tintColor=[UIColor whiteColor];
    self.slider.tintColorBetweenHandles = UIColorFromRGB(0xAB2121);
    self.slider.handleDiameter = 20;
    self.slider.lineHeight=5;
    self.slider.selectedMinimum=self.start;
    self.slider.selectedMaximum=self.end;
    self.slider.maxValue=[self.arryLabTitle count]-1;
    self.slider.minValue=0;
    self.slider.step=1;
    selectMinStr=@"";
    selectMinStr=@"";
    selectMinStr=[self.arryLabTitle objectAtIndex:_start];
    selectMaxStr=[self.arryLabTitle objectAtIndex:self.end];
    
    [self setLabView];
}

/**
 *  返回实例
 *
 *  @return return value description
 */
+(PricePopVC *)getInstance
{
    PricePopVC * alertVC= [[PricePopVC alloc] initWithNibName:@"PricePopVC" bundle:nil];
    return alertVC;
}
/**
 *  设置标尺分段标题
 */
-(void)setLabView
{
    if (self.arryLabTitle) {
        
        UILabel * lab;
        UIView * view;
        float width=(SCREEN_WIDTH-10)/self.arryLabTitle.count;
        self.nsLay_Left.constant=width/2-10;
        self.nsLay_Right.constant=width/2-13;
        
        for (int i=0; i<self.arryLabTitle.count; i++) {
            lab=[[UILabel alloc]initWithFrame:CGRectMake(i*width+5, 10, width, 20)];
            lab.text=[NSString stringWithFormat:@"￥%@",self.arryLabTitle[i]];
            lab.font=DEFAULT_SYSTEM_FONT(10);
            lab.textColor=UIColorFromRGB(0x595353);
            lab.textAlignment=NSTextAlignmentCenter;
//            lab.backgroundColor=UIColorFromRGB(0xff0f00+i*20);
            [self.view_LabView addSubview:lab];
            
            view=[[UIView alloc]initWithFrame:CGRectMake(width*i+width/2+5, 35, 1, 5)];
            view.backgroundColor=UIColorFromRGB(0x595353);
            [self.view_LabView addSubview:view];
            
        }
    }
}

#pragma mark --------显示隐藏---------
/**
 *  显示
 *
 *  @param vc       上级控制器
 *  @param data     标尺段标题数据
 *  @param callBack 事件回调
 */
-(void)showPickPopView:(UIViewController *) parent data:(NSArray *) data eventCallBack:(ViewsEventBlock) callBack
{
    self.arryLabTitle=data;
    self.eventCallBack=callBack;
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
    }];
}
/**
 *  隐藏显示
 */
-(void)dismissPricePopView
{
    self.view.backgroundColor=[UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}

#pragma mark --------事件处理---------
/**
 *  滑杆事件
 */
-(void) rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
     NSLog(@"Custom slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
    
    selectMinStr=[self.arryLabTitle objectAtIndex:selectedMinimum];
    selectMaxStr=[self.arryLabTitle objectAtIndex:selectedMaximum];

}


/**
 *  取消事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_CancelEvent:(UIButton *)sender {
    [self dismissPricePopView];
//    if (self.eventCallBack) {
//        NSArray * arr=@[selectMinStr,selectMaxStr];
//        self.eventCallBack(arr,sender,ALERT_CANCEL);
//    }
}

/**
 *  确定事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_OkEvent:(UIButton *)sender {
    [self dismissPricePopView];
    if (self.eventCallBack) {
        NSArray * arr=@[selectMinStr,selectMaxStr];
        self.eventCallBack(arr,sender,ALERT_OK);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissPricePopView];
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
