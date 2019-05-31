//
//  selectCarViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 16/9/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "selectCarViewController.h"
#import "ParkingManagePresenter.h"
#import "headerCollectionReusableView.h"
#import "selectCarCollectionViewCell.h"

#import "CommunityManagerPresenters.h"
#import "UserUnitKeyModel.h"
#import "BluetoothRacklViewController.h"//测试

#define UNIT self.view.frame.size.width / 720

@interface selectCarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    UICollectionView *collect_;
    
    /**
     *  车位数据
     */
    NSArray * arrGarages;
    ///车牌数据
    NSMutableArray * carArray;
    
    NSString *selectNo;//选择标示
    
    ParkingModel *carMod;//车辆
    
    UIView * redView1;
    
    UIView * redView2;
    
    UIImageView *face1;
    
    UIImageView *face2;
    
    UIImageView *outImg;
    
    UIImageView *inImg;
    
    UIButton *define;
    
    NSString *outInStr;
    
    UIView *alertBack;
    
    UIView *alertView;
    
    UIView *alertView1;
    
    THIndicatorVC * indicator;
    
}

@end

@implementation selectCarViewController

#pragma mark - extend method

-(void)getNew:(NSMutableArray *)dataArr{
    
    arrGarages = dataArr;
}

- (void)createAlertShow {
    
    alertBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    alertBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    alertBack.userInteractionEnabled = YES;
    alertBack.hidden = YES;
    
    [self.tabBarController.view addSubview:alertBack];
    
    //UITapGestureRecognizer *close = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClose:)];
    //[alertBack addGestureRecognizer:close];
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - UNIT * 560) / 2, 0, UNIT * 560, UNIT * 240)];
    alertView.backgroundColor = UIColorFromRGB(0x565758);
    alertView.alpha = 1.0;
    alertView.center = CGPointMake(alertView.center.x, self.view.frame.size.height / 2);
    
    alertView.hidden = YES;
    
    [alertBack addSubview:alertView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(UNIT * 55, alertView.frame.size.height - UNIT * 60, alertView.frame.size.width - 110 * UNIT, 1)];
    line1.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [alertView addSubview:line1];
    
    UILabel *alertLal = [[UILabel alloc]initWithFrame:CGRectMake(UNIT * 50, 0, 20, 20)];
    alertLal.backgroundColor = [UIColor clearColor];
    alertLal.text = @"车位已满";
    alertLal.font = [UIFont systemFontOfSize:15];
    alertLal.textColor = [UIColor whiteColor];
    [alertLal setNumberOfLines:1];
    [alertLal sizeToFit];
    alertLal.center = CGPointMake(alertLal.center.x, line1.frame.origin.y / 2);
    [alertView addSubview:alertLal];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"车辆选择-车辆锁定-弹窗图标"]];
    img.center = CGPointMake(alertLal.frame.origin.x + alertLal.frame.size.width + img.frame.size.width / 2 + 10, alertLal.center.y);
    [alertView addSubview:img];
    
    
    alertView1 = [[UIView alloc]initWithFrame:alertView.frame];
    alertView1.backgroundColor = UIColorFromRGB(0x565758);
    alertView1.alpha = 1.0;
    alertView1.center = CGPointMake(alertView.center.x, self.view.frame.size.height / 2);
    
    alertView1.hidden = YES;
    
    [alertBack addSubview:alertView1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:line1.frame];
    line2.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [alertView1 addSubview:line2];
    
    UILabel *alertLal1 = [[UILabel alloc]initWithFrame:CGRectMake(UNIT * 50, 0, 20, 20)];
    alertLal1.backgroundColor = [UIColor clearColor];
    alertLal1.text = @"车辆已锁定，请先解锁";
    alertLal1.font = [UIFont systemFontOfSize:15];
    alertLal1.textColor = [UIColor whiteColor];
    [alertLal1 setNumberOfLines:1];
    [alertLal1 sizeToFit];
    alertLal1.center = CGPointMake(alertLal1.center.x, line2.frame.origin.y / 2);
    [alertView1 addSubview:alertLal1];
    
    UIImageView *img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"车辆选择-车位已满-弹窗图标"]];
    img1.center = CGPointMake(alertLal1.frame.origin.x + alertLal1.frame.size.width + img1.frame.size.width / 2 + 10, alertLal1.center.y);
    [alertView1 addSubview:img1];
}

