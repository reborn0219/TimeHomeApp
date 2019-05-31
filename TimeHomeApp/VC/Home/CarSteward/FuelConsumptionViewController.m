//
//  FuelConsumptionViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "FuelConsumptionViewController.h"

#import "CarManagerPresenter.h"

#import "graphView.h"

@interface FuelConsumptionViewController (){
    
    UIButton *averageOil;//平均油耗按钮
    
    UIButton *Mileage;//总里程按钮
    
    UIButton *TotalOil;//总油耗按钮
    
    CGRect first;//分隔栏上端
    
    CGRect last;//分隔栏下端
    
    NSMutableArray *graphXArr_;//x坐标坐标值
    
    NSMutableArray *graphY1Arr_;//平均油耗y坐标坐标值
    
    NSMutableArray *graphY2Arr_;//总里程y坐标坐标值
    
    NSMutableArray *graphY3Arr_;//总油耗y坐标坐标值
    
    UIView *tagView;//标签栏
    
    UIScrollView *scroll;//背景视图
    
    UIView *graphView1;//平均油耗视图
    
    UIView *graphView2;//总里程曲线图
    
    UIView *graphView3;//总油耗曲线图
    
    int changeYear;//改变年份
    
    int changeMonth;//改变月份
    
    int originalYear;//初始年份
    
    int originalMonth;//初始月份
    
    UILabel *dateLal;//日期栏
    
    NSString *PlateNub;//车牌文字显示//车牌号
    
    NSString *ucarid_;//识别id
    
    graphView *graph1;//平均油耗曲线
    
    graphView *graph2;//总里程曲线
    
    graphView *graph3;//总油耗曲线
    
    float graph1Line;//平均油耗指标线
    
    float graph2Line;//总里程指标线
    
    float graph3Line;//总油耗指标线
}

@end

@implementation FuelConsumptionViewController

#pragma mark - extend method

-(void)getLicencePlate:(NSString *)plate
                ucarid:(NSString *)ucarid{
    
    PlateNub = plate;
    ucarid_ = ucarid;
}

