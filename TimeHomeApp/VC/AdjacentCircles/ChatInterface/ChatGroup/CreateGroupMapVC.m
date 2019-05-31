//
//  CreateGroupMapVC.m
//  TimeHomeApp
//53
//  Created by UIOS on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CreateGroupMapVC.h"
#import "GroupCreateSuccessVC.h"

@interface CreateGroupMapVC ()<BMKMapViewDelegate>
@property (nonatomic,strong)BMKMapView * bMapView;
@end

@implementation CreateGroupMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;

    self.bMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(10,70, SCREEN_WIDTH-20,SCREEN_HEIGHT-70-55-(44+statuBar_Height))];
    self.bMapView.zoomLevel = 16;
    self.bMapView.centerCoordinate = CLLocationCoordinate2DMake(38, 114);
    self.bMapView.trafficEnabled=YES;
    self.bMapView.showMapScaleBar=YES;
    //自定义比例尺的位置
    self.bMapView.mapScaleBarPosition = CGPointMake(10,10);
    [self.view addSubview:self.bMapView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"--------------");
}
#pragma mark - 完成
-(void)rightAction:(id)sender
{
    GroupCreateSuccessVC * gcsVC = [[GroupCreateSuccessVC alloc]init];
    [self.navigationController pushViewController:gcsVC animated:YES];
    
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