-(void)configUI{
    
    self.title = @"车辆选择";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    define = [[UIButton alloc]initWithFrame:CGRectMake( 40, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 - 40 - 20, self.view.frame.size.width - 40 * 2, 40)];
    define.backgroundColor = [UIColor clearColor];
    [define setTitle:@"确定" forState:UIControlStateNormal];
    [define setTitleColor:UIColorFromRGB(0x4e4a4a) forState:UIControlStateNormal];
    [define.layer setBorderWidth:1];
    [define.layer setBorderColor:CGColorRetain(UIColorFromRGB(0x4e4a4a).CGColor)];
    define.userInteractionEnabled = NO;
    [define addTarget:self action:@selector(define:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:define];
    
    UIView *outInView = [[UIView alloc]initWithFrame:CGRectMake(0, define.frame.origin.y - UNIT * 320, self.view.frame.size.width, UNIT * 320)];
    outInView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:outInView];
    
    UIView *outInTitleView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, outInView.frame.size.width - 20, UNIT * 100)];
    outInTitleView.backgroundColor = [UIColor whiteColor];
    [outInView addSubview:outInTitleView];
    
    UIButton *outinTitle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, outInTitleView.frame.size.width, outInTitleView.frame.size.height)];
    
    [outinTitle setTitle:@"车辆事件" forState:UIControlStateNormal];
    [outinTitle setTitleColor:UIColorFromRGB(0x9F1E1F) forState:UIControlStateNormal];
    outinTitle.titleLabel.font = [UIFont systemFontOfSize:15];
    [outinTitle setImage:[UIImage imageNamed:@"出入库状态图标"] forState:UIControlStateNormal];
    outinTitle.userInteractionEnabled = NO;
    
    [outInTitleView addSubview:outinTitle];
    
    UIView *outView = [[UIImageView alloc]initWithFrame:CGRectMake(10, outInTitleView.frame.origin.y + outInTitleView.frame.size.height + 5, (outInTitleView.frame.size.width - 5 ) / 2, outInView.frame.size.height -  outInTitleView.frame.origin.y - outInTitleView.frame.size.height - 15)];
    outView.backgroundColor = [UIColor whiteColor];
    outView.userInteractionEnabled = YES;
    [outInView addSubview:outView];
    
    redView1 = [[UIView alloc]initWithFrame:CGRectMake(10, UNIT * 20, outView.frame.size.width - 20, UNIT * 90)];
    redView1.backgroundColor = [UIColor clearColor];
    [redView1.layer setBorderWidth:1];
    [redView1.layer setBorderColor:CGColorRetain(UIColorFromRGB(0x9F1E1F).CGColor)];
    redView1.alpha = 0;
    [outView addSubview:redView1];
    
    face1 = [[UIImageView alloc]initWithFrame:CGRectMake(redView1.frame.origin.x + UNIT * 25, redView1.frame.origin.y + UNIT * 30, UNIT * 40, UNIT * 40)];
    face1.image = [UIImage imageNamed:@"车辆选择-未选中"];
    [outView addSubview:face1];
    
    outImg = [[UIImageView alloc]initWithFrame:CGRectMake(redView1.frame.size.width + redView1.frame.origin.x - UNIT * 50 * 379 / 108 - UNIT * 25, redView1.frame.origin.y + UNIT * 20, UNIT * 50 * 379 / 108, UNIT * 50)];
    outImg.image = [UIImage imageNamed:@"车辆选择-车辆出库图标"];
    [outView addSubview:outImg];
    
    UILabel *outTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, redView1.frame.origin.y + redView1.frame.size.height, outView.frame.size.width, outView.frame.size.height - redView1.frame.origin.y - redView1.frame.size.height)];
    outTitle.backgroundColor = [UIColor clearColor];
    outTitle.text = @"车辆出库";
    outTitle.textColor = [UIColor blackColor];
    outTitle.font = [UIFont systemFontOfSize:13];
    outTitle.textAlignment = NSTextAlignmentCenter;
    
    [outView addSubview:outTitle];
    
    UIButton *outBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, outView.frame.size.width, outView.frame.size.height)];
    outBt.backgroundColor = [UIColor clearColor];
    [outBt addTarget:self action:@selector(tapOut:) forControlEvents:UIControlEventTouchUpInside];
    [outView addSubview:outBt];
    
    UIView *inView = [[UIImageView alloc]initWithFrame:CGRectMake(5 + outView.frame.origin.x + outView.frame.size.width, outView.frame.origin.y, outView.frame.size.width, outView.frame.size.height)];
    inView.backgroundColor = [UIColor whiteColor];
    inView.userInteractionEnabled = YES;
    [outInView addSubview:inView];
    
    redView2 = [[UIView alloc]initWithFrame:CGRectMake(10, UNIT * 20, inView.frame.size.width - 20, UNIT * 90)];
    redView2.backgroundColor = [UIColor clearColor];
    [redView2.layer setBorderWidth:1];
    [redView2.layer setBorderColor:CGColorRetain(UIColorFromRGB(0x9F1E1F).CGColor)];
    redView2.alpha = 0;
    [inView addSubview:redView2];
    
    face2 = [[UIImageView alloc]initWithFrame:CGRectMake(redView1.frame.origin.x + UNIT * 25, redView1.frame.origin.y + UNIT * 30, UNIT * 40, UNIT * 40)];
    face2.image = [UIImage imageNamed:@"车辆选择-未选中"];
    face2.contentMode = UIViewContentModeScaleAspectFit;
    [inView addSubview:face2];
    
    inImg = [[UIImageView alloc]initWithFrame:CGRectMake(redView1.frame.size.width + redView1.frame.origin.x - UNIT * 50 * 379 / 108 - UNIT * 25, redView1.frame.origin.y + UNIT * 20, UNIT * 50 * 379 / 108, UNIT * 50)];
    inImg.image = [UIImage imageNamed:@"车辆选择-车辆入库图标"];
    [inView addSubview:inImg];
    
    UILabel *inTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, redView2.frame.origin.y + redView2.frame.size.height, inView.frame.size.width, inView.frame.size.height - redView2.frame.origin.y - redView2.frame.size.height)];
    inTitle.backgroundColor = [UIColor clearColor];
    inTitle.text = @"车辆入库";
    inTitle.textColor = [UIColor blackColor];
    inTitle.font = [UIFont systemFontOfSize:13];
    inTitle.textAlignment = NSTextAlignmentCenter;
    
    [inView addSubview:inTitle];
    
    UIButton *inBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inView.frame.size.width, inView.frame.size.height)];
    inBt.backgroundColor = [UIColor clearColor];
    [inBt addTarget:self action:@selector(tapIn:) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:inBt];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    collect_ = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, outInView.frame.origin.y) collectionViewLayout:flowLayout];
    collect_.backgroundColor = [UIColor clearColor];
    collect_.alwaysBounceVertical = YES;
    
    [self.view addSubview:collect_];
    
    [collect_ registerNib:[UINib nibWithNibName:@"headerCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCollectionReusableView"];
    [collect_ registerNib:[UINib nibWithNibName:@"selectCarCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"selectCarCollectionViewCell"];
    
    collect_.delegate = self;
    collect_.dataSource = self;
    
    float height = carArray.count * 70 + 70 + outInView.frame.size.height;
    
    if (height <= define.frame.origin.y) {
        
        collect_.frame = CGRectMake( collect_.frame.origin.x, 0, collect_.frame.size.width, carArray.count * 70 + 70);
        outInView.frame = CGRectMake(0, collect_.frame.origin.y + collect_.frame.size.height, outInView.frame.size.width, outInView.frame.size.height);
        
    }
    
    [self createAlertShow];
}

-(void)hideDelayed{
    
    alertBack.hidden = YES;
    alertView.hidden = YES;
    alertView1.hidden = YES;
}

#pragma mark - button tap method

-(void)tapOut:(id)sender{
    
    redView1.alpha = 1;
    face1.image = [UIImage imageNamed:@"车辆选择-选择图标"];
    outImg.image = [UIImage imageNamed:@"车辆选择-车辆出库图标-红"];
    
    redView2.alpha = 0;
    face2.image = [UIImage imageNamed:@"车辆选择-未选中"];
    inImg.image = [UIImage imageNamed:@"车辆选择-车辆入库图标"];
    
    outInStr = @"out";
}

-(void)tapIn:(id)sender{
    
    redView1.alpha = 0;
    face1.image = [UIImage imageNamed:@"车辆选择-未选中"];
    outImg.image = [UIImage imageNamed:@"车辆选择-车辆出库图标"];
    
    redView2.alpha = 1;
    face2.image = [UIImage imageNamed:@"车辆选择-选择图标"];
    inImg.image = [UIImage imageNamed:@"车辆选择-车辆入库图标-红"];
    
    outInStr = @"in";
}

-(void)define:(id)sender{
    
    indicator = [THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    if ([outInStr isEqualToString:@"in"]) {
        
        int car = [selectNo intValue];
        ParkingModel * parkingModel = (ParkingModel *)[carArray objectAtIndex:car][@"info"];

        //@WeakObj(self);
        [CommunityManagerPresenters getCardCanIn:parkingModel.carid upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *errmsg = [NSString stringWithFormat:@"%@",data];
                if(resultCode==SucceedCode)
                {
                    if ([errmsg isEqualToString:@"成功"]) {
                        
                        [self getBlueToothCompetence];
                    }else{
                        [indicator stopAnimating];
                        
                        alertBack.hidden = NO;
                        alertView.hidden = NO;
                        
                        [self performSelector:@selector(hideDelayed) withObject:nil afterDelay:3.0];
                    }
                }
                else if(resultCode==FailureCode)
                {
//                    [indicator stopAnimating];
//                    [selfWeak showToastMsg:errmsg Duration:3.0];
                    
                    [indicator stopAnimating];
                    
                    alertBack.hidden = NO;
                    alertView.hidden = NO;
                    [self performSelector:@selector(hideDelayed) withObject:nil afterDelay:3.0];
                    
                }
                else if(resultCode==NONetWorkCode)//无网络处理
                {
                    [indicator stopAnimating];
                    [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];
                }
                
            });
        }];
        
    }else if ([outInStr isEqualToString:@"out"]){
        
        int car = [selectNo intValue];
        
        NSString *judge = [carArray objectAtIndex:car][@"inout"];
        ParkingModel * parkingModel = (ParkingModel *)[carArray objectAtIndex:car][@"info"];
        
        if ([judge isEqualToString:@"in"]) {
            
            [self getBlueToothCompetence];
        }else if ([parkingModel.islock integerValue]==1) {
            
            alertBack.hidden = NO;
            alertView1.hidden = NO;
            [indicator stopAnimating];
            [self performSelector:@selector(hideDelayed) withObject:nil afterDelay:3.0];
        }else{
            
            [self getBlueToothCompetence];
        }
    }

}

