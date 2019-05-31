//
//  IntelligentGarageVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "IntelligentGarageVC.h"
#import "IntelligentGarageHearView.h"
#import "UIButtonImageWithLable.h"
#import "GarageCarCell.h"
#import "GarageCell.h"
#import "IntelligentGaragePresenter.h"
#import "GarageDetailVC.h"
#import "ParkingManagePresenter.h"
#import "AddCrAlertVC.h"
#import "HouseFunctionVC.h"

#import "selectCarViewController.h"
#import "BluetoothRacklViewController.h"

#import "THMyCarAuthorityListVC.h"
#import <AudioToolbox/AudioToolbox.h>

#import "WebViewVC.h"

@interface IntelligentGarageVC () <GarageCellDelegate>
{
    /**
    *  车位数据
    */
    NSMutableArray * arrGarages;
    ///车位数据
    NSMutableArray * parkingArray;
    ///车牌数据
    NSMutableArray * carArray;
    ///车辆管理处理
    ParkingManagePresenter * parkingPresenter;
    //车辆选择按钮
    UIButton *rackTail;
    //判断是否允许修改车牌
    NSString *limitapp;
    
    UIButton *show;
}

@end

@implementation IntelligentGarageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Refresh];
//    [TalkingData trackPageBegin:@"cheweiguanli"];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:CheWeiGuanLi];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"cheweiguanli"];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":CheWeiGuanLi}];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
#pragma mark - ---------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    
    [self.selctBt setImage:[UIImage imageNamed:@"智能车库-开闸按钮-图标"] forState:UIControlStateHighlighted];    
    arrGarages=[NSMutableArray new];
    parkingArray=[NSMutableArray new];
    carArray=[NSMutableArray new];
    
    [arrGarages addObject:parkingArray];
    [arrGarages addObject:carArray];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    parkingPresenter=[[ParkingManagePresenter alloc]init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GarageCell" bundle:nil]
          forCellWithReuseIdentifier:@"GarageCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GarageCarCell" bundle:nil]
          forCellWithReuseIdentifier:@"GarageCarCell"];
    
    @WeakObj(self);
    self.collectionView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak Refresh];
        
    }];
    
    show = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 30 - 20 - (44+statuBar_Height), 80, 30)];
    
    show.backgroundColor = [UIColor clearColor];
    [show setTitle:@"使用说明" forState:UIControlStateNormal];
    show.titleLabel.font = [UIFont systemFontOfSize:13];
    [show setTitleColor:UIColorFromRGB(0xC11819) forState:UIControlStateNormal];
    [show setImage:[UIImage imageNamed:@"优化-使用说明"] forState:UIControlStateNormal];
    
    [show addTarget: self action:@selector(goToUserInfo:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 手动开闸

- (IBAction)selectCar:(id)sender {
    
    selectCarViewController *selectCar = [[selectCarViewController alloc]init];
    
    [selectCar getNew:arrGarages];
    [self.navigationController pushViewController:selectCar animated:YES];
}

#pragma mark - ---------下拉刷新事件处理--------------
-(void) Refresh
{
    /**
     *  获取数据
     */
    @WeakObj(self);
    [parkingPresenter getUserParkingareaForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hiddenNothingnessView];
            
            if(resultCode==SucceedCode)
            {
                
                NSDictionary * parking=(NSDictionary *)data;
                
                limitapp = [NSString stringWithFormat:@"%@",[parking objectForKey:@"limitapp"]];
                
                NSArray * citylist=[parking objectForKey:@"list"];
                NSArray * listdata=[ParkingModel mj_objectArrayWithKeyValuesArray:citylist];
                
                [parkingArray removeAllObjects];
                [parkingArray addObjectsFromArray:listdata];
                [selfWeak.collectionView reloadData];
                [parkingPresenter getOutCarForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        [selfWeak.collectionView.pullToRefreshView stopAnimating];
                        
                        if (selfWeak.collectionView.mj_header.isRefreshing) {
                            [selfWeak.collectionView.mj_header endRefreshing];
                        }
                        
                        if(resultCode==SucceedCode)
                        {
                            NSArray * parking=(NSArray *)data;
                            [carArray removeAllObjects];
                            [carArray addObjectsFromArray:parking];
                            [selfWeak.collectionView reloadData];
                        }
                        else
                        {
                            [carArray removeAllObjects];
                            [selfWeak.collectionView reloadData];
//                            [selfWeak showToastMsg:data Duration:5.0];
                            [selfWeak.collectionView reloadData];
                        }
                        
                    });

                }];
                
            }
            else if(resultCode==FailureCode)
            {
//                [selfWeak.collectionView.pullToRefreshView stopAnimating];
                
                if (selfWeak.collectionView.mj_header.isRefreshing) {
                    [selfWeak.collectionView.mj_header endRefreshing];
                }
                
                if(data==nil||![data isKindOfClass:[NSDictionary class]])
                {
                    return ;
                }
                
                NSDictionary *dicJson=(NSDictionary *)data;
                NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
                //NSString * errmsg=[dicJson objectForKey:@"errmsg"];
                
                if(errcode==99999)
                {
                    [self showNothingnessViewWithType:NoContentTypeCarManager Msg:@"本小区目前没有您可管理的车位" eventCallBack:nil];
                    
                    [self.view addSubview:show];

                    return ;
                }
                
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                if (selfWeak.collectionView.mj_header.isRefreshing) {
                    [selfWeak.collectionView.mj_header endRefreshing];
                }

                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];

                [self.view addSubview:show];
            }
            
        });

    }];
}

