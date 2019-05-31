//
//  GarageAddCarVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GarageAddCarVC.h"
#import "TableViewDataSource.h"
#import "GarageAddCarHeardView.h"
#import "GarageAddCarCell.h"
#import "RegularUtils.h"
#import "PopListVC.h"
#import "ParkingManagePresenter.h"
#import "ParkingCarModel.h"
#import "MessageAlert.h"

@interface GarageAddCarVC ()<UITableViewDelegate>
{
    /**
     *  数据源
     */
    TableViewDataSource * dataSource;
    ///table头视图
    GarageAddCarHeardView* headView;
    
    ///车牌数据
    NSMutableArray * carListData;
    
    ///车辆管理处理
    ParkingManagePresenter * parkingPresenter;

    
}


///列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation GarageAddCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getCarNumData];
}
#pragma mark ----------初始化-----------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    self.navigationItem.title= [NSString stringWithFormat:@"%@ %@",self.parkingModle.communityname,self.parkingModle.name];
    [self.tableView registerNib:[UINib nibWithNibName:@"GarageAddCarCell" bundle:nil] forCellReuseIdentifier:@"GarageAddCarCell"];
    carListData=[NSMutableArray new];
    headView=[GarageAddCarHeardView getInstanceView];
    headView.viewController=self;
    headView.frame=CGRectMake(0, 0, self.view.frame.size.width, 220);
    self.tableView.tableHeaderView=headView;
    @WeakObj(self);
    @WeakObj(carListData);
    headView.eventCallBack=^(id _Nullable data,UIView *_Nullable view,NSInteger index){
        if(index==ADDCAR_OK)
        {
            NSDictionary * dic=(NSDictionary *)data;
            ParkingCarModel * carModel=[ParkingCarModel new];
            carModel.card=[dic objectForKey:@"carNum"];
            carModel.remarks=[dic objectForKey:@"remark"];
            ParkingCarModel * cars;
            carModel.isSelect=YES;
            for(int i=0;i<carListDataWeak.count;i++)
            {
                cars=[carListDataWeak objectAtIndex:i];
                if([cars.card isEqualToString:carModel.card])
                {
                    if(![cars.remarks isEqualToString:carModel.remarks])///备注不相同
                    {
                        cars.remarks=carModel.remarks;
                        cars.isChange=YES;
                        carModel.isChange=YES;
                    }
                    cars.isSelect=YES;
                    [selfWeak.tableView reloadData];
                    [selfWeak crateAlertWith:carModel.card];
                    return ;
                }
            }
//            for(int i=0;i<self.carArray.count;i++)
//            {
//                cars=[self.carArray objectAtIndex:i];
//                if([cars.card isEqualToString:carModel.card])
//                {
//                    if(![cars.remarks isEqualToString:carModel.remarks])///备注不相同
//                    {
//                        cars.remarks=carModel.remarks;
//                        cars.isChange=YES;
//                    }
//                }
//            }
            if(carModel.isChange)
            {
                [selfWeak crateAlertWith:carModel.card];
                return;
            }
            carModel.isNews=YES;
            [carListDataWeak insertObject:carModel atIndex:0];
            [selfWeak.tableView reloadData];
            [selfWeak crateAlertWith:carModel.card];

        }
    };
    parkingPresenter=[ParkingManagePresenter new];
   
    
    dataSource=[[TableViewDataSource alloc]initWithItems:carListData cellIdentifier:@"GarageAddCarCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
    }];
    dataSource.isSection=NO;
    self.tableView.dataSource=dataSource;
    [self setExtraCellLineHidden:self.tableView];
    
    self.tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak getCarNumData];
    }];
    
}

