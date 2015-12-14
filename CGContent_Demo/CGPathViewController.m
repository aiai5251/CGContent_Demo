//
//  CGPathViewController.m
//  CGContent_Demo
//
//  Created by shiyaorong on 15/11/26.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import "CGPathViewController.h"
#import "CGContextView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CGPathViewController ()
@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation CGPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 250.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.view.layer addSublayer:self.colorLayer];
}

- (IBAction)CGPathAction:(id)sender {
// ******************* CGPath **********************************************
    
    // 开始图像绘图
    UIGraphicsBeginImageContext(self.view.bounds.size);
    // 获取当前画布CGContextRef
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //画布的起始点
    CGAffineTransform transform = CGAffineTransformMakeTranslation(50, 100);
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    //左眼, 画圆，以传入的transform为起始点开始画。
    CGPathAddEllipseInRect(path, &transform, CGRectMake(0, 0, 20, 20));
    //右眼
    CGPathAddEllipseInRect(path, &transform, CGRectMake(80, 0, 20, 20));
    //笑
    CGPathMoveToPoint(path, &transform, 100, 50);
    CGPathAddArc(path, &transform, 50, 50, 50, 0, M_PI, NO);
    //将CGMutablePathRef添加到当前Context内
    CGContextAddPath(gc, path);
    //设置绘图属性
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(gc, 2);
    //执行绘画
    CGContextStrokePath(gc);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
    NSLog(@"%@", NSStringFromCGRect(imgview.frame));
    [self.view addSubview:imgview];
    
// *************************************************************************
    
}

- (IBAction)CGPathBaseAction:(id)sender {
    // 直接写CGPath需要展示在画布上，否则可用CAShapeLayer
//    CGContextView *contextView = [[CGContextView alloc] initWithFrame:CGRectMake(20, 300, 335, 350)];
//    contextView.baseType = BasePathType;
//    [self.view addSubview:contextView];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0) radius:100 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(-90.01) clockwise:YES];
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.lineWidth = 10;
    circle.lineCap = kCALineCapRound;
    circle.strokeColor = [UIColor greenColor].CGColor;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.zPosition = 1;//比如layer1和layer2在同一个父layer上，layer1的zPosition=1，layer2的zPosition=0，layer1就会挡住layer2
    
    circle.path = circlePath.CGPath;
    [self.view.layer addSublayer:circle];
    
    CAShapeLayer *circleBackground = [CAShapeLayer layer];
    circleBackground.path = circlePath.CGPath;
    circleBackground.lineCap = kCALineCapRound;
    circleBackground.lineWidth = 10;
    circleBackground.strokeColor = [UIColor clearColor].CGColor; //redColor,默认背景layer
    circleBackground.fillColor = [UIColor clearColor].CGColor;
    circleBackground.strokeEnd = 1.0;
    circleBackground.zPosition = -1;
    [self.view.layer addSublayer:circleBackground];
    
    //动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 4;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @(60/100.0);
    pathAnimation.removedOnCompletion = NO;//完成后是否移除动画
//    pathAnimation.fillMode = kCAFillModeForwards;//
    [circle addAnimation:pathAnimation forKey:@"stokeEndAn"];
    circle.strokeEnd = 60 / 100.0;
//    circle.strokeEnd = 1; //动画执行百分比
    
    CAShapeLayer *gradienMask = [CAShapeLayer layer];
    gradienMask.fillColor = [UIColor clearColor].CGColor;
    gradienMask.strokeColor = [UIColor blueColor].CGColor;
    gradienMask.lineWidth = 10;
    gradienMask.lineCap = kCALineCapRound;
    gradienMask.frame = self.view.frame;
    gradienMask.path = circle.path;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer]; //渐变色
    gradientLayer.startPoint = CGPointMake(0.5, 0.8);
    gradientLayer.endPoint = CGPointMake(0.5, 0.0);
    gradientLayer.frame = gradienMask.frame;
    NSArray *colors = @[(id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor];
    gradientLayer.colors = colors;
    [gradientLayer setMask:gradienMask];
    [circle addSublayer:gradientLayer];
    gradienMask.strokeEnd = 60 / 100.0;
    [gradienMask addAnimation:pathAnimation forKey:@"stokeEndAn"];
}