-(void)configUI{
    
    self.title = @"里程油耗";
    self.view.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    //----------顶部车牌日期栏-----------
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.width / 720 * 120)];
    
    topView.backgroundColor = UIColorFromRGB(0xa01e1f);
    
    [backView addSubview:topView];
    
    UILabel *Plate = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, topView.frame.size.width, topView.frame.size.height)];
    Plate.text = PlateNub;
    Plate.font = [UIFont systemFontOfSize:15];
    Plate.textColor = [UIColor whiteColor];
    
    [Plate setNumberOfLines:1];
    [Plate sizeToFit];
    
    [topView addSubview:Plate];
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake( (topView.frame.size.width - self.view.frame.size.width / 720 * 10 * 2) / 3, (topView.frame.size.height - Plate.frame.size.height - 5) / 2, self.view.frame.size.width / 720 * 10, Plate.frame.size.height + 5)];
    line0.backgroundColor = UIColorFromRGB(0x5d070a);
    [topView addSubview:line0];
    Plate.center = CGPointMake( line0.frame.origin.x / 2, topView.frame.size.height / 2);
    
    UIButton *dateRight = [[UIButton alloc]initWithFrame:CGRectMake(topView.frame.size.width - 20 - 30, line0.frame.origin.y - 5, 30, line0.frame.size.height + 10)];
    [dateRight setBackgroundColor:[UIColor clearColor]];
    [dateRight setImage:[UIImage imageNamed:@"汽车管家_箭头_白_右"] forState:UIControlStateNormal];
    [dateRight addTarget:self action:@selector(dateRight:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:dateRight];
    
    UIButton *dateLeft = [[UIButton alloc]initWithFrame:CGRectMake(line0.frame.origin.x + line0.frame.size.width + 20 , line0.frame.origin.y - 5, 30, line0.frame.size.height + 10)];
    [dateLeft setBackgroundColor:[UIColor clearColor]];
    [dateLeft setImage:[UIImage imageNamed:@"汽车管家_箭头_白_左"] forState:UIControlStateNormal];
    [dateLeft addTarget:self action:@selector(dateLeft:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:dateLeft];
    
    dateLal = [[UILabel alloc]initWithFrame:CGRectMake(dateLeft.frame.origin.x + dateLeft.frame.size.width, dateLeft.frame.origin.y, dateRight.frame.origin.x - dateLeft.frame.origin.x - dateLeft.frame.size.width, dateLeft.frame.size.height)];
    dateLal.font = [UIFont systemFontOfSize:13];
    dateLal.textColor = [UIColor whiteColor];
    dateLal.textAlignment = NSTextAlignmentCenter;
    
    dateLal.text = [NSString stringWithFormat:@"%d年/%d月",originalYear,originalMonth];
    
    [topView addSubview:dateLal];
    
    //----------标签栏-----------
    
    tagView = [[UIView alloc]initWithFrame:CGRectMake(topView.frame.origin.x, topView.frame.origin.y + topView.frame.size.height + 5, topView.frame.size.width, self.view.frame.size.width / 720 * 90)];
    
    tagView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:tagView];
    
    averageOil = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (tagView.frame.size.width - 2 * self.view.frame.size.width / 720 * 10 ) / 3, tagView.frame.size.height)];
    [averageOil setTitle:@"平均油耗" forState:UIControlStateNormal];
    averageOil.titleLabel.font = [UIFont systemFontOfSize:15];
    [averageOil setTitleColor:UIColorFromRGB(0xa01e1f) forState:UIControlStateNormal];
    [averageOil addTarget:self action:@selector(averageOil:) forControlEvents:UIControlEventTouchUpInside];
    
    [tagView addSubview:averageOil];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(averageOil.frame.size.width, (tagView.frame.size.height - Plate.frame.size.height - 5) / 2, line0.frame.size.width, line0.frame.size.height)];
    line1.backgroundColor = UIColorFromRGB(0xeeeff0);
    [tagView addSubview:line1];
    
    Mileage = [[UIButton alloc]initWithFrame:CGRectMake(line1.frame.origin.x + line1.frame.size.width, averageOil.frame.origin.y, averageOil.frame.size.width, averageOil.frame.size.height)];
    [Mileage setTitle:@"总里程" forState:UIControlStateNormal];
    Mileage.titleLabel.font = [UIFont systemFontOfSize:15];
    [Mileage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Mileage addTarget:self action:@selector(Mileage:) forControlEvents:UIControlEventTouchUpInside];
    
    [tagView addSubview:Mileage];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(Mileage.frame.size.width + Mileage.frame.origin.x, line1.frame.origin.y, line1.frame.size.width, line1.frame.size.height)];
    line2.backgroundColor = UIColorFromRGB(0xeeeff0);
    [tagView addSubview:line2];
    
    TotalOil = [[UIButton alloc]initWithFrame:CGRectMake(line2.frame.origin.x + line2.frame.size.width, averageOil.frame.origin.y, averageOil.frame.size.width, averageOil.frame.size.height)];
    [TotalOil setTitle:@"总油耗" forState:UIControlStateNormal];
    TotalOil.titleLabel.font = [UIFont systemFontOfSize:15];
    [TotalOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TotalOil addTarget:self action:@selector(TotalOil:) forControlEvents:UIControlEventTouchUpInside];
    
    [tagView addSubview:TotalOil];
    
    //----------曲线图---------
    
    int x ;
    
    if(self.view.frame.size.width <= 480){
        
        x = 670;
    }else{
        
        x = 765;
    }
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, tagView.frame.origin.y + tagView.frame.size.height + 1, self.view.frame.size.width * 3, self.view.frame.size.width / 720 * x)];
    scroll.backgroundColor = [UIColor clearColor];
    [backView addSubview:scroll];
    
    [self configView1];
    [self configView2];
    [self configView3];
    
}

#pragma mark - graphView method

