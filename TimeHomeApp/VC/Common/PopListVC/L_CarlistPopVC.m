//
//  L_CarlistPopVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/27.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarlistPopVC.h"

#import "L_CarListItemTVC.h"

@interface L_CarlistPopVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

/**
 1.大门 2.车牌 ...
 */
@property (nonatomic, assign) NSInteger type;

@end

@implementation L_CarlistPopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedRowHeight = 50;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_CarListItemTVC" bundle:nil] forCellReuseIdentifier:@"L_CarListItemTVC"];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == 1) {
        L_CorrgateModel *model = _dataArray[indexPath.row];
        return model.height;
    }
    
//    if (_type == 2) {
//        NSDictionary *carNumDict = _dataArray[indexPath.row];
//        return [carNumDict[@"height"] floatValue];
//    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_CarListItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CarListItemTVC"];
    
    if (_dataArray.count > 0) {
        
        if (_type == 1) {
            L_CorrgateModel *model = _dataArray[indexPath.row];
            cell.gateModel = model;
        }
        
//        if (_type == 2) {
//            
//            NSDictionary *carNumDict = _dataArray[indexPath.row];
//            cell.carNumDict = carNumDict;
//            
//        }

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_type == 1) {
        L_CorrgateModel *model = _dataArray[indexPath.row];
        if (self.cellSelectCallBack) {
            self.cellSelectCallBack(model, nil, 1);
        }
    }
    
    [self dismissVC];

//    if (_type == 2) {
//        
//        NSDictionary *carNumDict = _dataArray[indexPath.row];
//        if (self.cellSelectCallBack) {
//            self.cellSelectCallBack(carNumDict, nil, 2);
//        }
//        
//    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
}

/**
 *  返回实例
 *
 *  @return return value description
 */
+(L_CarlistPopVC *)getInstance {
    L_CarlistPopVC * popListVC= [[L_CarlistPopVC alloc] initWithNibName:@"L_CarlistPopVC" bundle:nil];
    return popListVC;
}

///显示
-(void)showVC:(UIViewController *)parent withDataArray:(NSArray *)array withType:(NSInteger)comeType cellEvent:(ViewsEventBlock)eventCallBack {
    
    _type = comeType;
    
    _dataArray = array;
    
    self.cellSelectCallBack = eventCallBack;
    
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

        NSInteger heigth= [_dataArray count]>10?(SCREEN_HEIGHT/2):(_dataArray.count*50.0);
        self.heightLayout.constant=heigth;
        [self.tableView reloadData];
        
    }];
    
}

/**
 *  隐藏显示
 */
- (void)dismissVC {
    
    self.view.backgroundColor=[UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{ }];
    
}
///点击半透明区域结束
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self dismissVC];
}

@end