- (void)crateAlertWith:(NSString *)string {
    
    MessageAlert *alert = [MessageAlert getInstance];
    
    NSString *str = [NSString stringWithFormat:@"车辆 %@ 已添加到下方列表",string];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:DEFAULT_FONT(16)}];
    //                [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x276DDC) range:NSMakeRange(4,string.length-10)];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:TITLE_TEXT_COLOR range:NSMakeRange(2,string.length + 2)];
    
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(2,string.length + 2)];
    alert.isNull = YES;
    [alert newShowInVC:self withTitle:attributeString andCancelBtnTitle:@"继续添加" andOtherBtnTitle:@"完成"];
    alert.okBtn.backgroundColor = [UIColor whiteColor];
    alert.okBtn.layer.borderColor = TEXT_COLOR.CGColor;
    alert.okBtn.layer.borderWidth = 1.f;
    [alert.okBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    alert.cancelBtn.layer.borderColor = TEXT_COLOR.CGColor;
    alert.cancelBtn.layer.borderWidth = 1.f;
    [alert.cancelBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];

    alert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index==Ok_Type) {
//            NSLog(@"---点击完成");
            [self btnRightEvent:nil];
        }
        if (index == Cancel_Type) {
            //继续添加
            headView.TF_CarNumText.text = @"";
            headView.TF_CarOwnerName.text = @"";
            
        }
        
    };
    
    
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
 *
 *  @param data      <#data description#>
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    GarageAddCarCell * gaCell=(GarageAddCarCell *)cell;
    ParkingCarModel * carModel=(ParkingCarModel *)data;
    gaCell.cellEventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        ParkingCarModel * carModel=[carListData objectAtIndex:indexPath.row];
        carModel.isSelect=!carModel.isSelect;
        [self.tableView reloadData];
    };
    gaCell.lab_CarNum.text=carModel.card;
    gaCell.lab_Name.text=carModel.remarks;
    if(carModel.isSelect==0)
    {
       [gaCell.btn_Select setImage:[UIImage imageNamed:@"复选框_未选中"] forState:UIControlStateNormal];
    }
    else
    {
        [gaCell.btn_Select setImage:[UIImage imageNamed:@"复选框_已选中"] forState:UIControlStateNormal];
    }
    
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
    ParkingCarModel * carModel=[carListData objectAtIndex:indexPath.row];
    carModel.isSelect=!carModel.isSelect;
    [self.tableView reloadData];
    
}

#pragma mark ----------事件处理--------------
///完成
- (IBAction)btnRightEvent:(UIBarButtonItem *)sender {
    
    NSMutableString * carids=[NSMutableString new];
    [carids appendString:@""];
    ParkingCarModel * carModle;
    NSDictionary * dic;
    NSMutableArray * newArray=[NSMutableArray new];
    for(int i=0;i<carListData.count;i++)
    {
        carModle=[carListData objectAtIndex:i];
        if(carModle.isSelect)///选中
        {
            if(carModle.isChange)
            {
                dic=@{@"card":carModle.card,@"remarks":carModle.remarks};
                [newArray addObject:dic];
            }
            else if(carModle.isNews)///新加
            {
                dic=@{@"card":carModle.card,@"remarks":carModle.remarks};
                [newArray addObject:dic];
            }
            else
            {
                [carids appendString:carModle.carid];
                [carids appendString:@","];
            }
        }
    }
//    for(int i=0;i<self.carArray.count;i++)
//    {
//        carModle=[self.carArray objectAtIndex:i];
//        if(carModle.isChange)
//        {
//            dic=@{@"card":carModle.card,@"remarks":carModle.remarks};
//            [newArray addObject:dic];
//        }
//        else if(carModle.isNews)///新加
//        {
//            dic=@{@"card":carModle.card,@"remarks":carModle.remarks};
//            [newArray addObject:dic];
//        }
//        else
//        {
//            [carids appendString:carModle.carid];
//            [carids appendString:@","];
//        }
//    }

    if(carids.length==0&&newArray.count==0)
    {
        [self showToastMsg:@"您没有选择或添加车牌,不能提交" Duration:5];
        return;
    }
    
    if(carids.length>0)
    {
        [carids deleteCharactersInRange:NSMakeRange([carids length]-1, 1)];
    }
    NSString *jsonString=@"";
    if(newArray.count>0)
    {
        NSData * data=[DataController toJSONData:newArray];
        jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    @WeakObj(self);
    [parkingPresenter addCarForParkingareaid:self.parkingModle.ID usercarids:carids addjson:jsonString upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"添加成功" Duration:5.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else if(resultCode==FailureCode)
            {
                [selfWeak showToastMsg:data Duration:5.0];
                
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                
            }
        });

    }];

}



#pragma mark -----------------网络数据-----------------
///获取不在本车位下的车牌
-(void)getCarNumData
{

    [parkingPresenter getNoParkingCarForID:self.parkingModle.ID  upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.pullToRefreshView stopAnimating];
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if(resultCode==SucceedCode)
            {
                
                NSArray * cardata=(NSArray *)data;
                [carListData removeAllObjects];
                [carListData addObjectsFromArray:cardata];
                [self.tableView reloadData];
            }
            else if(resultCode==FailureCode)
            {
//                [selfWeak showToastMsg:data Duration:5.0];
                
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                
            }
        });

    }];
}

-(void)changeCarInfo:(ParkingCarModel *)parking
{
      [parkingPresenter changeCarForUserCarID:parking.parkingcarid card:parking.card remarks:parking.remarks upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                [self showToastMsg:@"修改成功" Duration:5.0];
            }
            else
            {
                [self showToastMsg:@"data" Duration:5.0];
            }
            
        });
        
    }];

}


@end
