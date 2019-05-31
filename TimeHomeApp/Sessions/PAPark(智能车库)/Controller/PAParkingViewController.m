//
//  PAParkingViewController.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAParkingViewController.h"
#import "PACarManagementController.h"
#import "PACarSpaceManagermentViewController.h"

@interface PAParkingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *spaceSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *carSettingButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, strong) PACarManagementController * carController;
@property (nonatomic, strong) PACarSpaceManagermentViewController * carSpaceController;

@end

@implementation PAParkingViewController

#pragma mark - LifeCycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - InitUI

-(void)initializeUI
{
    self.navigationItem.title = @"车位管理";
    [self.mainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*2, 0)];

    // 车位设置界面
    self.carSpaceController = [[PACarSpaceManagermentViewController alloc]init];
    [self.carSpaceController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.mainScrollView.height)];
    [self addChildViewController:self.carSpaceController];
    [self.mainScrollView addSubview:self.carSpaceController.view];

    // 车辆设置界面
    self.carController = [[PACarManagementController alloc]init];
    [self addChildViewController:self.carController];
    [self.carController.view setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.mainScrollView addSubview:self.carController.view];
    
}

#pragma mark - IBActions

- (IBAction)carSettingChangeAction:(id)sender {
    
    UIButton * button = sender;
    
    if (button.tag == 100) {
        //车位设置
        [self.spaceSettingButton setBackgroundColor: UIColorFromRGB(0x629CDF)];
        [self.spaceSettingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.carSettingButton setBackgroundColor:[UIColor clearColor]];
        [self.carSettingButton setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (button.tag == 99){
        //车辆设置
        [self.carSettingButton setBackgroundColor: UIColorFromRGB(0x629CDF)];
        [self.carSettingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.spaceSettingButton setBackgroundColor:[UIColor clearColor]];
        [self.spaceSettingButton setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        
    }
}

@end