#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    view description
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [[arrGarages objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [arrGarages count];
}


/**
 *  HeadView处理
 *
 *  @param collectionView collectionView description
 *  @param kind           kind description
 *  @param indexPath      indexPath description
 *
 *  @return return value description
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind==UICollectionElementKindSectionHeader) {
        IntelligentGarageHearView * headView;
        headView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IntelligentGarageHearView" forIndexPath:indexPath];
        if(indexPath.section==0)
        {
            headView.centerLayout.constant = - (SCREEN_WIDTH - 20) / 2 + 130 / 2 + 10;
            [headView.btn_MyGarages setTitle:@"我管理的车位" forState:UIControlStateNormal];
            [headView.btn_MyGarages setImage:[UIImage imageNamed:@"智能车库_我管理的车位"] forState:UIControlStateNormal];
            headView.btn_userInfo.hidden = NO;
            [headView.btn_userInfo addTarget:self action:@selector(goToUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            headView.centerLayout.constant = 0;
            [headView.btn_MyGarages setTitle:@"未入库车辆" forState:UIControlStateNormal];
            [headView.btn_MyGarages setImage:[UIImage imageNamed:@"智能车库_我管理的车牌"] forState:UIControlStateNormal];
            headView.btn_userInfo.hidden = YES;
            if(carArray.count==0)
            {
                UILabel * label=[UILabel new];
                [headView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(headView.btn_MyGarages.mas_bottom).offset(20);
                    make.left.equalTo(headView.btn_MyGarages);
                    make.right.equalTo(headView.btn_MyGarages);
                    make.height.equalTo(@40);
                }];
                headView.frame=CGRectMake(headView.frame.origin.x, headView.frame.origin.y, headView.frame.size.width, 90);
                label.text=@"暂无";
                label.textColor=UIColorFromRGB(0x8e8e8e);
                label.font=DEFAULT_FONT(16);
                label.textAlignment=NSTextAlignmentCenter;
            }
            
        }
      return headView;
    }
    return nil;
}



/**
 *  处理每项视图数据
 *
 *  @param collectionView collectionView description
 *  @param indexPath      indexPath description
 *
 *  @return return value cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        GarageCell * garageCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GarageCell" forIndexPath:indexPath];
        garageCell.indexPath=indexPath;
        garageCell.delegate=self;
        [garageCell.btn_CarState.imageView setContentMode:UIViewContentModeScaleAspectFit];
        ParkingModel * parkingModel=(ParkingModel *)[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
        
        [garageCell.btn_CarNum setTitle:parkingModel.card forState:UIControlStateNormal];
//        garageCell.lab_GarageName.text=[NSString stringWithFormat:@"%@ %@",parkingModel.communityname,parkingModel.name];
         garageCell.lab_GarageName.text=parkingModel.name;
        if([parkingModel.state integerValue]==1)
        {
            if([parkingModel.islock integerValue]==1)
            {
                [garageCell.btn_CarState setImage:[UIImage imageNamed:@"智能车库_车辆状态_已锁定"] forState:UIControlStateNormal];
                [garageCell.btn_Lock setImage:[UIImage imageNamed:@"智能车库_已锁定"] forState:UIControlStateNormal];
                [garageCell.btn_CarNum setImage:[UIImage imageNamed:@"智能车库_车牌号_已锁定"] forState:UIControlStateNormal];
            }
            else
            {
                [garageCell.btn_CarState setImage:[UIImage imageNamed:@"智能车库_车辆状态_已解锁"] forState:UIControlStateNormal];
                [garageCell.btn_Lock setImage:[UIImage imageNamed:@"智能车库_已解锁"] forState:UIControlStateNormal];
                [garageCell.btn_CarNum setImage:[UIImage imageNamed:@"智能车库_车牌号_已解锁"] forState:UIControlStateNormal];
            }
        }
        else
        {
            [garageCell.btn_CarState setImage:[UIImage imageNamed:@"智能车库_车辆状态_已解锁"] forState:UIControlStateNormal];
            [garageCell.btn_CarNum setImage:[UIImage imageNamed:@"智能车库_车牌号_已解锁"] forState:UIControlStateNormal];
            
            [garageCell.btn_Lock setHidden:YES];
        }
        if(parkingModel.card==nil||parkingModel.card.length==0)
        {
            [garageCell.btn_CarNum setTitle:@"空"forState:UIControlStateNormal];
            [garageCell.btn_Lock setHidden:YES];
            [garageCell.btn_CarState setImage:[UIImage imageNamed:@"智能车库_车辆状态_空"] forState:UIControlStateNormal];
            [garageCell.btn_CarNum setImage:[UIImage imageNamed:@"智能车库_车牌号_联系车主"] forState:UIControlStateNormal];
        }
        else
        {
            [garageCell.btn_Lock setHidden:NO];
        }
        
        return garageCell;
    }
    else if(indexPath.section==1)
    {
        GarageCarCell * carCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GarageCarCell" forIndexPath:indexPath];
        carCell.indexPath=indexPath;
        carCell.delegate=self;
        ParkingCarModel * carModle=(ParkingCarModel *)[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
        carCell.lab_CarNum.text=carModle.card;
        carCell.lab_Remarks.text=carModle.remarks;
        carCell.img_InitIcon.hidden=YES;
        
        if ([limitapp isEqualToString:@"1"]) {
            
            carCell.btn_DelCar.hidden = YES;
        }else{
            
            carCell.btn_DelCar.hidden = NO;
        }
        
        if([carModle.isinit integerValue]==1)
        {
            carCell.img_InitIcon.hidden=NO;
        }
        
       return carCell;
    }
    return nil;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake((SCREEN_WIDTH-10)/3, WIDTH_SCALE(1/2.3));
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH-10, 50);
    }
    
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            ParkingModel * parkingModel=(ParkingModel *)[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
            GarageDetailVC *detailvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageDetailVC"];
            detailvc.title= [NSString stringWithFormat:@"%@ %@",parkingModel.communityname,parkingModel.name];
            detailvc.parkingModle=parkingModel;
            detailvc.limitapp = limitapp;
            [self.navigationController pushViewController:detailvc animated:YES];
        }
            break;
        case 1://车牌管理
        {
            ////修改车牌
            
            if ([limitapp isEqualToString:@"1"]) {
                
                return;
            }
            
            ParkingCarModel * carModle=(ParkingCarModel *)[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
            AddCrAlertVC * addCar=[AddCrAlertVC sharedAddCrAlertVC];
            if([XYString isBlankString:carModle.carid]){

                return;
            }
            if([XYString isBlankString:carModle.remarks])
            {
                carModle.remarks=@"";
            }
            @WeakObj(self);
            [addCar ShowAlert:self carNum:carModle.card remarks:carModle.remarks eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                if(index==ADDCAR_OK)
                {
                    NSDictionary *dic=(NSDictionary *)data;//@{@"carNum":self.TF_CarNumText.text,@"remark":self.TF_CarOwnerName.text};
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
                    
                    [parkingPresenter changeallcarForUserCarID:carModle.carid card:[dic objectForKey:@"carNum"] remarks:[dic objectForKey:@"remark"] upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            if(resultCode==SucceedCode)
                            {
                                carModle.card=[dic objectForKey:@"carNum"];
                                carModle.remarks=[dic objectForKey:@"remark"];
                                carModle.carid = [NSString stringWithFormat:@"%@",data];
                                [selfWeak.collectionView reloadData];
                                [selfWeak showToastMsg:@"修改成功" Duration:5.0];
                            }
                            else
                            {
                                [selfWeak showToastMsg:data Duration:5.0];
                            }
                            
                        });

                    }];
                }
            }];

        }
            break;
            
        default:
            break;
    }
}
#pragma mark - -------------cell中点击事件实现------------
/**
 *  进入详情
 *
 *  @param indexPath indexPath description
 */
-(void)toGarageDetailWithIndexPath:(NSIndexPath *)indexPath
{
    
    ParkingModel * parkingModel=(ParkingModel *)[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    GarageDetailVC *detailvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageDetailVC"];
    detailvc.title= [NSString stringWithFormat:@"%@ %@",parkingModel.communityname,parkingModel.name];
    detailvc.parkingModle=parkingModel;
    detailvc.limitapp = limitapp;
    [self.navigationController pushViewController:detailvc animated:YES];
}
/**
 *  锁车解锁声音
 */
- (void)playSoundForLockCarOrNot {
    [YYPlaySound playSoundWithResourceName:@"锁车解锁提示音" ofType:@"wav"];
}

/**
 *  锁车或打电话给车主
 *
 *  @param indexPath indexPath description
 */
-(void)lockOrCallPhoneCarWithIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel * parkingModel=[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    NSString *isclock;
    if([parkingModel.islock integerValue]==1)
    {
        isclock=@"0";
    }
    else
    {
        isclock=@"1";
    }
    @WeakObj(self);
    [parkingPresenter lockcarForParkingcarid:parkingModel.parkingcarid state:isclock upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                parkingModel.islock=isclock;
                if([parkingModel.islock integerValue]==1)
                {
                    [selfWeak showToastMsg:@"车已锁定" Duration:0.2];
                }
                else
                {
                    [selfWeak showToastMsg:@"车已解锁" Duration:0.2];
                }
                [selfWeak playSoundForLockCarOrNot];
                
//                NSMutableArray *arr = [arrGarages objectAtIndex:indexPath.section];
//                [arr replaceObjectAtIndex:indexPath.row withObject:parkingModel];
//                [arrGarages replaceObjectAtIndex:indexPath.section withObject:arr];

                [selfWeak.collectionView reloadData];
            }
            else
            {
                [selfWeak showToastMsg:data Duration:5.0];
            }
            
        });

    }];
}
/**
 *  删车牌
 *
 *  @param indexPath indexPath description
 */
