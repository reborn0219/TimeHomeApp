//
//  L_RentDetailViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_RentDetailViewController.h"
#import "L_PeopleListViewController.h"
#import "L_AddFamilysViewController.h"

@interface L_RentDetailViewController ()

/**
 高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *topBgBorderView;

/**
 天数
 */
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

/**
 社区
 */
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

/**
 房产地址
 */
@property (weak, nonatomic) IBOutlet UILabel *houseAddressLabel;

/**
 租期
 */
@property (weak, nonatomic) IBOutlet UILabel *rentDateLabel;

/**
 中间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *middleButton;


@end

@implementation L_RentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (SCREEN_WIDTH == 320) {
        _contentViewHeightLayoutConstraint.constant = 520;
    }else {
        _contentViewHeightLayoutConstraint.constant = SCREEN_HEIGHT - 16 - 64;
    }
    
    _topBgView.clipsToBounds = YES;
    _topBgView.layer.cornerRadius = 75;
    
    _topBgBorderView.clipsToBounds = YES;
    _topBgBorderView.layer.cornerRadius = 68;
    _topBgBorderView.layer.borderColor = kNewRedColor.CGColor;
    _topBgBorderView.layer.borderWidth = 1;
    
    if (_rentState == 1) {
        [_middleButton setBackgroundColor:kNewRedColor];
        [_middleButton setTitle:@"添加家人" forState:UIControlStateNormal];
    }else if (_rentState == 2) {
        [_middleButton setBackgroundColor:kNewRedColor];
        [_middleButton setTitle:@"家人列表" forState:UIControlStateNormal];
    }else {
        [_middleButton setBackgroundColor:NEW_GRAY_COLOR];
        [_middleButton setTitle:@"您已被添加为家人" forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)middleButtonDidTouch:(UIButton *)sender {
    NSLog(@"按钮点击了");
    /** 1.添加家人 2.家人列表 3.已被添加家人 */
    if (_rentState == 1) {
        
        L_AddFamilysViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddFamilysViewController"];
        [self.navigationController pushViewController:addVC animated:YES];
        
    }else if (_rentState == 2) {
        
        L_PeopleListViewController *peopleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_PeopleListViewController"];
        [self.navigationController pushViewController:peopleVC animated:YES];
        
    }else {
        return;
    }
}


@end
