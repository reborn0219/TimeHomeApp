//
//  CarLocationVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarLocationVC.h"
#import "TableViewDataSource.h"
#import "CarLocationCell.h"
#import "CarLocationPresenter.h"
#import "CarListModel.h"
#import "AddCarLocationVC.h"
#import "ShowMapVC.h"
#import "SysPresenter.h"

@interface CarLocationVC ()<UITableViewDelegate>
{
    /**
     *  数据源
     */
    TableViewDataSource * dataSource;
    ///车辆数据
    NSMutableArray * carArray;
    ///页数
    NSInteger page;
    ///定位车辆处理
    CarLocationPresenter * carLocaionPresenter;
}

///没有数据说明页
@property (weak, nonatomic) IBOutlet UIButton *btn_NoData;

/**
 *  列表显示
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CarLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView triggerPullToRefresh];
    
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    self.btn_NoData.adjustsImageWhenHighlighted = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"CarLocationCell" bundle:nil] forCellReuseIdentifier:@"CarLocationCell"];
    //    self.tableView.allowsSelection = NO;//列表不可选择
    
    carLocaionPresenter=[CarLocationPresenter new];
    carArray=[NSMutableArray new];
    
    @WeakObj(self);
    dataSource=[[TableViewDataSource alloc]initWithItems:carArray cellIdentifier:@"CarLocationCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
    }];
    dataSource.isSection=NO;
    self.tableView.dataSource=dataSource;
    [self setExtraCellLineHidden:self.tableView];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [selfWeak topRefresh];
        
    } ];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [selfWeak loadmore];
        
    }];
    self.btn_NoData.hidden=YES;
    self.btn_NoData.imageView.contentMode=UIViewContentModeScaleAspectFill;
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
 *  设置列表数据
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    CarLocationCell *carCell=(CarLocationCell *)cell;
    CarListModel * carModle=(CarListModel *)data;
    carCell.lab_CarNum.text=carModle.card;
    carCell.lab_Addr.text=carModle.addr;
    ///删除
    carCell.delCallBack=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        [self delData:index];
    };
    ///编辑
    carCell.editCallBack=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        CarListModel * carModle=[carArray objectAtIndex:index.row];
        AddCarLocationVC * addCarVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddCarLocationVC"];
        addCarVC.carModle=carModle;
        [self.navigationController pushViewController:addCarVC animated:YES];
    };
    
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
    return 90;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CarListModel * carModle=[carArray objectAtIndex:indexPath.row];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
    ShowMapVC * carMap= [secondStoryBoard instantiateViewControllerWithIdentifier:@"ShowMapVC" ];
    carMap.jumpCode=1;
    carMap.title=@"车辆定位";
    carMap.carListModel= carModle;
    [self.navigationController pushViewController:carMap animated:YES];
    
}


#pragma mark ---------------------网络-----------------
-(void)delData:(NSIndexPath *)indexPath
{
    CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
    @WeakObj(self);
    [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
     {
         if(index==ALERT_OK)
         {
             CarListModel * carModle=[carArray objectAtIndex:indexPath.row];
             [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
             [carLocaionPresenter removeusercarpositionForID:carModle.ID upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                     if(resultCode==SucceedCode)
                     {
                         [carArray removeObjectAtIndex:indexPath.row];
                         [selfWeak.tableView reloadData];
                         [selfWeak showToastMsg:@"删除成功" Duration:5.0];
                     }
                     else
                     {
                         [selfWeak showToastMsg:@"data" Duration:5.0];
                     }
                     
                 });

             }];
         }
         
     }];
    
    [alertVc ShowAlert:self Title:@"删除设备" Msg:@"您确认要删除此设备?" oneBtn:@"取消" otherBtn:@"确定"];
}


///获取通知数据
-(void)getData:(NSString *)pageStr
{
    
    [carLocaionPresenter getUserCarPositionForPage:pageStr upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                NSArray * tmparr=(NSArray *)data;
                [self getAddresForArray:tmparr];
                [self hiddenNothingnessView];
                if(page>1)
                {
                    [self.tableView.infiniteScrollingView stopAnimating];
                    
                    NSInteger count=carArray.count;
                    [carArray addObjectsFromArray:tmparr];
                    [self.tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                }
                else
                {
                    [self.tableView.pullToRefreshView stopAnimating];
                    [carArray removeAllObjects];
                    [carArray addObjectsFromArray:tmparr];
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
//                NSString * errmsg=[dicJson objectForKey:@"errmsg"];
                if(page>1)
                {
                    page--;
                    [self.tableView.infiniteScrollingView stopAnimating];
//                    [self showToastMsg:errmsg Duration:5.0];
                }
                else{
                    [self.tableView.pullToRefreshView stopAnimating];

                    if(errcode==99999)
                    {
                        self.btn_NoData.hidden=NO;

                    }
                    
                }
                
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                if(page>1)
                {
                    page--;
                    [self.tableView.infiniteScrollingView stopAnimating];
                }
                else{
                    [self.tableView.pullToRefreshView stopAnimating];
                }
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];

                
            }
            
            
        });

    }];
}
///获取车辆当前地址
-(void)getAddresForArray:(NSArray *)array
{
    CarListModel * carModle;
    for(int i=0;i<array.count;i++)
    {
        carModle=[array objectAtIndex:i];
        [carLocaionPresenter getCarAddrForAcc:carModle.username pw:carModle.password imei:carModle.imei upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultCode==SucceedCode)
                {
                    carModle.addr=(NSString *)data;
                    [self.tableView reloadData];
                }
                else if(resultCode==FailureCode)
                {
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {
                }
            });
            
        }];
    }
}
///没有数据说明事件
- (IBAction)btn_NoDataEvent:(UIButton *)sender {
    
//    SysPresenter * sysPresenter=[SysPresenter new];
    NSString * phone = @"4006555110";
//    [sysPresenter callMobileNum:phone superview:self.view];
    [SysPresenter callPhoneStr:phone withVC:self];
    
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
