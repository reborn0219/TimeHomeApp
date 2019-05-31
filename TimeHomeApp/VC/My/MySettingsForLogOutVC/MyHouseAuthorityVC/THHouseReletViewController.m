//
//  THHouseReletViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THHouseReletViewController.h"
#import "HouseReletDateSelectButton.h"

#import "MMDateView.h"
#import "MMPopupWindow.h"
/**
*  网络请求
*/
#import "CommunityManagerPresenters.h"
#import "ParkingAuthorizePresenter.h"

@interface THHouseReletViewController ()
{
    NSString *beginDateString;
    NSString *endDateString;
    /**
     *  结束日期可选的最小日期
     */
    NSString *endDateMinString;
    NSString *beginDateMinString;

}
@end

@implementation THHouseReletViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"续租";
    
    [self createRightBarBtn];

    [self createContentView];
    
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
}
- (void)createContentView {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(7, 10, SCREEN_WIDTH-14, 20+18+20+35*2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i = 0; i < 2; i ++) {
        
        HouseReletDateSelectButton *button = [HouseReletDateSelectButton buttonWithType:UIButtonTypeCustom];
        button.dateStyle = i;
        button.frame = CGRectMake(15, 20+(35+18)*i, bgView.frame.size.width-2*15, 35);
        button.layer.borderColor = TEXT_COLOR.CGColor;
        button.layer.borderWidth = 1;
        button.tag = i;
        
        if (i == 0) {
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",self.rentbegindate] withFormat:@"yyyy-MM-dd hh:mm:ss"];
            beginDateString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            beginDateMinString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            button.dateLabel.text = beginDateString;
        }else {
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",self.rentenddate] withFormat:@"yyyy-MM-dd hh:mm:ss"];
            endDateString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            endDateMinString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            button.dateLabel.text = endDateString;
        }

        [button addTarget:self action:@selector(selectDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
    }
    
}
- (void)selectDateClick:(HouseReletDateSelectButton *)button {
    
//    if (button.tag == 0) {
//        return;
//    }
    
//    if (button.tag == 1 && [XYString isBlankString:beginDateString]) {
//        
//        [self showToastMsg:@"请先选择开始日期" Duration:2.0];
//
//    }
    
    MMDateView *dateView = [[MMDateView alloc]init];
    [dateView show];
    
    if (button.tag == 0) {
        dateView.titleLabel.text = @"开始日期";
        if (![XYString isBlankString:endDateString]) {
            
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",beginDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.date = date;
            
            NSDate *date1 = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",beginDateMinString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.minimumDate = date1;
            
//            if (![XYString isBlankString:endDateString]) {
//                NSDate *date2 = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",endDateString] withFormat:@"yyyy-MM-dd"];
//                dateView.datePicker.maximumDate = date2;
//            }
            
        }
    }else {
//        if (![XYString isBlankString:beginDateString]) {
//            
//            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",beginDateString] withFormat:@"yyyy-MM-dd"];
//            
//            dateView.datePicker.minimumDate = date;
//            dateView.datePicker.date = date;
//
//        }
        
//        NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",endDateMinString] withFormat:@"yyyy-MM-dd"];
//        dateView.datePicker.minimumDate = date;
        
        NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",beginDateString] withFormat:@"yyyy-MM-dd"];
        dateView.datePicker.minimumDate = date;
        
        NSDate *date2 = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",endDateString] withFormat:@"yyyy-MM-dd"];
        dateView.datePicker.date = date2;
        dateView.titleLabel.text = @"结束日期";
    }
    dateView.confirm = ^(NSString *data) {

        NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",data] withFormat:@"yyyy/MM/dd"];
        NSString *str = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
        
        if (button.tag == 0) {
            beginDateString = str;
//            return ;
        }else {
            endDateString = str;
        }
        
        button.dateLabel.text = str;
    };
    

    
}
/**
 *  完成按钮
 */
- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:kNewRedColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
/**
 *  完成按钮点击事件
 */
- (void)completionClick {
    
    NSDate *firstDate  = [XYString NSStringToDate:beginDateString withFormat:@"yyyy-MM-dd"];
    NSDate *secondDate = [XYString NSStringToDate:endDateString withFormat:@"yyyy-MM-dd"];
    BOOL isOld = [XYString CompireFromFirstTime:firstDate toSecondTime:secondDate];
    if (isOld) {
        [self showToastMsg:@"开始日期不能大于结束日期" Duration:2.0];
        return;
    }
    
    @WeakObj(self);
    /**
     *  房产
     */
    if (self.type == 0) {
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        [CommunityManagerPresenters renewResidencePowerID:self.theID begindate:beginDateString enddate:endDateString UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"续租成功" Duration:2.0];
                    if (selfWeak.callBack) {
                        selfWeak.callBack();
                    }
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                }
            });
            
        }];
    }
    /**
     *  车位
     */
    if (self.type == 1) {
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        [ParkingAuthorizePresenter renewParkingareaPowerForID:self.theID begindate:beginDateString enddate:endDateString upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode == SucceedCode)
                {
                    [selfWeak showToastMsg:@"续租成功" Duration:2.0];
                    if (selfWeak.callBack) {
                        selfWeak.callBack();
                    }
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                }
            });
            
        }];

    }


}


@end