-(void)configView1{
    
    graphView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, scroll.frame.size.height)];
    
    graphView1.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:graphView1];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Mileage:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionLeft];
    [graphView1 addGestureRecognizer:swipe];
    
    UILabel *UnitLal = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, graphView1.frame.size.width - 20, 15)];
    UnitLal.text = @"百公里油耗（升/百公里）";
    UnitLal.font = [UIFont systemFontOfSize:13];
    UnitLal.textColor = UIColorFromRGB(0xa01e1f);
    [graphView1 addSubview:UnitLal];
    
    UILabel *UnitLal1 = [[UILabel alloc]initWithFrame:CGRectMake(10, graphView1.frame.size.height -  25, graphView1.frame.size.width - 20, 15)];
    UnitLal1.text = @"日期（日）";
    UnitLal1.textAlignment = NSTextAlignmentCenter;
    UnitLal1.font = [UIFont systemFontOfSize:13];
    UnitLal1.textColor = UIColorFromRGB(0xa01e1f);
    [graphView1 addSubview:UnitLal1];
    
    for (int i = 0; i < 9; i++) {
        
        UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(UnitLal.frame.origin.x, UnitLal.frame.origin.y + UnitLal.frame.size.height + 10 + i * (UnitLal1.frame.origin.y - UnitLal.frame.origin.y - UnitLal.frame.size.height - 5) / 10, 32, 15)];
        
        number.textColor = UIColorFromRGB(0x007bc4);
        number.font = [UIFont systemFontOfSize:12];
        number.textAlignment = NSTextAlignmentCenter;
        number.text = [NSString stringWithFormat:@"%0.1f",graph1Line - graph1Line / 8 * i];
        [graphView1 addSubview:number];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(number.frame.origin.x + number.frame.size.width + 5, number.frame.origin.y + number.frame.size.height / 2, graphView1.frame.size.width - number.frame.origin.x - number.frame.size.width - 25, 1)];
        line.backgroundColor = UIColorFromRGB(0xeeeff0);
        [graphView1 addSubview:line];
        
        first = CGRectMake(line.frame.origin.x, UnitLal.frame.origin.y + UnitLal.frame.size.height + 10 + number.frame.size.height / 2, line.frame.size.width, line.frame.size.height);
        last = line.frame;
    }
    
    for (int j = 0; j < 7; j++) {
        
        UIView *line;
        if (j == 0) {
            
            line = [[UIView alloc]initWithFrame:CGRectMake( last.origin.x,last.origin.y - 5,1,5)];
        }else{
            
            line = [[UIView alloc]initWithFrame:CGRectMake(last.origin.x + ((j * 5) - 1) * (last.size.width) / 29,last.origin.y - 5,1,5)];
        }
        
        line.backgroundColor =UIColorFromRGB(0xeeeff0);
        [graphView1 addSubview:line];
        
        UILabel *dateNo = [[UILabel alloc]initWithFrame:CGRectMake(line.frame.origin.x - 20 / 2, last.origin.y + last.size.height + 5, 20, 15)];
        
        dateNo.textColor = UIColorFromRGB(0xa01e1f);
        dateNo.font = [UIFont systemFontOfSize:13];
        dateNo.textAlignment = NSTextAlignmentCenter;
        
        if (j == 0) {
            
            dateNo.text = [NSString stringWithFormat:@"1"];
        }else{
            
           dateNo.text = [NSString stringWithFormat:@"%d", j * 5];
        }
        
        [graphView1 addSubview:dateNo];
    }
}

