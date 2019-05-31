//
//  NewsVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NewsVC.h"
#import "TableViewDataSource.h"
#import "NewsTableViewOneCell.h"
#import "NewsTableViewThreeCell.h"
#import "NewsTableViewTwoCell.h"
#import "NewsPresenter.h"

@interface NewsVC ()<UITableViewDelegate,UITableViewDataSource>
{

    ///新闻列表数据
    NSMutableArray * newsArray;
    ///页数计数
    NSInteger page;
}
/**
 *  本小区
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Village;

/**
 *  全部
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_All;

/**
 *  列表显示
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewOneCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewOneCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewTwoCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewThreeCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewThreeCell"];
    /**
     
     *  测试数据
     */
    newsArray=[NSMutableArray new];

    [self setExtraCellLineHidden:self.tableView];//隐藏tableView分割线
    
    @WeakObj(self);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak topRefresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadmore];
    }];
    
}

///下拉刷新数据
-(void)topRefresh
{
    page=1;
    [self getData:[NSString stringWithFormat:@"%ld",(long)page]];
}
///上拉加载更多
-(void)loadmore
{
    page++;
    [self getData:[NSString stringWithFormat:@"%ld",(long)page]];
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

/**
 *  设置列表数据
 *
 *  @param data      <#data description#>
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return newsArray.count;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        NewsTableViewOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewOneCell"
                                                                forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row==1)
    {
        NewsTableViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewTwoCell"
                                                                forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row==2)
    {
        NewsTableViewThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewThreeCell"
                                                                forIndexPath:indexPath];
        return cell;
    }
    NewsTableViewOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewOneCell" forIndexPath:indexPath];

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
    if (indexPath.row==0) {
        return 200;
    }
    else if (indexPath.row==1)
    {
        return 120;
    }
    else if (indexPath.row==2)
    {
        return 180;
    }
    return 200;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}




#pragma mark ------------------网络-----------------

///获取通知数据
-(void)getData:(NSString *)pageStr
{
    NewsPresenter * newsPresenter=[NewsPresenter new];
    
    [newsPresenter getAppComNewsForType:@"1" page:pageStr upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                if(page>1)
                {
                    [self.tableView.mj_footer endRefreshing];
                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=newsArray.count;
                    [newsArray addObjectsFromArray:tmparr];
                    
                    [self.tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    
                    /** 插入一个新cell */
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];

                    
                }
                else
                {
                    [self.tableView.mj_header endRefreshing];
                    [newsArray removeAllObjects];
                    [newsArray addObjectsFromArray:data];
                    [self.tableView reloadData];
                    
                }
            }
            else if(resultCode==FailureCode)
            {
                if(data==nil||![data isKindOfClass:[NSDictionary class]])
                {
                    return ;
                }
                NSDictionary *dicJson=(NSDictionary *)data;
                NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
                if(page>1)
                {
                    page--;
                    [self.tableView.mj_footer endRefreshing];
                } else {
                    [self.tableView.mj_header endRefreshing];

                    if(errcode==99999)
                    {
                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"物业没有发布新闻" eventCallBack:nil];

                        return ;
                    }
                    
                }
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                if(page>1)
                {
                    page--;
                    [self.tableView.mj_footer endRefreshing];
                }
                else{
                    [self.tableView.mj_header endRefreshing];
                }
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];
                
            }
        });

    }];
    
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
