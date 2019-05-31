//
//  THDoorNumberViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THDoorNumberViewController.h"
#import "THDoorNumberView.h"
#import "THMyInfoPresenter.h"

@interface THDoorNumberViewController ()
{
    /**
     *  是否显示楼牌号
     */
    NSString *isshowbuilding;
}
@property (nonatomic, strong) THDoorNumberView *doorNumberView;
/**
 *  登录用户信息
 */
@property (nonatomic, strong) UserData *userData;
@end

@implementation THDoorNumberViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GeRenSheZhi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GeRenSheZhi}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"门牌号";
    
    AppDelegate *appDelegate = GetAppDelegates;
    _userData = appDelegate.userData;
    isshowbuilding = _userData.isshowbuilding;
    
    [self createRightBarBtn];

    [self createDoorNumberView];
    
}
- (void)createDoorNumberView {
    
    _doorNumberView = [[THDoorNumberView alloc]initWithFrame:CGRectMake(7, 10, SCREEN_WIDTH-14.f, WidthSpace(338))];
    _doorNumberView.backgroundColor = [UIColor whiteColor];
    _doorNumberView.titleLabel.text = @"输入您家的门牌号信息";
    if (![XYString isBlankString:_userData.building]) {
        _doorNumberView.doorNumTF.text = _userData.building;
//        _doorNumberView.doorNumTF.placeholder = @"";

    }
//    else {
        _doorNumberView.doorNumTF.placeholder = @"XX号楼XX单元XXX";
//
//    }
    BOOL isShow = isshowbuilding.intValue == 1 ? YES :NO;
    [_doorNumberView.switchButton setOn:isShow];
    [self.view addSubview:_doorNumberView];
    _doorNumberView.switchButtonCallBack = ^(BOOL isOpen) {
      
        if (!isOpen) {
            //关闭
            isshowbuilding = @"0";
            
        }
        if (isOpen) {
            //打开
            isshowbuilding = @"1";

        }
        
    };
}

- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:kNewRedColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)completionClick {
    
    @WeakObj(self);

    [_doorNumberView.doorNumTF resignFirstResponder];
    
    if ([XYString isBlankString:_doorNumberView.doorNumTF.text]) {
        [self showToastMsg:@"门牌号不能为空" Duration:2.0];
        return;
    }
    
    //保存楼牌号请求
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
//    NSString *building = @"";
//    if ([XYString isBlankString:_doorNumberView.doorNumTF.text]) {
//        building = _doorNumberView.doorNumTF.placeholder;
//    }else {
//        building = _doorNumberView.doorNumTF.text;
//    }
    [THMyInfoPresenter perfectMyUserInfoDict:@{@"building":_doorNumberView.doorNumTF.text,@"isshowbuilding":isshowbuilding} UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        [GCDQueue executeInGlobalQueue:^{
            [GCDQueue executeInMainQueue:^{
                [indicator stopAnimating];

                if(resultCode == SucceedCode)
                {
                    
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                }
            }];
        }];
        

        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
