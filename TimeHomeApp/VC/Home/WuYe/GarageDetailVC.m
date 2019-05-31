//
//  GarageDetailVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GarageDetailVC.h"
#import "TableViewDataSource.h"
#import "IntelligentGaragePresenter.h"
#import "GarageDetailCell.h"
#import "GarageDetailCarCell.h"
#import "AddCrAlertVC.h"
#import "GarageAddCarVC.h"
#import "ParkingManagePresenter.h"
#import "ParkingCarModel.h"
#import "DateUitls.h"
#import "THMyCarAuthorityViewController.h"
#import "ParkingOwner.h"
#import "DateUitls.h"
#import <AudioToolbox/AudioToolbox.h>
#import "L_GarageDetailTVC.h"
#import "L_GarageTimeSetInfoViewController.h"

@interface GarageDetailVC () <GarageDetailCellDelegate>
{
    //列表数据源
    TableViewDataSource * dataSource;
    //列表数据
    NSMutableArray * arrGarageDetail;
    
    //列表数据
    NSMutableArray * arrCar;
    //车辆管理处理
    ParkingManagePresenter * parkingPresenter;
    //是否锁车
    BOOL isLock;
}

@end

@implementation GarageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self Refresh];
    if([self.parkingModle.type integerValue]!=0) {
        self.navigationItem.rightBarButtonItem=nil;
    }
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:CheWeiGuanLi];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":CheWeiGuanLi}];
}
#pragma mark ----------初始化--------------

#pragma mark - 初始化视图
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    parkingPresenter=[ParkingManagePresenter new];
    arrGarageDetail=[NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"GarageDetailCell" bundle:nil] forCellReuseIdentifier:@"GarageDetailCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"GarageDetailCarCell" bundle:nil] forCellReuseIdentifier:@"GarageDetailCarCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"L_GarageDetailTVC" bundle:nil] forCellReuseIdentifier:@"L_GarageDetailTVC"];
    
    @WeakObj(self);
    
    self.tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak Refresh];
        
    }];
    
    self.tableView.dataSource=self;
    [self setExtraCellLineHidden:self.tableView];
    NSArray * baseArray=[self setBasedata];
    arrCar=[NSMutableArray new];
    [arrGarageDetail addObject:baseArray];
    [arrGarageDetail addObject:arrCar];

}

