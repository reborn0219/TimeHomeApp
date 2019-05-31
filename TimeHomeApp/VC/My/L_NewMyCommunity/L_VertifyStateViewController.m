//
//  L_VertifyStateViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_VertifyStateViewController.h"
#import "L_PeopleListViewController.h"
#import "L_NewMyCommunityHouseVC.h"
#import "L_AddFamilysViewController.h"
#import "L_AddHouseViewController.h"

@interface L_VertifyStateViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation L_VertifyStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stateImageView.image = [UIImage imageNamed:[XYString IsNotNull:_stateImageName]];
    
    _stateLabel.text = [XYString IsNotNull:_stateStr];
    
    _contentLabel.text = [XYString IsNotNull:_content];
    
    _firstButton.hidden = YES;
    _secondButton.hidden = YES;
    
    if (_state == 1) {
        _firstButton.hidden = NO;
        _secondButton.hidden = NO;
        [_firstButton setTitle:@"添加家人" forState:UIControlStateNormal];
        [_secondButton setTitle:@"房产出租" forState:UIControlStateNormal];
    }
    if (_state == 2) {
        _firstButton.hidden = NO;
        _secondButton.hidden = NO;
        [_firstButton setTitle:@"家人列表" forState:UIControlStateNormal];
        [_secondButton setTitle:@"房产出租" forState:UIControlStateNormal];
    }
    if (_state == 3) {
        _firstButton.hidden = NO;
        _secondButton.hidden = YES;
        [_firstButton setTitle:@"重新认证" forState:UIControlStateNormal];
    }
    if (_state == 4) {
        _firstButton.hidden = YES;
        _secondButton.hidden = YES;
        [_firstButton setTitle:@"添加家人" forState:UIControlStateNormal];
        [_secondButton setTitle:@"房产出租" forState:UIControlStateNormal];
    }
    if (_state == 5) {
        _bgView.hidden = YES;
        [self showNothingnessViewWithType:NoContentTypeCertifyCheck Msg:@"后台正快马加鞭为您审核中..." SubMsg:@"若五个工作日仍未通过，请拨打您小区的物业电话了解审核进度！" btnTitle:nil eventCallBack:nil];
        self.nothingnessView.btn_Go.hidden = YES;
    }
    
}
- (IBAction)buttonsDidTouch:(UIButton *)sender {
    //1.第一个按钮 2.第二个按钮
    if (sender.tag == 1) {
        
        if (_state == 1 || _state == 4) {
            L_AddFamilysViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddFamilysViewController"];
            [self.navigationController pushViewController:addVC animated:YES];
        }
        
        if (_state == 2) {
            L_PeopleListViewController *peopleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_PeopleListViewController"];
            [self.navigationController pushViewController:peopleVC animated:YES];
        }
        
        if (_state == 3) {
            L_AddHouseViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddHouseViewController"];
            [self.navigationController pushViewController:addVC animated:YES];
        }
        
    }
    if (sender.tag == 2) {
        L_NewMyCommunityHouseVC *houseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewMyCommunityHouseVC"];
        [self.navigationController pushViewController:houseVC animated:YES];
    }
}


@end