-(void)configView2{

    graphView2 = [[UIView alloc]initWithFrame:CGRectMake(10 + self.view.frame.size.width, 0, self.view.frame.size.width - 20, scroll.frame.size.height)];
    
    graphView2.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:graphView2];
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(averageOil:)];
    [swipe1 setDirection: UISwipeGestureRecognizerDirectionRight];
    [graphView2 addGestureRecognizer:swipe1];
    
    UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(TotalOil:)];
    [swipe2 setDirection: UISwipeGestureRecognizerDirectionLeft];
    [graphView2 addGestureRecognizer:swipe2];
    
    UILabel *UnitLal = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, graphView2.frame.size.width - 20, 15)];
    UnitLal.text = @"里程（公里）";
    UnitLal.font = [UIFont systemFontOfSize:13];
    UnitLal.textColor = UIColorFromRGB(0xa01e1f);
    [graphView2 addSubview:UnitLal];
    
    UILabel *UnitLal1 = [[UILabel alloc]initWithFrame:CGRectMake(10, graphView2.frame.size.height -  25, graphView2.frame.size.width - 20, 15)];
    UnitLal1.text = @"日期（日）";
    UnitLal1.textAlignment = NSTextAlignmentCenter;
    UnitLal1.font = [UIFont systemFontOfSize:13];
    UnitLal1.textColor = UIColorFromRGB(0xa01e1f);
    [graphView2 addSubview:UnitLal1];
    
    for (int i = 0; i < 9; i++) {
        
        UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(UnitLal.frame.origin.x, UnitLal.frame.origin.y + UnitLal.frame.size.height + 10 + i * (UnitLal1.frame.origin.y - UnitLal.frame.origin.y - UnitLal.frame.size.height - 5) / 10, 32, 15)];
        
        number.textColor = UIColorFromRGB(0x007bc4);
        number.font = [UIFont systemFontOfSize:12];
        number.textAlignment = NSTextAlignmentCenter;
        number.text = [NSString stringWithFormat:@"%0.1f",graph2Line - graph2Line / 8 * i];
        [graphView2 addSubview:number];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(number.frame.origin.x + number.frame.size.width + 5, number.frame.origin.y + number.frame.size.height / 2, graphView2.frame.size.width - number.frame.origin.x - number.frame.size.width - 25, 1)];
        line.backgroundColor = UIColorFromRGB(0xeeeff0);
        [graphView2 addSubview:line];
        
        first = CGRectMake(line.frame.origin.x, UnitLal.frame.origin.y + UnitLal.frame.size.height + 10 + number.frame.size.height / 2, line.frame.size.width, line.frame.size.height);
        last = line.frame;
    }
    
    for (int j = 0; j < 7; j++) {
        
        UIView *line;
        if (j == 0) {
            
            line = [[UIView alloc]initWithFrame:CGRectMake( last.origin.x,last.origin.y - 5,1,5)];
        }else{
            
            line = [[UIView alloc]initWithFrame:CGRectMake(last.origin.x + ((j * 5) - 1) * (last.size.width) / 29,last.origin.y - 5,1,5)];
        }
        
        line.backgroundColor =UIColorFromRGB(0xeeeff0);
        [graphView2 addSubview:line];
        
        UILabel *dateNo = [[UILabel alloc]initWithFrame:CGRectMake(line.frame.origin.x - 20 / 2, last.origin.y + last.size.height + 5, 20, 15)];
        
        dateNo.textColor = UIColorFromRGB(0xa01e1f);
        dateNo.font = [UIFont systemFontOfSize:13];
        dateNo.textAlignment = NSTextAlignmentCenter;
        
        if (j == 0) {
            
            dateNo.text = [NSString stringWithFormat:@"1"];
        }else{
            
            dateNo.text = [NSString stringWithFormat:@"%d", j * 5];
        }
        
        [graphView2 addSubview:dateNo];
    }
}

-(void)configView3{
    
    graphView3 = [[UIView alloc]initWithFrame:CGRectMake(10 + 2 * self.view.frame.size.width, 0, self.view.frame.size.width - 20, scroll.frame.size.height)];
    
    graphView3.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:graphView3];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Mileage:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionRight];
    [graphView3 addGestureRecognizer:swipe];
    
    UILabel *UnitLal = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, graphView3.frame.size.width - 20, 15)];
    UnitLal.text = @"油耗（升）";
    UnitLal.font = [UIFont systemFontOfSize:13];
    UnitLal.textColor = UIColorFromRGB(0xa01e1f);
    [graphView3 addSubview:UnitLal];
    
    UILabel *UnitLal1 = [[UILabel alloc]initWithFrame:CGRectMake(10, graphView3.frame.size.height -  25, graphView3.frame.size.width - 20, 15)];
    UnitLal1.text = @"日期（日）";
    UnitLal1.textAlignment = NSTextAlignmentCenter;
    UnitLal1.font = [UIFont systemFontOfSize:13];
    UnitLal1.textColor = UIColorFromRGB(0xa01e1f);
    [graphView3 addSubview:UnitLal1];
    
    for (int i = 0; i < 9; i++) {
        
        UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(UnitLal.frame.origin.x, UnitLal.frame.origin.y + UnitLal.frame.size.height + 10 + i * (UnitLal1.frame.origin.y - UnitLal.frame.origin.y - UnitLal.frame.size.height - 5) / 10, 32, 15)];
        
        number.textColor = UIColorFromRGB(0x007bc4);
        number.font = [UIFont systemFontOfSize:12];
        number.textAlignment = NSTextAlignmentCenter;
        number.text = [NSString stringWithFormat:@"%0.1f",graph3Line - graph3Line / 8 * i];
        [graphView3 addSubview:number];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(number.frame.origin.x + number.frame.size.width + 5, number.frame.origin.y + number.frame.size.height / 2, graphView3.frame.size.width - number.frame.origin.x - number.frame.size.width - 25, 1)];
        line.backgroundColor = UIColorFromRGB(0xeeeff0);
        [graphView3 addSubview:line];
        
        first = CGRectMake(line.frame.origin.x, UnitLal.frame.origin.y + UnitLal.frame.size.height + 10 + number.frame.size.height / 2, line.frame.size.width, line.frame.size.height);
        last = line.frame;
    }
    
    for (int j = 0; j < 7; j++) {
        
        UIView *line;
        if (j == 0) {
            
            line = [[UIView alloc]initWithFrame:CGRectMake( last.origin.x,last.origin.y - 5,1,5)];
        }else{
            
            line = [[UIView alloc]initWithFrame:CGRectMake(last.origin.x + ((j * 5) - 1) * (last.size.width) / 29,last.origin.y - 5,1,5)];
        }
        line.backgroundColor =UIColorFromRGB(0xeeeff0);
        [graphView3 addSubview:line];
        
        UILabel *dateNo = [[UILabel alloc]initWithFrame:CGRectMake(line.frame.origin.x - 20 / 2, last.origin.y + last.size.height + 5, 20, 15)];
        
        dateNo.textColor = UIColorFromRGB(0xa01e1f);
        dateNo.font = [UIFont systemFontOfSize:13];
        dateNo.textAlignment = NSTextAlignmentCenter;
        
        if (j == 0) {
            
            dateNo.text = [NSString stringWithFormat:@"1"];
        }else{
            
            dateNo.text = [NSString stringWithFormat:@"%d", j * 5];
        }
        
        [graphView3 addSubview:dateNo];
    }
}

