//
//  L_NewBikeBottomPopViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeBottomPopViewController.h"
#import "L_NewBikeBottomViewTVC.h"

@interface L_NewBikeBottomPopViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation L_NewBikeBottomPopViewController

/**
 关闭按钮点击
 */
- (IBAction)closeButtonDidTouch:(UIButton *)sender {
    [self dismissVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeBottomViewTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeBottomViewTVC"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissVC)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.tableView] || [touch.view isDescendantOfView:self.topBgView]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_NewBikeBottomViewTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeBottomViewTVC"];
    
    [cell.titleButton setTitle:_dataArray[indexPath.row] forState:UIControlStateNormal];
    cell.titleDidTouchBlock = ^(){
        
        if (self.selectButtonCallBack) {
            self.selectButtonCallBack([XYString IsNotNull:_dataArray[indexPath.row]]);
        }
        [self dismissVC];
        
    };
    
    return cell;
}

/**
 *  返回实例
 */
+ (L_NewBikeBottomPopViewController *)getInstance {
    L_NewBikeBottomPopViewController * garageTimePopVC= [[L_NewBikeBottomPopViewController alloc] initWithNibName:@"L_NewBikeBottomPopViewController" bundle:nil];
    return garageTimePopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withDataArray:(NSArray *)array cellEvent:(SelectButtonCallBack)eventCallBack {
    
    self.selectButtonCallBack = eventCallBack;
    
    if (array.count < 6) {
        _tableViewHeightLayoutConstraint.constant = 46 * array.count;
    }
    
    _dataArray = [array copy];
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    
}
#pragma mark - 隐藏显示
-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
