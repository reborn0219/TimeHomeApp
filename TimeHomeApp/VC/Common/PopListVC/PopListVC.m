//
//  PopListVC.m
//  TimeHomeApp
//
//  Created by us on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PopListVC.h"
#import "TableViewDataSource.h"
@interface PopListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    ///列表数据源
    TableViewDataSource *dataSource;
}

@end

@implementation PopListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
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


#pragma mark - tableViewDelegate

/**
 *  返回实例
 *
 *  @return return value description
 */
+(PopListVC *)getInstance {
    PopListVC * popListVC= [[PopListVC alloc] initWithNibName:@"PopListVC" bundle:nil];
    return popListVC;
}



#pragma mark ----------关于列表数据及协议处理--------------
/**
 *  设置隐藏列表分割线
 *
 *  @param tableView tableView description
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}

//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.cellEventBlock) {
        self.cellEventBlock([_listData objectAtIndex:indexPath.row],tableView,indexPath);
    }
    
}

#pragma mark ------------显示隐藏---------------

///显示
-(void)showVC:(UIViewController *) parent {
    
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
        self.nsLay_TableHeigth.constant=heigth;
        [self.tableView reloadData];
    }];
    
}

///显示
-(void)showVC:(UIViewController *)parent listData:(NSArray *)data cellEvent:(CellEventBlock) cellEventBlock cellViewBlock:(CellEventBlock) cellViewBlock {
    
    [self showVC:parent];
    [self.listData addObjectsFromArray:data];
    self.cellEventBlock=cellEventBlock;
    self.cellViewBlock=cellViewBlock;

}
/**
 *  隐藏显示
 */
-(void)dismissVC {
    
    self.view.backgroundColor=[UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{ }];
    
}
///点击半透明区域结束
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self dismissVC];
}

@end