#pragma mark - add graphView

-(void)changeBack{
    
    [graphView1 removeFromSuperview];
    [graphView2 removeFromSuperview];
    [graphView3 removeFromSuperview];
    
    [self configView1];
    [self configView2];
    [self configView3];
}

-(void)changeGraph{
    
    [graph1 removeFromSuperview];
    [graph2 removeFromSuperview];
    [graph3 removeFromSuperview];
    
    graph1 = [[graphView alloc]initWithFrame:CGRectMake(first.origin.x - 7, first.origin.y - 7, first.size.width / 29 * 31 + 7, last.origin.y - first.origin.y + 14)];
    
    graph1.backgroundColor = [UIColor clearColor];
    
    if (graphXArr_.count > 0) {
        
        NSMutableArray *graphX = [NSMutableArray array];
        
        for (int k = 0; k < graphXArr_.count; k++) {
            
            float a = [graphXArr_[k] floatValue];
            a = 7 +(graph1.frame.size.width - 7) / 31 * (a - 1);
            [graphX addObject:[NSString stringWithFormat:@"%lf",a]];
        }
        
        NSMutableArray *graphY = [NSMutableArray array];
        
        for (int l = 0; l < graphXArr_.count; l++) {
            
            float b = [graphY1Arr_[l] floatValue];
            b = 7 + (graph1.frame.size.height - 7 - 7) / graph1Line * (graph1Line - b);
            [graphY addObject:[NSString stringWithFormat:@"%lf",b]];
        }
        
        graph1.pointXArray = graphX;
        graph1.pointYArray1 = graphY;
        graph1.pointValueArray = graphY1Arr_;
        
        [graphView1 addSubview:graph1];
    }
    
    graph2 = [[graphView alloc]initWithFrame:CGRectMake(first.origin.x - 7, first.origin.y - 7, first.size.width / 29 * 31 + 7, last.origin.y - first.origin.y + 14)];
    
    graph2.backgroundColor = [UIColor clearColor];
    
    if (graphXArr_.count > 0) {
        
        NSMutableArray *graphX = [NSMutableArray array];
        
        for (int k = 0; k < graphXArr_.count; k++) {
            
            float a = [graphXArr_[k] floatValue];
            a = 7 + (graph2.frame.size.width - 7) / 31 * (a - 1);
            [graphX addObject:[NSString stringWithFormat:@"%lf",a]];
        }
        
        NSMutableArray *graphY = [NSMutableArray array];
        
        for (int l = 0; l < graphXArr_.count; l++) {
            
            float b = [graphY2Arr_[l] floatValue];
            b = 7 + (graph2.frame.size.height - 7 - 7) / graph2Line * (graph2Line - b);
            [graphY addObject:[NSString stringWithFormat:@"%lf",b]];
        }
        
        graph2.pointXArray = graphX;
        graph2.pointYArray1 = graphY;
        graph2.pointValueArray = graphY2Arr_;
        
        [graphView2 addSubview:graph2];
    }
    
    graph3 = [[graphView alloc]initWithFrame:CGRectMake(first.origin.x - 7, first.origin.y - 7, first.size.width / 29 * 31 + 7, last.origin.y - first.origin.y + 14)];
    
    graph3.backgroundColor = [UIColor clearColor];
    
    if (graphXArr_.count > 0) {
        
        NSMutableArray *graphX = [NSMutableArray array];
        
        for (int k = 0; k < graphXArr_.count; k++) {
            
            float a = [graphXArr_[k] floatValue];
            a = 7 + (graph3.frame.size.width - 7) / 31 * (a - 1);
            [graphX addObject:[NSString stringWithFormat:@"%lf",a]];
        }
        
        NSMutableArray *graphY = [NSMutableArray array];
        
        for (int l = 0; l < graphXArr_.count; l++) {
            
            float b = [graphY3Arr_[l] floatValue];
            b = 7 + (graph3.frame.size.height - 7 - 7) / graph3Line * (graph3Line - b);
            [graphY addObject:[NSString stringWithFormat:@"%lf",b]];
        }
        
        graph3.pointXArray = graphX;
        graph3.pointYArray1 = graphY;
        graph3.pointValueArray = graphY3Arr_;
        
        [graphView3 addSubview:graph3];
    }
}