#pragma mark - ---------下拉刷新事件处理--------------
-(void) Refresh
{
    /**
     *  获取数据
     */
    @WeakObj(self);
    [parkingPresenter getParkingAreaCarForParkingareaid:self.parkingModle.ID upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [selfWeak.tableView.pullToRefreshView stopAnimating];
            
            if (selfWeak.tableView.mj_header.isRefreshing) {
                [selfWeak.tableView.mj_header endRefreshing];
            }
            
            if(resultCode==SucceedCode)
            {
                
                NSArray * cardata=(NSArray *)data;
                [arrCar removeAllObjects];
                [arrCar addObjectsFromArray:cardata];
                ParkingCarModel * carModle;
                for(int i=0;i<arrCar.count;i++)
                {
                    carModle=[arrCar objectAtIndex:i];
                    if ([carModle.card isEqualToString:self.parkingModle.card]) {
                        self.parkingModle.carremarks=carModle.remarks;
                        NSArray * baseArray=[self setBasedata];
                        if(arrGarageDetail.count>0)
                        {
                          [arrGarageDetail replaceObjectAtIndex:0 withObject:baseArray];
                        }
                        break;
                    }
                }
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

#pragma mark - 设置车位基本信息数据
-(NSMutableArray *)setBasedata {
    
    NSMutableArray * array=[NSMutableArray new];
    NSDictionary *dic;
    if([self.parkingModle.type integerValue]==0)
    {
        dic=@{@"title":@"车位类型 :",@"content":@"自有"};
        
    }
    else if([self.parkingModle.type integerValue]==2)
    {
        dic=@{@"title":@"车位类型 :",@"content":@"租用"};
    }
    [array addObject:dic];
    NSString * content=[NSString stringWithFormat:@"%@   %@",([XYString isBlankString:self.parkingModle.card]?@"没有入库车辆":self.parkingModle.card),[XYString isBlankString:self.parkingModle.carremarks]?@"":self.parkingModle.carremarks];
    dic=@{@"title":@"入库车辆 :",@"content":content};
    [array addObject:dic];
    
    
    if([XYString isBlankString:self.parkingModle.card]||self.parkingModle.card.length<7)
    {
        dic=@{@"title":@"入库时间 :",@"content":@"暂无"};
    }
    else
    {
        dic=@{@"title":@"入库时间 :",@"content":(self.parkingModle.carindate==nil?@"": [DateUitls stringFromDateToStr:self.parkingModle.carindate DateFormatter:@"yyyy-MM-dd HH:mm"])};
        
    }
    [array addObject:dic];
    
    
    if([XYString isBlankString:self.parkingModle.ingatename])
    {
        dic=@{@"title":@"入库位置 :",@"content":@"暂无"};
    }
    else
    {
        dic=@{@"title":@"入库位置 :",@"content":self.parkingModle.ingatename};
        
    }
    [array addObject:dic];
    
    if([self.parkingModle.type integerValue]==2)
    {
        NSString *enddata=self.parkingModle.rentenddate;
        if(enddata!=nil)
        {
            NSDate * endD=[DateUitls DateFromString:enddata DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
            enddata= [DateUitls TimeDifference:endD];
        }
        else
        {
            enddata=@"";
        }
        NSString * endd=@"";
        if(![XYString isBlankString:self.parkingModle.rentenddate]&&self.parkingModle.rentenddate.length>10)
        {
            endd=[self.parkingModle.rentenddate substringToIndex:10];
        }
        NSString * date=[NSString stringWithFormat:@"%@   %@",endd,enddata];
        
        
        dic=@{@"title":@"到期时间 :",@"content":date};
        [array addObject:dic];
        if (self.parkingModle.ownername == nil) {
            self.parkingModle.ownername = @"";
        }
         [array insertObject:@{@"title":@"出租人 :",@"content":self.parkingModle.ownername} atIndex:1];
       
    }
    if([self.parkingModle.islock integerValue]==1)
    {
        isLock=YES;
    }
    else
    {
        isLock=NO;
    }
    return array;
}

#pragma mark - 设置隐藏列表分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark ----------关于列表数据及协议处理--------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count=0;
    count=[[arrGarageDetail objectAtIndex:section] count];

    return count;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count=1;
    count=[arrGarageDetail count];

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        GarageDetailCell *cell = (GarageDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"GarageDetailCell" forIndexPath:indexPath];
        [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell);
            make.left.equalTo(cell);
            make.top.equalTo(cell).offset(5);
            make.bottom.equalTo(cell);
        }];
        NSDictionary *dic=[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.delegate=self;
        cell.btn_Lock.imageView.contentMode=UIViewContentModeScaleToFill;
        cell.btn_Lock.hidden=YES;
        cell.lab_Title.text=[dic objectForKey:@"title"];
        cell.lab_Content.text=[dic objectForKey:@"content"];
        
        if(self.parkingModle.type.integerValue==2?indexPath.row==2:indexPath.row==1)
        {
            if([[dic objectForKey:@"content"] isEqualToString:@"没有入库车辆   "])
            {
                cell.btn_Lock.hidden=YES;
            }
            else
            {
                cell.btn_Lock.hidden=NO;
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[dic objectForKey:@"content"]];
                [AttributedStr addAttribute:NSFontAttributeName
                                      value:DEFAULT_BOLDFONT(16)
                                      range:NSMakeRange(0, 8)];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:TITLE_TEXT_COLOR
                                      range:NSMakeRange(0, 8)];
                
                cell.lab_Content.attributedText=AttributedStr;
            }
            
            if(isLock)
            {
                [cell.btn_Lock setImage:[UIImage imageNamed:@"智能车库_已锁定1"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btn_Lock setImage:[UIImage imageNamed:@"智能车库_已解锁1"] forState:UIControlStateNormal];
            }
        }
        
        return cell;
        
    }else {
        
        L_GarageDetailTVC *cell = (L_GarageDetailTVC *)[tableView dequeueReusableCellWithIdentifier:@"L_GarageDetailTVC"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        ParkingCarModel * carModle=[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.carModel = carModle;

        if(![carModle.position isEqualToString:@"0"]) {
            
            cell.isInLabel.text = @"已入库";
            cell.deleteButtonLayoutConstraint.constant = 0;
            cell.timeLockLayoutConstraint.constant = 75.f;
            cell.motifyLayoutConstraint.constant = 0;
            
            if (carModle.lockstate.integerValue == 0) {
                
                [cell.timeLock_Button setTitle:@"定时锁车" forState:UIControlStateNormal];
                [cell.timeLock_Button setBackgroundColor:UIColorFromRGB(0xF69D0E)];
                
            }else if (carModle.lockstate.integerValue == 1) {
                
                [cell.timeLock_Button setTitle:@"关闭定时" forState:UIControlStateNormal];
                [cell.timeLock_Button setBackgroundColor:UIColorFromRGB(0xA7A7A7)];

            }

        }else {
            cell.isInLabel.text = @"未入库";
            
            cell.deleteButtonLayoutConstraint.constant = 56;
            cell.timeLockLayoutConstraint.constant = 0;
            cell.motifyLayoutConstraint.constant = 56;
            
            if ([self.limitapp isEqualToString:@"1"]) {
                
                cell.deleteButtonLayoutConstraint.constant = 0;
                cell.timeLockLayoutConstraint.constant = 0;
                cell.motifyLayoutConstraint.constant = 0;
            }

        }
        
        cell.buttonsCallBack = ^(NSInteger buttonIndex){
            
            //1.删除 2.修改 3.定时锁车、关闭定时
            if (buttonIndex == 1) {
                ///删除
                CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
                ParkingCarModel * carModle=(ParkingCarModel *)[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
                if([carModle.card isEqualToString:self.parkingModle.card]) {
                    return ;
                }
                [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
    
                     if(index==ALERT_OK) {
    
                         [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    
                         @WeakObj(self);
                         [parkingPresenter removeCarByParkingForParkingCarid:carModle.parkingcarid upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                 if(resultCode==SucceedCode)
                                 {
                                     [[arrGarageDetail objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.item];
                                     [selfWeak.tableView reloadData];
                                     [selfWeak showToastMsg:@"删除成功" Duration:3.0];
                                 }
                                 else
                                 {
                                     [selfWeak showToastMsg:data Duration:3.0];
                                 }
    
                             });
    
                         }];
    
                     }
    
                 }];
    
                NSString *tmp=[NSString stringWithFormat:@"是否删除车牌 %@?",carModle.card];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tmp];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:UIColorFromRGB(0x5F78B1)
                                      range:NSMakeRange(tmp.length-8, 7)];
                [alertVc ShowAlert:self Title:@"删除车牌" AttributeMsg:AttributedStr oneBtn:@"取消" otherBtn:@"确定"];
                
            }else if (buttonIndex == 2) {
                //修改
                //修改车牌
                ParkingCarModel * carModle=(ParkingCarModel *)[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
                AddCrAlertVC * addCar=[AddCrAlertVC sharedAddCrAlertVC];
            
                if([carModle.card isEqualToString:self.parkingModle.card]) {
                    [self showToastMsg:@"车辆已入库,不能进行修改!" Duration:3];
                    return;
                }
                @WeakObj(self);
                [addCar ShowAlert:self carNum:carModle.card remarks:carModle.remarks eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    if(index==ADDCAR_OK) {
            
                        NSDictionary *dic=(NSDictionary *)data;//@{@"carNum":self.TF_CarNumText.text,@"remark":self.TF_CarOwnerName.text};
                        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
                        [parkingPresenter changeCarForUserCarID:carModle.parkingcarid card:[dic objectForKey:@"carNum"] remarks:[dic objectForKey:@"remark"] upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                if(resultCode==SucceedCode) {
                                    carModle.card=[dic objectForKey:@"carNum"];
                                    carModle.remarks=[dic objectForKey:@"remark"];
                                    [selfWeak.tableView reloadData];
                                    [selfWeak showToastMsg:@"修改成功" Duration:3.0];
                                }else {
                                    [selfWeak showToastMsg:data Duration:3.0];
                                }
                                
                            });
            
                        }];
            
                    }
                    
                }];
                
            }else if (buttonIndex == 3) {
                
                L_GarageTimeSetInfoViewController *timeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_GarageTimeSetInfoViewController"];
                ParkingCarModel * carModle=[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                timeVC.carModel = carModle;
                timeVC.lockstate = carModle.lockstate;
                [self.navigationController pushViewController:timeVC animated:YES];
                
            }
            
        };

        return cell;

    }
    

    return nil;
}