#pragma mark - blueTooth method

-(void)getBlueToothCompetence{
    
    @WeakObj(self);
    [CommunityManagerPresenters getGatBlueToothUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
//            NSString *errmsg = [NSString stringWithFormat:@"%@",data];
            if(resultCode==SucceedCode)
            {
                
                NSArray * dataArr = (NSArray *)data;
                NSMutableArray *newArr = [NSMutableArray array];
                if (dataArr.count > 0) {
                    
                    for (int i = 0; i < dataArr.count; i++) {
                        
                        if ([outInStr isEqualToString:@"out"]) {
                            
                            UserUnitKeyModel *unitKey = (UserUnitKeyModel *)dataArr[i];
                            NSString *str = unitKey.bluename;
                            str = [str substringFromIndex:str.length - 3];
                            if ([str isEqualToString:@"chu"]) {
                                [newArr addObject:dataArr[i]];
                            }
//                            if ([str rangeOfString:@"chu"].location != NSNotFound) {
//                                
//                                [newArr addObject:dataArr[i]];
//                            }
                            
                        }else if ([outInStr isEqualToString:@"in"]){
                            
                            UserUnitKeyModel *unitKey = (UserUnitKeyModel *)dataArr[i];
                            NSString *str = unitKey.bluename;
                            str = [str substringFromIndex:str.length - 3];
                            if ([str isEqualToString:@"jin"]) {
                                [newArr addObject:dataArr[i]];
                            }
//                            if ([str rangeOfString:@"jin"].location != NSNotFound) {
//                                
//                                [newArr addObject:dataArr[i]];
//                            }
                        }
                    }
                    
                    NSDictionary *dict = @{@"Competence":newArr,@"car":carMod};
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                    BluetoothRacklViewController *BluetoothRack = [storyboard instantiateViewControllerWithIdentifier:@"BluetoothRacklViewController"];
                    BluetoothRack.dataDict = dict;
                    [self.navigationController pushViewController:BluetoothRack animated:YES];
                }else{
                    
                    [selfWeak showToastMsg:@"该社区没有安装蓝牙抬杆设备" Duration:3.0];
                }
            }
            else if(resultCode==FailureCode)
            {
                
                [selfWeak showToastMsg:@"该社区没有安装蓝牙抬杆设备" Duration:3.0];
                
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {
                [self showNothingnessViewWithType:NoContentTypeNetwork Msg:@"链接失败，请检查网络!" eventCallBack:nil];

            }
        });
    }];
}