#pragma mark - button tap mehtod

-(void)dateRight:(id)sender{
    
    if (changeMonth == originalMonth && changeYear == originalYear) {
        
        
    }else{
        
        [graph1 removeFromSuperview];
        [graph2 removeFromSuperview];
        [graph3 removeFromSuperview];
        
        [averageOil setTitleColor:UIColorFromRGB(0xa01e1f) forState:UIControlStateNormal];
        [Mileage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [TotalOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            graphView1.frame = CGRectMake( 10, graphView1.frame.origin.y, graphView1.frame.size.width, graphView1.frame.size.height);
            graphView2.frame = CGRectMake(10 + self.view.frame.size.width, graphView2.frame.origin.y, graphView2.frame.size.width, graphView2.frame.size.height);
            graphView3.frame = CGRectMake(10 + 2 * self.view.frame.size.width, graphView3.frame.origin.y, graphView3.frame.size.width, graphView3.frame.size.height);
        }];
        
        if (changeMonth == 12) {
            
            changeMonth = 1;
            changeYear ++;
            dateLal.text = [NSString stringWithFormat:@"%d年/%d月",changeYear,changeMonth];
        }else{
            
            
            
            changeMonth ++;
            dateLal.text = [NSString stringWithFormat:@"%d年/%d月",changeYear,changeMonth];
            [self getFuelConsumption];
        }
    }
}

-(void)dateLeft:(id)sender{
    
    [graph1 removeFromSuperview];
    [graph2 removeFromSuperview];
    [graph3 removeFromSuperview];
    
    [averageOil setTitleColor:UIColorFromRGB(0xa01e1f) forState:UIControlStateNormal];
    [Mileage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TotalOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        graphView1.frame = CGRectMake( 10, graphView1.frame.origin.y, graphView1.frame.size.width, graphView1.frame.size.height);
        graphView2.frame = CGRectMake(10 + self.view.frame.size.width, graphView2.frame.origin.y, graphView2.frame.size.width, graphView2.frame.size.height);
        graphView3.frame = CGRectMake(10 + 2 * self.view.frame.size.width, graphView3.frame.origin.y, graphView3.frame.size.width, graphView3.frame.size.height);
    }];
    
    if (changeMonth == 1) {
        
        changeMonth = 12;
        changeYear --;
        dateLal.text = [NSString stringWithFormat:@"%d年/%d月",changeYear,changeMonth];
    }else{
        
        changeMonth --;
        dateLal.text = [NSString stringWithFormat:@"%d年/%d月",changeYear,changeMonth];
    }
    [self getFuelConsumption];
}

-(void)averageOil:(id)sender{
    
    [averageOil setTitleColor:UIColorFromRGB(0xa01e1f) forState:UIControlStateNormal];
    [Mileage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TotalOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        graphView1.frame = CGRectMake( 10, graphView1.frame.origin.y, graphView1.frame.size.width, graphView1.frame.size.height);
        graphView2.frame = CGRectMake(10 + self.view.frame.size.width, graphView2.frame.origin.y, graphView2.frame.size.width, graphView2.frame.size.height);
        graphView3.frame = CGRectMake(10 + 2 * self.view.frame.size.width, graphView3.frame.origin.y, graphView3.frame.size.width, graphView3.frame.size.height);
    }];
}

