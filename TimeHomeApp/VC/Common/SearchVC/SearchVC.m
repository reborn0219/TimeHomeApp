//
//  SearchVCViewController.m
//  TimeHomeApp
//
//  Created by us on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SearchVC.h"
#import "TableViewDataSource.h"
@interface SearchVC ()<UITextFieldDelegate>
{
    ///列表数据源
    TableViewDataSource *dataSource;
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setExtraCellLineHidden:self.tableView];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.TF_SearchText becomeFirstResponder];
}
#pragma mark --------初始化--------
-(void)initView
{
    self.TF_SearchText.delegate=self;
    self.tableView.delegate=self;
    self.searchArray=[NSMutableArray new];
    @WeakObj(self);
    dataSource=[[TableViewDataSource alloc]initWithItems:_searchArray cellIdentifier:@"SearchCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
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
+(SearchVC *)getInstance
{
    SearchVC * searchVC= [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
    return searchVC;
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
        self.cellEventBlock([_searchArray objectAtIndex:indexPath.row],tableView,indexPath);
    }
    [self dismissVC];
}

#pragma mark ----------事件处理--------
///输入改变事件
- (IBAction)TF_SearchChanged:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>0)
        {
            if(self.tableView.hidden)
            {
                self.tableView.hidden=NO;
            }
        }
        else
        {
            [_searchArray removeAllObjects];
            [self.tableView reloadData];
            if(!self.tableView.hidden)
            {
                self.tableView.hidden=YES;
            }
        }
        if(self.viewEventBlock)
        {
//            self.viewEventBlock(sender.text,sender,0);
            self.viewEventBlock(self.TF_SearchText.text,sender,2);

        }
    }

}

///取消事件
- (IBAction)btn_CancelEvnet:(UIButton *)sender {
     [self dismissVC];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissVC];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.TF_SearchText resignFirstResponder];
    if(self.viewEventBlock)
    {
        self.viewEventBlock(self.TF_SearchText.text,textField,2);
    }
    return YES;
}


#pragma mark ------------显示隐藏---------------
///显示
-(void)showVC:(UIViewController *) parent
{
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    self.view.backgroundColor=[UIColor clearColor];
    [parent presentViewController:self animated:YES completion:^{
        self.view.backgroundColor=RGBAFrom0X(0x000000, 0.7);
        self.tableView.hidden=YES;
    }];

}

///显示
-(void)showVC:(UIViewController *) parent cellEvent:(CellEventBlock) cellEventBlock viewsEvent:(ViewsEventBlock ) viewEventBlock cellViewBlock:(CellEventBlock) cellViewBlock;
{
    self.cellEventBlock=cellEventBlock;
    self.viewEventBlock=viewEventBlock;
    self.cellViewBlock=cellViewBlock;
    [self showVC:parent];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
