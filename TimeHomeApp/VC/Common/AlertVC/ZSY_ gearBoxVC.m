//
//  ZSY_ gearBoxVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_ gearBoxVC.h"
#import "ZSY_CarModelCell.h"
@interface ZSY__gearBoxVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSString *firstTitles;
    NSMutableArray *data;
}

@end

@implementation ZSY__gearBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _titlesLabel.text = firstTitles;
    
}
//单例初始化
+(instancetype)gearBoxVC {
    
    static ZSY__gearBoxVC * gearBox = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        gearBox = [[self alloc] initWithNibName:@"OBDShowAlertVC" bundle:nil];
        
    });
    
    return gearBox;
}
/**
 *  获取实例
 *
 *  @return return value description
 */
+(ZSY__gearBoxVC *)getInstance{
    ZSY__gearBoxVC * gearBox= [[ZSY__gearBoxVC alloc] initWithNibName:@"ZSY__gearBoxVC" bundle:nil];
    return gearBox;
}

-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andDataSource:(NSMutableArray *)dataSource {
    
    firstTitles=title;
    _dataSource = dataSource;
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    
    if (SCREEN_WIDTH <= 320) {
        _bgView.frame = CGRectMake(10, SCREEN_HEIGHT / 2 + 150, SCREEN_WIDTH - 20, 300);
        //        _bgView.sd_layout.heightIs(SCREEN_HEIGHT / 5 * 2).leftSpaceToView(self.view,8).rightSpaceToView(self.view,8).centerYEqualToView(self.view);
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
        //        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];



}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)closeButton:(id)sender {
    
    [self dismiss];

}



- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_lineView.frame) + 8, _bgView.frame.size.width, _bgView.frame.size.height - 8 - CGRectGetMaxY(_lineView.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_bgView addSubview:_tableView];
 
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_CarModelCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
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