- (IBAction)CGPathChartAction:(id)sender {
    
    CGFloat JianJu = 30;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSMutableArray *suijiArr = [NSMutableArray arrayWithObjects:@"500", @"340", @"400", @"320", @"550", @"520", @"310", @"440", @"380", @"580", @"400", nil];
    NSMutableArray *startSuiJiArr = [NSMutableArray array];
    for (int i = 0; i < 11; i++) {
        [path moveToPoint:CGPointMake(10, 300 + i * JianJu)];
        [path addLineToPoint:CGPointMake(310, 300 + i * JianJu)];
        
        [path moveToPoint:CGPointMake(10 + i * JianJu, 300)];
        [path addLineToPoint:CGPointMake(10 + i * JianJu, 600)];
        
        CGFloat starShu = [[suijiArr objectAtIndex:i] floatValue];
        [startSuiJiArr addObject:NSStringFromCGPoint(CGPointMake(10 + JianJu * i, starShu))];
 
    }
    [path stroke];
    
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.lineWidth = 2;
    bgLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    bgLayer.fillColor = nil;
    bgLayer.path = path.CGPath;
    [self.view.layer addSublayer:bgLayer];
    
//    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor blueColor].CGColor;
    lineLayer.fillColor = nil;
    [self.view.layer addSublayer:lineLayer];
    
//    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    CGMutablePathRef fillPath = CGPathCreateMutable();
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.lineWidth = 1;
    fillLayer.strokeColor = [UIColor clearColor].CGColor;
    fillLayer.fillColor = [UIColor cyanColor].CGColor;
    [self.view.layer addSublayer:fillLayer];
    
    NSString *star = [startSuiJiArr objectAtIndex:0];
    CGPoint starpoint = CGPointFromString(star);
//    [linePath moveToPoint:CGPointMake(starpoint.x, starpoint.y)];
//    [CGPathMoveToPoint(linePath, NULL, starpoint.x, starpoint.y)];
    CGPathMoveToPoint(linePath, nil, starpoint.x, starpoint.y);
//    [fillPath moveToPoint:CGPointMake(starpoint.x, starpoint.y)];
    CGPathMoveToPoint(fillPath, nil, starpoint.x, starpoint.y);
    for (int i = 0; i < startSuiJiArr.count - 1; i++) {
        NSString *end = [startSuiJiArr objectAtIndex:i + 1];
        CGPoint endShu = CGPointFromString(end);
        
//        [linePath addLineToPoint:CGPointMake(endShu.x, endShu.y)];
//        [linePath stroke]; //不需要写
        CGPathAddLineToPoint(linePath, nil, endShu.x, endShu.y);
        
//        [fillPath addLineToPoint:CGPointMake(endShu.x, endShu.y)];
        CGPathAddLineToPoint(fillPath, nil, endShu.x, endShu.y);
    }

//    [fillPath addLineToPoint:CGPointMake(310, 600)];
//    [fillPath addLineToPoint:CGPointMake(10, 600)];
    CGPathAddLineToPoint(fillPath, nil, 310, 600);
    CGPathAddLineToPoint(fillPath, nil, 10, 600);

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    lineLayer.path = linePath;
    [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"fillEnd"];
    fillAnimation.duration = 2;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fillAnimation.autoreverses = NO;
    fillAnimation.fromValue = (__bridge id)linePath;
    fillAnimation.toValue = (__bridge id)fillPath;
    fillAnimation.fillMode = kCAFillModeForwards;
    fillLayer.path = fillPath;
    [fillLayer addAnimation:fillAnimation forKey:@"fillEndAn"];

}
- (IBAction)CGPathCircleAction:(id)sender {
    CGFloat pieRadius = 80;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
//    [maskPath moveToPoint:CGPointMake(165, 375)]; //再说
    [maskPath addArcWithCenter:CGPointMake(165, 375) radius:pieRadius / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor cyanColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor redColor].CGColor; //不清楚,遮盖物,除了clear,其他都会显示圆
    maskLayer.lineWidth = pieRadius;
    maskLayer.strokeStart = 0.0;
    maskLayer.strokeEnd = 1.0;
    maskLayer.path = maskPath.CGPath;
    [self.view.layer addSublayer:maskLayer];
    
#warning by shi 必须写  strokeEnd，strokeStart
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 5;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [maskLayer addAnimation:animation forKey:@"suibianxie"];
    
    /*
     position-移动动画: 不能用在这个圆上
     //2.设置动画属性初始值和结束值
     //basicAnimation.fromValue=[NSNumber numberWithInteger:50];//可以不设置，默认为图层初始状态
     basicAnimation.toValue=[NSValue valueWithCGPoint:location];
     //basicAnimation.repeatCount=HUGE_VALF;//设置重复次数,HUGE_VALF可看做无穷大，起到循环动画的效果
     //存储当前位置在动画结束后使用
     [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"KCBasicAnimationLocation"];
     //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
     [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Translation"];
     */
    
    
    CABasicAnimation *coloranimation = [CABasicAnimation animation];
    coloranimation.keyPath = @"backgroundColor";
    coloranimation.toValue = (__bridge id)[UIColor redColor].CGColor;
    [self applyBasicAnimation:coloranimation toLayer:self.colorLayer];
    
}

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer
{
    //set the from value (using presentation layer if available)
    // 获取的背景颜色
    animation.fromValue = [layer.presentationLayer ?: layer valueForKeyPath:animation.keyPath];
    //update the property in advance
    //note: this approach will only work if toValue != nil
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];
    //apply animation to layer
    [layer addAnimation:animation forKey:nil];
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
