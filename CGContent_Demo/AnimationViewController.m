//
//  AnimationViewController.m
//  CGContent_Demo
//
//  Created by shiyaorong on 15/12/3.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import "AnimationViewController.h"
#import "XYPieChart.h"

@interface AnimationViewController ()
@property (strong, nonatomic) XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)pieAnimation:(id)sender {
    self.pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(10, 180, 300, 300)];
    self.pieChart.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_pieChart];


    // 🎸4.定义自己需要改变的block,将这个block传给第二个页面的属性
//    void(^block)(NSUInteger selected) = ^(NSUInteger selectedIndex) {
//        self.selectedLabel.text = [NSString stringWithFormat:@"%zd", selectedIndex];
//    };
//    self.pieChart.returnBlock = block;
    
    [self.pieChart returnSelected:^(NSUInteger selectedIndex) {
        self.selectedLabel.text = [NSString stringWithFormat:@"%zd", selectedIndex];
    }];
    
    NSUInteger sliceCount = 5; //饼图个数
    
    // 产生随机数组
    NSMutableArray *slicesArr = [NSMutableArray array];
    for(int i = 0; i < sliceCount; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [slicesArr addObject:one];
    }
    
    double sum = 0.0;
    double values[sliceCount];
    for (int index = 0; index < sliceCount; index++) {
        values[index] = [[slicesArr objectAtIndex:index] doubleValue];
        NSLog(@"values[index]＝＝＝＝＝＝%f", values[index]);
        //计算出总数
        sum += values[index];
    }

    NSMutableArray *angles = [NSMutableArray array];
    for (int index = 0; index < sliceCount; index++) {
        double div;
        if (sum == 0)
            div = 0;
        else
            //百分
            div = values[index] / sum;        
        [angles addObject:[NSNumber numberWithDouble:M_PI * 2 * div]];
        //得到角度值
        NSLog(@"angle[index] -- %f", M_PI * 2 * div);
    }
    
    [self.pieChart refreshData:angles];
    
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