#pragma mark - 设置列表高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 60;
    }
    return 50;
}

#pragma mark - 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0)
        return 0;
    return 65;
}

#pragma mark - 设置headerView 视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView * headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
     UIButton * btn_title;
     UIButton * btn_AddCar;
    if (!headerView) {
        headerView=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
//        headerView.backgroundColor=[UIColor clearColor];
        headerView.contentView.backgroundColor=[UIColor clearColor];
        headerView.backgroundView=[[UIView alloc]init];
        btn_title=[[UIButton alloc]init];
        btn_title.backgroundColor=UIColorFromRGB(0xffffff);
        btn_title.titleLabel.font=DEFAULT_SYSTEM_FONT(16);
//        btn_title.titleLabel.textColor=UIColorFromRGB(0x595353);
        [btn_title setTitleColor:UIColorFromRGB(0x595353) forState:UIControlStateNormal];
        btn_title.tag=100;
        [headerView.contentView addSubview:btn_title];
        [btn_title addTarget:self action:@selector(btn_AddCarEvent:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.limitapp isEqualToString:@"1"]) {
            
            btn_title.userInteractionEnabled = NO;
        }else{
            
            btn_title.userInteractionEnabled = YES;
        }
        
        [btn_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView.contentView);
            make.top.equalTo(headerView.contentView).offset(10);
            make.bottom.equalTo(headerView.contentView).offset(-5);
            make.left.equalTo(headerView.contentView);
        }];

        
        btn_AddCar=[[UIButton alloc]init];
        btn_AddCar.tag=101;
        btn_AddCar.backgroundColor=UIColorFromRGB(0xffffff);
        
        if ([self.limitapp isEqualToString:@"1"]) {
            
            btn_AddCar.hidden = YES;
        }else{
            
            btn_AddCar.hidden = NO;
        }
    btn_AddCar.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [btn_AddCar setImage:[UIImage imageNamed:@"智能车库_未入库车辆_添加车牌"] forState:UIControlStateNormal];
        [btn_AddCar addTarget:self action:@selector(btn_AddCarEvent:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.contentView addSubview:btn_AddCar];
        [btn_AddCar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView.contentView).offset(-20);
            make.top.equalTo(headerView.contentView).offset(10);
            make.bottom.equalTo(headerView.contentView).offset(-5);
            make.width.equalTo(@(60));
        }];
        
    }
    btn_title=[headerView.contentView viewWithTag:100];
    btn_AddCar=[headerView.contentView viewWithTag:101];
    NSString * title=@"";
    NSString * imgname=@"智能车库_车位详情_关联车牌";
    if (section==0) {
      title=@"";
      imgname=@"";
        
    }else if (section==1) {
        title=@"关联车牌";
        imgname=@"智能车库_车位详情_关联车牌";
    }
    [btn_title setTitle:title forState:UIControlStateNormal];
    [btn_title setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];
    [btn_title setTitleEdgeInsets:UIEdgeInsetsMake(0,5,
                                                   0.0,
                                                   0.0)];
    
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if(indexPath.section==0)
    {
        return;
    }

