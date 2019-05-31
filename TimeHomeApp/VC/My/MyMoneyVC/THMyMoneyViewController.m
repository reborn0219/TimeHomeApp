//
//  THMyMoneyViewController.m
//  TimeHomeApp
//
//  Created by 李世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyMoneyViewController.h"

@interface THMyMoneyViewController ()
{
    /**
     *  登录用户
     */
    UserData *userData;
}

@end

@implementation THMyMoneyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"余额";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    view.backgroundColor = BLACKGROUND_COLOR;
    [self.view addSubview:view];
    
    [self createRightBarBtn];
    
    AppDelegate *appDelegate = GetAppDelegates;
    userData = appDelegate.userData;
    
    [self setUpContentView];

}

- (void)setUpContentView {
    
    UIView *whitebgView = [[UIView alloc]init];
    whitebgView.clipsToBounds = YES;
    whitebgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whitebgView];
    whitebgView.sd_layout.topSpaceToView(self.view,WidthSpace(137)).widthIs(WidthSpace(117)).heightEqualToWidth().centerXEqualToView(self.view);
    whitebgView.sd_cornerRadiusFromWidthRatio = @(0.5);

    UIImageView *pigImage = [[UIImageView alloc]init];
    pigImage.image = [UIImage imageNamed:@"余额"];
    [whitebgView addSubview:pigImage];
    pigImage.sd_layout.centerXEqualToView(whitebgView).centerYEqualToView(whitebgView).widthRatioToView(whitebgView,0.5).heightEqualToWidth();
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[userData.balance floatValue]];
    moneyLabel.font = DEFAULT_BOLDFONT(30);
    moneyLabel.textColor = TITLE_TEXT_COLOR;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:moneyLabel];
    moneyLabel.sd_layout.leftSpaceToView(self.view,20).rightSpaceToView(self.view,20).topSpaceToView(whitebgView,WidthSpace(45)).heightIs(WidthSpace(70));
    
    UIButton *czBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [czBtn setTitle:@"充    值" forState:UIControlStateNormal];
    [czBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    czBtn.titleLabel.font = DEFAULT_BOLDFONT(16);
    [czBtn setBackgroundColor:PURPLE_COLOR];
    [self.view addSubview:czBtn];
    czBtn.sd_layout.leftSpaceToView(self.view,WidthSpace(70)).rightSpaceToView(self.view,WidthSpace(70)).topSpaceToView(moneyLabel,WidthSpace(90)).heightIs(WidthSpace(74));
    [czBtn addTarget:self action:@selector(chongZhiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)chongZhiButtonClick {
    
    NSLog(@"充值");
    
}

- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"充值记录" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:PURPLE_COLOR];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)completionClick {
    
    NSLog(@"充值记录");
    
}

@end
