//
//  LifeSelectListVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LifeSelectListVC.h"

@interface LifeSelectListVC ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  列表展示
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation LifeSelectListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView alloc]init];
    if(self.listData==nil)
    {
        self.listData=[NSMutableArray new];
    }
    [self setExtraCellLineHidden:self.tableView];
}
#pragma mark ----------关于列表数据源处理--------------
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

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.accessoryView = nil;

    if(self.indexSelected==indexPath.row)//选中
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"生活_勾选"]];
        imageView.frame = CGRectMake(0, 0, 20, 20);
        cell.accessoryView = imageView;

        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    if(self.cellViewBlock)
    {
        self.cellViewBlock([self.listData objectAtIndex:indexPath.row],cell,indexPath);
    }

    return cell;
}

#pragma mark ----------关于列表协议处理--------------
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
    return 40;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.indexSelected=indexPath.row;
    
    if(self.cellEventBlock)
    {
        self.cellEventBlock([_listData objectAtIndex:indexPath.row],tableView,indexPath);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
    
}


@end
