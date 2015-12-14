//
//  UIBezierPathViewController.m
//  CGContent_Demo
//
//  Created by shiyaorong on 15/11/26.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import "UIBezierPathViewController.h"

@interface UIBezierPathViewController ()

@end

@implementation UIBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)UIBezierAction:(id)sender {
    // ******************* UIBezierPath ****************************************
    //不需要考虑Y轴翻转的问题,在画弧的时候，clockwise参数是和现实一样的，如果需要顺时针就传YES，而不是像Quartz环境下传NO的。
    
    //开始图像绘图
    UIGraphicsBeginImageContext(self.view.bounds.size);
    //创建UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    //左眼
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)]];
    //右眼
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(80, 0, 20, 20)]];
    //笑
    [path moveToPoint:CGPointMake(100, 50)];
    //注意：这里clockwise参数是YES而不是NO。因为这里不是Quartz，不需要考虑Y轴翻转的问题
    [path addArcWithCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:M_PI clockwise:YES];
    //使用applyTransform函数来转移坐标的Transform，这样我们不用按照实际显示做坐标计算
    [path applyTransform:CGAffineTransformMakeTranslation(50, 50)];
    //设置绘图属性
    [[UIColor blueColor] setStroke];
    [path setLineWidth:2];
    //执行绘图
    [path stroke];
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageview = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imageview];
    
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