//    L_GarageTimeSetInfoViewController *timeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_GarageTimeSetInfoViewController"];
//    ParkingCarModel * carModle=[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    timeVC.carModel = carModle;
//    timeVC.lockstate = carModle.lockstate;
//    [self.navigationController pushViewController:timeVC animated:YES];
    
    ////修改车牌
//    ParkingCarModel * carModle=(ParkingCarModel *)[[arrGarageDetail objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
//    AddCrAlertVC * addCar=[AddCrAlertVC sharedAddCrAlertVC];
//   
//    if([carModle.card isEqualToString:self.parkingModle.card]) {
//        [self showToastMsg:@"车辆已入库,不能进行修改!" Duration:3];
//        return;
//    }
//    @WeakObj(self);
//    [addCar ShowAlert:self carNum:carModle.card remarks:carModle.remarks eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
//        if(index==ADDCAR_OK) {
//            
//            NSDictionary *dic=(NSDictionary *)data;//@{@"carNum":self.TF_CarNumText.text,@"remark":self.TF_CarOwnerName.text};
//            [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
//            [parkingPresenter changeCarForUserCarID:carModle.parkingcarid card:[dic objectForKey:@"carNum"] remarks:[dic objectForKey:@"remark"] upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
//                    if(resultCode==SucceedCode) {
//                        carModle.card=[dic objectForKey:@"carNum"];
//                        carModle.remarks=[dic objectForKey:@"remark"];
//                        [selfWeak.tableView reloadData];
//                        [selfWeak showToastMsg:@"修改成功" Duration:3.0];
//                    }else {
//                        [selfWeak showToastMsg:data Duration:3.0];
//                    }
//                    
//                });
//
//            }];
//
//        }
//    }];

}

