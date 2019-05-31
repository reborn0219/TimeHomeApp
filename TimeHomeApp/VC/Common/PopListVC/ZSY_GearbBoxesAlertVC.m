//
//  ZSY_GearbBoxesAlertVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_GearbBoxesAlertVC.h"
#import "TableViewDataSource.h"

@interface ZSY_GearbBoxesAlertVC ()<UITableViewDelegate>
{
    ///列表数据源
    TableViewDataSource *dataSource;
}
@end

@implementation ZSY_GearbBoxesAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (SCREEN_WIDTH <= 320) {
        _bgView.frame = CGRectMake(15, 8, SCREEN_WIDTH - 30, SCREEN_HEIGHT / 2);
    }else {
        
        _bgView.frame = CGRectMake(15, 8, SCREEN_WIDTH - 30, SCREEN_HEIGHT / 2);
    }
    
}

#pragma mark --------初始化--------
-(void)initView
{
    self.view.backgroundColor=RGBAFrom0X(0x000000, 0.7);
    self.tableView.delegate=self;
    self.listData=[NSMutableArray new];
    @WeakObj(self);
    dataSource=[[TableViewDataSource alloc]initWithItems:_listData cellIdentifier:@"defCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        if(selfWeak.cellViewBlock)
        {
            selfWeak.cellViewBlock(item,cell,indexPath);
        }
    }];
    dataSource.isSection=NO;
    dataSource.isDefaultCell=YES;
    self.tableView.dataSource=dataSource;
}
/**
 *  返回实例
 *
 *  @return return value description
 */
+(ZSY_GearbBoxesAlertVC *)getInstance
{
    ZSY_GearbBoxesAlertVC * gearbBoxes= [[ZSY_GearbBoxesAlertVC alloc] initWithNibName:@"ZSY_GearbBoxesAlertVC" bundle:nil];
    return gearbBoxes;
}
#pragma mark ----------关于列表数据及协议处理--------------
/**
 *  设置隐藏列表分割线
 *
 *  @param tableView tableView description
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  设置列表高度
 *
 *  @param tableView tableView description
 *  @param indexPath indexPath description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.cellEventBlock)
    {
        self.cellEventBlock([_listData objectAtIndex:indexPath.row],tableView,indexPath);
    }
    
}





#pragma mark ------------显示隐藏---------------

///显示
-(void)showVC:(UIViewController *) parent
{
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
        //        self.view.backgroundColor=RGBAFrom0X(0x000000, 0.7);
        NSInteger heigth= [self.listData count]>10?(SCREEN_HEIGHT/2):(self.listData.count*50.0);
        self.height.constant=heigth;
        [self.tableView reloadData];
    }];
    
    
}

///显示
-(void)showVC:(UIViewController *)parent listData:(NSArray *)data cellEvent:(CellEventBlock) cellEventBlock cellViewBlock:(CellEventBlock) cellViewBlock;
{
    [self showVC:parent];
    [self.listData addObjectsFromArray:data];
    self.cellEventBlock=cellEventBlock;
    self.cellViewBlock=cellViewBlock;
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
        [parent presentViewController:self animated:YES completion:^{
    
            NSInteger heigth= [self.listData count]>10?(SCREEN_HEIGHT/2):(self.listData.count*50.0);
            self.height.constant=heigth;
            [self.tableView reloadData];
        }];
    
}


/**
 *  隐藏显示
 */
-(void)dismissVC
{
    self.view.backgroundColor=[UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}

///点击半透明区域结束
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissVC];
}


- (IBAction)closeButton:(id)sender {
    [self dismissVC];
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
