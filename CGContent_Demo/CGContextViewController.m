//
//  CGContextViewController.m
//  CGContent_Demo
//
//  Created by shiyaorong on 15/11/26.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import "CGContextViewController.h"
#import "CGContextView.h"

@interface CGContextViewController ()

@end

@implementation CGContextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)CGContextAction:(id)sender {
//  ******************* CGContextRef ****************************************
    
    //开始图像绘图
    UIGraphicsBeginImageContext(self.view.bounds.size);
    //获取当前CGContextRef
    CGContextRef gc = UIGraphicsGetCurrentContext();
    //使用CGContextTranslateCTM函数来转移坐标的Transform，这样不用按照实际显示做坐标计算
    CGContextTranslateCTM(gc, 50, 50);
    //左眼
    CGContextAddEllipseInRect(gc, CGRectMake(0, 0, 20, 20));
    //右眼
    CGContextAddEllipseInRect(gc, CGRectMake(80, 0, 20, 20));
    //笑
    CGContextMoveToPoint(gc, 100, 50);
    CGContextAddArc(gc, 50, 50, 50, 0, M_PI, NO);
    //设置绘图属性
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(gc, 2);
    //开始绘画
    CGContextStrokePath(gc);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageview = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imageview];
    
//  *************************************************************************

    
}
- (IBAction)CGContextViewAction:(id)sender {
    
    CGContextView *contextView = [[CGContextView alloc] initWithFrame:CGRectMake(20, 300, 335, 350)];
    contextView.baseType = BaseContextType;
    [self.view addSubview:contextView];
}
- (IBAction)CGContextLineChartAction:(id)sender {
    CGContextView *contextView = [[CGContextView alloc] initWithFrame:CGRectMake(20, 300, 335, 350)];
    contextView.baseType = BaseLineChartType;
    [self.view addSubview:contextView];
}

- (IBAction)CGContextBarChartAction:(id)sender {
    CGContextView *contextView = [[CGContextView alloc] initWithFrame:CGRectMake(20, 300, 335, 350)];
    contextView.baseType = BaseBarChartType;
    [self.view addSubview:contextView];
}
- (IBAction)CGContextPieChartAction:(id)sender {
    CGContextView *contextView = [[CGContextView alloc] initWithFrame:CGRectMake(20, 300, 335, 350)];
    contextView.baseType = BasePieChartType;
    [self.view addSubview:contextView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