#pragma mark - life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    carArray = [NSMutableArray array];
    selectNo = @"99";
    NSArray *arr0 = arrGarages[0];
    for (int i = 0; i < arr0.count; i++) {
        
        ParkingModel * parkingModel=(ParkingModel *)[arr0 objectAtIndex:i];
        if (parkingModel.card==nil||parkingModel.card.length==0) {
            
        }else{
            NSDictionary *dict = @{@"inout":@"out",@"info":parkingModel};
            [carArray addObject:dict];
        }
    }
    NSArray *arr1 = arrGarages[1];
    
    for (int i = 0; i < arr1.count; i++) {
        
        ParkingModel * parkingModel=(ParkingModel *)[arr1 objectAtIndex:i];
        NSDictionary *dict = @{@"inout":@"in",@"info":parkingModel};
        [carArray addObject:dict];
    }
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return carArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
        headerCollectionReusableView * headView;
        headView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCollectionReusableView" forIndexPath:indexPath];
        if(indexPath.section==0)
        {
            headView.topBt.userInteractionEnabled = NO;
            [headView.topBt setTitle:@"选择车牌" forState:UIControlStateNormal];
            [headView.topBt setImage:[UIImage imageNamed:@"车辆选择-选择车牌图标"] forState:UIControlStateNormal];
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
    
    selectCarCollectionViewCell *select = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectCarCollectionViewCell" forIndexPath:indexPath];
    
    ParkingModel * parkingModel = (ParkingModel *)[carArray objectAtIndex:indexPath.row][@"info"];
    select.carText.text = [NSString stringWithFormat:@"%@",parkingModel.card];
    
    if ([selectNo isEqualToString:[NSString stringWithFormat:@"%li",indexPath.row]]) {
        
        select.carText.textColor = UIColorFromRGB(0x9F1E1F);
        select.carImg.image = [UIImage imageNamed:@"车辆选择-车牌图标-红"];
        select.select.image = [UIImage imageNamed:@"车辆选择-选中红"];
        [select.backView.layer setBorderWidth:1];
        [select.backView.layer setBorderColor:CGColorRetain(UIColorFromRGB(0x9F1E1F).CGColor)];
    }else{
        
        select.carText.textColor = UIColorFromRGB(0x4E4A4A);
        select.carImg.image = [UIImage imageNamed:@"车辆选择-车牌图标-灰"];
        select.select.image = [UIImage imageNamed:@"车辆选择-未选中灰"];
        [select.backView.layer setBorderWidth:0];
        [select.backView.layer setBorderColor:CGColorRetain([UIColor clearColor].CGColor)];
    }
        
    return select;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(SCREEN_WIDTH-10, 70);

    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PMCollectionCell *cell=(PMCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.view_BackBg setBackgroundColor:UIColorFromRGB(0xffffff)];
//
//}
//-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PMCollectionCell *cell=(PMCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.view_BackBg setBackgroundColor:UIColorFromRGB(0x818181)];
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = { self.view.frame.size.width - 20, UNIT * 100 + 10};
    return size;
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%li",indexPath.row);
    selectNo = [NSString stringWithFormat:@"%li",indexPath.row];
    outInStr = [NSString stringWithFormat:@"%@",carArray[indexPath.row][@"inout"]];
    carMod = (ParkingModel *)carArray[indexPath.row][@"info"];
    
    if ([outInStr isEqualToString:@"out"]) {
        
        redView1.alpha = 1;
        face1.image = [UIImage imageNamed:@"车辆选择-选择图标"];
        outImg.image = [UIImage imageNamed:@"车辆选择-车辆出库图标-红"];
        
        redView2.alpha = 0;
        face2.image = [UIImage imageNamed:@"车辆选择-未选中"];
        inImg.image = [UIImage imageNamed:@"车辆选择-车辆入库图标"];
    }else if ([outInStr isEqualToString:@"in"]){
        
        redView1.alpha = 0;
        face1.image = [UIImage imageNamed:@"车辆选择-未选中"];
        outImg.image = [UIImage imageNamed:@"车辆选择-车辆出库图标"];
        
        redView2.alpha = 1;
        face2.image = [UIImage imageNamed:@"车辆选择-选择图标"];
        inImg.image = [UIImage imageNamed:@"车辆选择-车辆入库图标-红"];
    }
    
    [define setTitleColor:UIColorFromRGB(0x9F1E1F) forState:UIControlStateNormal];
    [define.layer setBorderWidth:1];
    [define.layer setBorderColor:CGColorRetain(UIColorFromRGB(0x9F1E1F).CGColor)];
    define.userInteractionEnabled = YES;

    [collect_ reloadData];
}

@end