-(void)delCarNumWithIndexPath:(NSIndexPath *)indexPath
{
    CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
    ParkingCarModel * carModle=(ParkingCarModel *)[[arrGarages objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
     {
         if(index==ALERT_OK)
         {
             [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
             
             @WeakObj(self);
             [parkingPresenter removeCarByUserForCarid:carModle.carid upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                     if(resultCode==SucceedCode)
                     {
                         [[arrGarages objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.item];
                         [selfWeak.collectionView reloadData];
                         [selfWeak showToastMsg:@"删除成功" Duration:5.0];
                     }
                     else
                     {
                         [selfWeak showToastMsg:data Duration:5.0];
                     }
                     
                 });
                 
             }];

         }
         
    }];
    ;
//    [alertVc ShowAlert:self Title:@"删除车牌" Msg:[NSString stringWithFormat:@"是否删除车牌 %@?",carModle.card] oneBtn:@"取消" otherBtn:@"确定"];
    NSString *tmp=[NSString stringWithFormat:@"删除车牌 %@ ,并解除其与所有车位的关联",carModle.card];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tmp];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x000000)
                          range:NSMakeRange(5, 7)];
    [alertVc ShowAlert:self Title:@"删除车牌" AttributeMsg:AttributedStr oneBtn:@"取消" otherBtn:@"确定"];
    
}

///右边事件 车位授权
- (IBAction)NavLeftBtnEvent:(UIBarButtonItem *)sender {
    
    //车位权限
    THMyCarAuthorityListVC *houseVC = [[THMyCarAuthorityListVC alloc]init];//车位权限
    [self.navigationController pushViewController:houseVC animated:YES];
 
}

-(void)goToUserInfo:(id)sender{
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = [NSString stringWithFormat:@"%@/20170906/parkingManagement.html",kH5_SEVER_URL];
    webVc.title=@"车位管理使用说明";
    [self.navigationController pushViewController:webVc animated:YES];
}

@end
