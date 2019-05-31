//
//  L_ReletHouseViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ReletHouseViewController.h"

#import "MMDateView.h"
#import "MMPopupWindow.h"

@interface L_ReletHouseViewController ()

/**
 内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayoutConstraint;

/**
 开始日期
 */
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

/**
 结束日期
 */
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

/**
 姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *peopleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;

/**
 结束日期
 */
@property (nonatomic, strong) NSString *endDateString;

@end

@implementation L_ReletHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XYString isBlankString:_startDateString]) {
        _startDateLabel.text = @"开始日期";
    }else {
        _startDateLabel.text = _startDateString;
    }
    
    _endDateLabel.text = @"结束日期";
    
    _contentViewHeightLayoutConstraint.constant = SCREEN_HEIGHT - 16 - 64;
    
    _bgView1.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView1.layer.borderWidth = 1;
    _bgView2.layer.borderColor = UIColorFromRGB(0xB5B5B5).CGColor;
    _bgView2.layer.borderWidth = 1;
    
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
}

// MARK: - 按钮点击
- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    //1.开始日期 2.结束日期 3.续租
    
    if (sender.tag == 1) {
        
        MMDateView *dateView = [[MMDateView alloc]init];
        [dateView show];
        dateView.titleLabel.text = @"开始日期";
        if (![XYString isBlankString:_startDateString]) {
            
            NSDate *startDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_startDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.date = startDate;
            
//            NSDate *minDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_startDateString] withFormat:@"yyyy-MM-dd"];
//            dateView.datePicker.minimumDate = minDate;
            
        }else {
            dateView.datePicker.date = [NSDate date];
        }
        if (![XYString isBlankString:_endDateString]) {
            NSDate *endDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_endDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.maximumDate = endDate;
        }
        dateView.confirm = ^(NSString *data) {
            
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",data] withFormat:@"yyyy/MM/dd"];
            NSString *str = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            
            _startDateString = str;

            _startDateLabel.text = _startDateString;
        };
        
    }else if (sender.tag == 2) {
        
        MMDateView *dateView = [[MMDateView alloc]init];
        [dateView show];
        dateView.titleLabel.text = @"结束日期";
        if (![XYString isBlankString:_startDateString]) {
            
            NSDate *minDate = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",_startDateString] withFormat:@"yyyy-MM-dd"];
            dateView.datePicker.minimumDate = minDate;
            
        }

        dateView.confirm = ^(NSString *data) {
            
            NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",data] withFormat:@"yyyy/MM/dd"];
            NSString *str = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            
            _endDateString = str;
            
            _endDateLabel.text = _endDateString;
        };
        
    }else if (sender.tag == 3) {
        NSLog(@"续租");
    }
    
}


@end