#pragma mark - 添加车牌事件
-(void)btn_AddCarEvent:(UIButton *) sender {
    
    
    @WeakObj(self);
    [ParkingManagePresenter getIsAddCard:self.parkingModle.ID :^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if (resultCode == SucceedCode) {
                
                
                GarageAddCarVC * garageAddCarVC=[selfWeak.storyboard instantiateViewControllerWithIdentifier:@"GarageAddCarVC"];
                garageAddCarVC.parkingModle=selfWeak.parkingModle;
                garageAddCarVC.carArray=arrCar;
                [selfWeak.navigationController pushViewController:garageAddCarVC animated:YES];

            }else
            {
                [selfWeak showToastMsg:data Duration:2.0f];
            }
        });
    }];
    
    
  }

#pragma mark - 锁车解锁声音
- (void)playSoundForLockCarOrNot {
    [YYPlaySound playSoundWithResourceName:@"锁车解锁提示音" ofType:@"wav"];
}

#pragma mark - 锁车事件回调
-(void)lockCarClikeWithIndexPath:(NSIndexPath *)indexPath {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    NSString* isclock;
    if(isLock)
    {
        isclock=@"0";
    }
    else
    {
        isclock=@"1";
    }
    @WeakObj(self);
    [parkingPresenter lockcarForParkingcarid:self.parkingModle.parkingcarid state:isclock upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                isLock=[isclock integerValue]==0?NO:YES;
                if(isLock)
                {
                    [selfWeak showToastMsg:@"车已锁定" Duration:3.0];
                }
                else
                {
                    [selfWeak showToastMsg:@"车已解锁" Duration:3.0];
                }
                [selfWeak playSoundForLockCarOrNot];
                [selfWeak.tableView reloadData];
                
            }else {
                [selfWeak showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
}

#pragma mark - 出租
- (IBAction)NavRightEvent:(UIBarButtonItem *)sender {
    //出租
    THMyCarAuthorityViewController *carVC = [[THMyCarAuthorityViewController alloc]init];
    ParkingOwner * parking=[ParkingOwner new];
    parking.theID=self.parkingModle.ID;
    parking.communityname=self.parkingModle.communityname;
    parking.name=self.parkingModle.name;
    parking.expiretime=self.parkingModle.expiretime;
    parking.state=self.parkingModle.state;
    parking.carid=self.parkingModle.carid;
    parking.card=self.parkingModle.card;
    parking.carremarks=self.parkingModle.carremarks;
    parking.type=self.parkingModle.type;
    parking.userlist=nil;
    carVC.owner =parking ;
    carVC.isFromParking=YES;
    [self.navigationController pushViewController:carVC animated:YES];
}


@end
