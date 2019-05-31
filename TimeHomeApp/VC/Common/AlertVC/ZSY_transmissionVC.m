//
//  ZSY_transmissionVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_transmissionVC.h"
#import "ZSY_CarModelCell.h"

@interface ZSY_transmissionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *transmissionTitle;

@end

@implementation ZSY_transmissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createTableView];
}




- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
//    [_dataSource addObjectsFromArray:@[@"AT(自动)",@"MT(手动)",@"无极变速(CVT)",@"双离合变速(DSG)",@"序列变速箱(AMT)"]];
    [_dataSource addObjectsFromArray:@[@"AT(自动)",@"MT(手动)",@"CVT(无极变速)",@"DSG(双离合变速)",@"AMT(序列变速箱)"]];
//    for (int i = 0; i < 100; i++) {
//        
//        [_dataSource addObject:[NSString stringWithFormat:@"变速箱型号:%d",i]];
//    }
    
    _view_H.constant = 280;

}

- (void)createTableView {
    
   
    //    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineView.frame), _bgView.frame.size.width - 40, _bgView.frame.size.height + 40) style:UITableViewStylePlain];
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, _bgView.frame.size.width, _bgView.frame.size.height - 80) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_CarModelCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

#pragma mark -- tableViewDataSource And tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSY_CarModelCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableViewCell.leftLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    return tableViewCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ZSY_CarModelCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
   
//    NSDictionary *dic = [NSDictionary alloc] initWithObjectsAndKeys:cell.leftLabel.text, nil
   
    if (self.block) {
   
        self.block(cell.leftLabel.text,nil,indexPath.row);
        
    }
    
    
    
}




+(instancetype)sharetransmissionAlert {
    
    static ZSY_transmissionVC * transmission = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        transmission = [[self alloc] initWithNibName:@"ZSY_transmissionVC" bundle:nil];
        
    });
    
    return transmission;
}

/**
 *  获取实例
 *
 *  @return return value description
 */
+(ZSY_transmissionVC *)getInstance {
    
    ZSY_transmissionVC * transmission= [[ZSY_transmissionVC alloc] initWithNibName:@"ZSY_transmissionVC" bundle:nil];
    return transmission;
    
}

-(void)showInVC:(UIViewController *)VC andBlcok:(ViewsEventBlock)blcok {
    
    _block = blcok;
    
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





//-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andData:(NSMutableArray *)dataSource andBlcok:(ViewsEventBlock)blcok {
//    
////    [self createDataSource];
//    
//    [self createTableView];
//    _leftLabel.text = title;
//     _dataSource = dataSource;
//    _block = blcok;
//    
//    if (self.isBeingPresented) {
//        return;
//    }
//    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    /**
//     *  根据系统版本设置显示样式
//     */
//    
//    if (SCREEN_WIDTH <= 320) {
//        _bgView.frame = CGRectMake(10, SCREEN_HEIGHT / 2 + 150, SCREEN_WIDTH - 20, 300);
//        //        _bgView.sd_layout.heightIs(SCREEN_HEIGHT / 5 * 2).leftSpaceToView(self.view,8).rightSpaceToView(self.view,8).centerYEqualToView(self.view);
//    }
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        
//        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
//        //        self.modalPresentationStyle=UIModalPresentationCustom;
//    }
//    else{
//        self.modalPresentationStyle=UIModalPresentationCustom;
//    }
//    
//    
//    [VC presentViewController:self animated:YES completion:^{
//        
//    }];
//    
//
//}

-(void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

///点击半透明区域结束
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}


- (IBAction)closeClick:(UIButton *)sender {
    
    [self dismiss];
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
