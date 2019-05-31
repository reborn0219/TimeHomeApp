//
//  MultipleChoicesPopVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MultipleChoicesPopVC.h"
#import "MultipleChoicesCell.h"

@implementation MultipleChoicesModel
@end

@interface MultipleChoicesPopVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
}


@end

@implementation MultipleChoicesPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------初始化---------
-(void)initView
{
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.allowsMultipleSelection=YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MultipleChoicesCell" bundle:nil]
          forCellWithReuseIdentifier:@"MultipleChoicesCell"];

}

/**
 *  返回实例
 *
 *  @return return value description
 */
+(MultipleChoicesPopVC *)getInstance
{
    MultipleChoicesPopVC * alertVC= [[MultipleChoicesPopVC alloc] initWithNibName:@"MultipleChoicesPopVC" bundle:nil];
    return alertVC;
}



#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    <#view description#>
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (self.arryLabTitle==nil) {
        return 0;
    }
    return [self.arryLabTitle count];
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
    MultipleChoicesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MultipleChoicesCell" forIndexPath:indexPath];
    MultipleChoicesModel * mcm=[self.arryLabTitle objectAtIndex:indexPath.item];
    cell.lab_Title.text=mcm.title;
    if(mcm.isSelecting)
    {
        cell.lab_Title.layer.borderColor=UIColorFromRGB(0xAB2121).CGColor;
        cell.lab_Title.layer.borderWidth=1;
    }
    else
    {
      cell.lab_Title.layer.borderWidth=0;
    }
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_SCALE(1/4.4), 35);
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MultipleChoicesCell *cell=(MultipleChoicesCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:UIColorFromRGB(0xffffff)];
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    MultipleChoicesCell *cell=(MultipleChoicesCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:UIColorFromRGB(0x818181)];
    cell.lab_Title.layer.borderColor=UIColorFromRGB(0xAB2121).CGColor;
    cell.lab_Title.layer.borderWidth=1;
    MultipleChoicesModel * mcm=[self.arryLabTitle objectAtIndex:indexPath.item];
    mcm.isSelecting=YES;
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MultipleChoicesCell *cell=(MultipleChoicesCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.lab_Title.layer.borderColor=UIColorFromRGB(0xAB2121).CGColor;
    cell.lab_Title.layer.borderWidth=0;
    MultipleChoicesModel * mcm=[self.arryLabTitle objectAtIndex:indexPath.item];
    mcm.isSelecting=NO;
}


#pragma mark --------显示隐藏---------
/**
 *  显示
 *
 *  @param vc       上级控制器
 *  @param data     标尺段标题数据
 *  @param callBack 事件回调
 */
-(void)showPopView:(UIViewController *) parent data:(NSArray *) data eventCallBack:(ViewsEventBlock) callBack
{
    self.arryLabTitle=data;
    self.eventCallBack=callBack;
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
        self.view.backgroundColor=RGBAFrom0X(0x000000, 0.4);
    }];
}
/**
 *  隐藏显示
 */
-(void)dismissPopView
{
    self.view.backgroundColor=[UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}

#pragma mark --------事件处理---------


/**
 *  取消事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_CancelEvent:(UIButton *)sender {
    [self dismissPopView];
    MultipleChoicesModel * mcm;
    for(int i=0;i<self.arryLabTitle.count;i++)
    {
        mcm=[self.arryLabTitle objectAtIndex:i];
        mcm.isSelecting=mcm.isSelect;
    }
}

/**
 *  确定事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_OkEvent:(UIButton *)sender {
    [self dismissPopView];
    if (self.eventCallBack) {
        MultipleChoicesModel * mcm;
        for(int i=0;i<self.arryLabTitle.count;i++)
        {
            mcm=[self.arryLabTitle objectAtIndex:i];
            if(mcm.isSelect!=mcm.isSelecting)
            {
                mcm.isSelect=mcm.isSelecting;
            }
        }
        self.eventCallBack(self.arryLabTitle,sender,ALERT_OK);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissPopView];
    MultipleChoicesModel * mcm;
    for(int i=0;i<self.arryLabTitle.count;i++)
    {
        mcm=[self.arryLabTitle objectAtIndex:i];
        mcm.isSelecting=mcm.isSelect;
    }
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