-(void)Mileage:(id)sender{
    
    [averageOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Mileage setTitleColor:UIColorFromRGB(0xa01e1f) forState:UIControlStateNormal];
    [TotalOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        graphView1.frame = CGRectMake( 10 - self.view.frame.size.width, graphView1.frame.origin.y, graphView1.frame.size.width, graphView1.frame.size.height);
        graphView2.frame = CGRectMake(10, graphView2.frame.origin.y, graphView2.frame.size.width, graphView2.frame.size.height);
        graphView3.frame = CGRectMake(10 + self.view.frame.size.width, graphView3.frame.origin.y, graphView3.frame.size.width, graphView3.frame.size.height);
    }];
}

-(void)TotalOil:(id)sender{
    
    [averageOil setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Mileage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TotalOil setTitleColor:UIColorFromRGB(0xa01e1f) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        graphView1.frame = CGRectMake( 10 - 2 * self.view.frame.size.width, graphView1.frame.origin.y, graphView1.frame.size.width, graphView1.frame.size.height);
        graphView2.frame = CGRectMake(10 - self.view.frame.size.width, graphView2.frame.origin.y, graphView2.frame.size.width, graphView2.frame.size.height);
        graphView3.frame = CGRectMake(10, graphView3.frame.origin.y, graphView3.frame.size.width, graphView3.frame.size.height);
    }];
}

#pragma mark - http request method

-(void)getFuelConsumption{
    
    if (ucarid_) {
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        [CarManagerPresenter fuelConsumptionWithUcarid:ucarid_ date:[NSString stringWithFormat:@"%d-%d",changeYear,changeMonth] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode==SucceedCode)
                {
                    [graphXArr_ removeAllObjects];
                    [graphY1Arr_ removeAllObjects];
                    [graphY2Arr_ removeAllObjects];
                    [graphY3Arr_ removeAllObjects];
                    NSArray *dataArr = (NSArray *)data;
                    if (dataArr.count > 0) {
                        for (int i = 0; i < dataArr.count; i++) {
                            NSDictionary *dict = dataArr[i];
                            
                            [graphXArr_ addObject:dict[@"day"]];
                            
                            float oilconsumption = [dict[@"oilconsumption"] floatValue];
                            if (oilconsumption > graph1Line) {
                                graph1Line = oilconsumption;
                            }
                            
                            float distance = [dict[@"distance"] floatValue];
                            if (distance > graph2Line) {
                                graph2Line = distance;
                            }
                            
                            float oil = [dict[@"oil"] floatValue];
                            if (oil > graph3Line) {
                                graph3Line = oil;
                            }
                            
                            [graphY1Arr_ addObject:dict[@"oilconsumption"]];
                            [graphY2Arr_ addObject:dict[@"distance"]];
                            [graphY3Arr_ addObject:dict[@"oil"]];
                            
                        }
                        [self changeBack];
                        [self changeGraph];
                    }
                }else
                {
                    //[self showToastMsg:data Duration:5.0];
                }
            });
        }];
    }
}

#pragma mark - life cyclet method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [self averageOil:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter  *dateformatterY = [[NSDateFormatter alloc] init];
    [dateformatterY setDateFormat:@"YYYY"];
    NSDateFormatter  *dateformatterM = [[NSDateFormatter alloc] init];
    [dateformatterM setDateFormat:@"MM"];
    
    originalYear = [[NSString stringWithFormat:@"%@",[dateformatterY stringFromDate:date]] intValue];
    originalMonth = [[NSString stringWithFormat:@"%@",[dateformatterM stringFromDate:date]] intValue];
    
    changeYear = originalYear;
    changeMonth = originalMonth;
    
    graph1Line = 16.0;
    graph2Line = 80.0;
    graph3Line = 40.0;
    
    graphXArr_ = [NSMutableArray array];//@[@3,@7,@10,@17,@21,@28];
    graphY1Arr_ = [NSMutableArray array];//@[@7,@11,@8,@9,@7,@8];
    graphY2Arr_ = [NSMutableArray array];//@[@7,@11,@8,@9,@7,@8];
    graphY3Arr_ = [NSMutableArray array];//@[@7,@11,@8,@9,@7,@8];
    
    [self getFuelConsumption];
    
    [self configUI];
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
