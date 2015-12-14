//
//  CGContextView.m
//  CGContent_Demo
//
//  Created by shiyaorong on 15/11/26.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import "CGContextView.h"

//弧度值
#define Angle(precent) 2 * M_PI * precent

#define MARGIN_LEFT 35              //统计图的左间隔
#define MARGIN_TOP 30               //统计图的顶部间隔
#define MARGIN_BETWEEN_X_POINT 50   //X轴的坐标点的间距
#define Y_SECTION 5                 //纵坐标轴的区间数

@implementation CGContextView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
//        [self setNeedsDisplay]; //可写可不写，暂时没发现什么区别
        
        self.pathArray = [NSMutableArray array];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.baseType == BaseContextType) {
        // 获取画布
        CGContextRef currentCtx = UIGraphicsGetCurrentContext();
        // 设置填充画布颜色
        CGContextSetRGBFillColor(currentCtx, 1, 1, 1, 1.0); //根据RGB色值来填充
        // 设置画笔
        //    CGContextSetStrokeColorWithColor(currentCtx, [UIColor blackColor].CGColor);
        CGContextSetRGBStrokeColor(currentCtx, 0, 0, 0, 1.0); //根据RGB
        // 画笔的宽度
        CGContextSetLineWidth(currentCtx, 2);
        
        // 将画笔移到某个点
        CGContextMoveToPoint(currentCtx, 10, 10);
        // 画一个直线
        CGContextAddLineToPoint(currentCtx, 300, 10);
//        CGContextSetLineCap(currentCtx, kCGLineCapSquare);//设置线段收尾样式
//        CGContextSetLineJoin(currentCtx, kCGLineJoinBevel);//设置两条线连接，kCGLineJoinRound ：圆的； kCGLineJoinMiter：尖的；kCGLineJoinBevel： 斜的
        CGContextSetMiterLimit(currentCtx, 3);// 0-2: 斜的 3~:尖的
        
        CGContextAddLineToPoint(currentCtx, 200, 100); //接着上一个点开始画线
        // 画一个折线
        //    CGContextSetLineDash(currentCtx, 0, 0, 0);     //避免折线虚线化， 写虚线用
        CGContextMoveToPoint(currentCtx, 5, 30);
        CGContextAddLineToPoint(currentCtx, 65, 70);
        
        // 设置完成之后开始画线
        CGContextStrokePath(currentCtx); //画完一个写一个，不会影响上下
        
        // 画一个虚线
        CGContextSetRGBStrokeColor(currentCtx, 0.1, 0.2, 0.3, 1.0);
        CGFloat dashArray[] = {10, 5}; //不能用float
        // 画虚线, 第一条画10，跳过5（间隔5），再继续画2....
        /*
         params CGFloat phase: 开始的第一段是 10 - (phase)
         params lengths: 0 的画就是画直线，传入数组，可画虚线
         params count: 数组个数, 没有传入lengths数组是必须写0，必须是数组的个数
         */
        CGContextSetLineDash(currentCtx, 0, dashArray, 2); //会影响前后画的线
        CGContextMoveToPoint(currentCtx, 70, 20);
        CGContextAddLineToPoint(currentCtx, 200, 20);
        
        CGContextStrokePath(currentCtx);
        
        // 画一个圆
        CGContextSetLineDash(currentCtx, 0, 0, 0); //上面画了虚线，需要把画笔重新设置为直线
        CGContextSetStrokeColorWithColor(currentCtx, [UIColor whiteColor].CGColor);
        // 1:
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度;
        //x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        //    CGContextAddArc(currentCtx, 100, 100, 15, 0, M_PI * 2, 0); //M_PI为半圆，画弧线
        // 2:
        // x: 距左边0，y:距顶上0，width：横向直径，height：纵向直径
        CGContextAddEllipseInRect(currentCtx, CGRectMake(100, 100, 20, 20));
        CGContextStrokePath(currentCtx);
        
        // 画一个实心圆点
        CGContextFillEllipseInRect(currentCtx, CGRectMake(40, 0, 5, 5));
        CGContextFillEllipseInRect(currentCtx, CGRectMake(100, 200, 5, 5));
        CGContextFillEllipseInRect(currentCtx, CGRectMake(300, 100, 5, 5));
        
        // 画虚曲线
        CGContextSetRGBStrokeColor(currentCtx, 0.3, 0.2, 0.1, 1);
        CGFloat dashArray1[] = {3, 2, 10};
        CGContextSetLineDash(currentCtx, 0, dashArray1, 3);
        CGContextMoveToPoint(currentCtx, 5, 90);
        //Append a cubic Bezier curve from the current point to `(x,y)', with control points `(cp1x, cp1y)' and `(cp2x, cp2y)
        CGContextAddCurveToPoint(currentCtx, 40, 0, 100, 200, 300, 100);
        CGContextAddCurveToPoint(currentCtx, 240, 100, 10, 50, 300, 300);
        CGContextStrokePath(currentCtx);
        
        // 绘制连续的曲线
        CGFloat dashArry2[] = {3, 2, 10, 20, 5};
        CGContextSetLineDash(currentCtx, 0, dashArry2, 5);
        CGContextMoveToPoint(currentCtx, 5, 200);
        CGContextAddCurveToPoint(currentCtx, 50, 200, 80, 300, 100, 200); //画三次点曲线，前面2个控制点，最后一个是最终点坐标
        CGContextAddQuadCurveToPoint(currentCtx, 150, 100, 200, 200);//画二次点曲线,只有2个控制点
        CGContextStrokePath(currentCtx);
        
        // 画弧线
        CGContextSetStrokeColorWithColor(currentCtx, [UIColor redColor].CGColor);
        CGContextSetLineDash(currentCtx, 0, 0, 0);
        CGContextAddArc(currentCtx, 200, 90, 40, 0, M_PI_4, 0); //x,y为圆点
        CGContextStrokePath(currentCtx);
        
        // 画一个实心矩形
        CGContextSetRGBFillColor(currentCtx, 0, 0.25, 0, 0.5); //写在实心矩形的上面，填充颜色
        CGContextFillRect(currentCtx, CGRectMake(5, 210, 10, 10)); //实心矩形
        
        // 画矩形
        CGContextAddRect(currentCtx, CGRectMake(5, 230, 20, 20));
        CGContextStrokePath(currentCtx);
        
        // 画椭圆
        /*
         CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
         */
        CGContextSaveGState(currentCtx);
        CGContextAddEllipseInRect(currentCtx, CGRectMake(90, 200, 70, 30));
        CGContextFillPath(currentCtx); //只是填充椭圆内的颜色，没有椭圆的线
        //    CGContextDrawPath(currentCtx, kCGPathFillStroke); //绘制路径加填充
        //    CGContextStrokePath(currentCtx); //只是画椭圆的线，没有填充颜色
        
        CGContextRestoreGState(currentCtx);// 恢复到之前的context
    } else if (self.baseType == BaseLineChartType) {
        // 折线图
        CGContextRef currentCtx = UIGraphicsGetCurrentContext();

        CGContextSetLineWidth(currentCtx, 0.5);
        CGContextSetFillColorWithColor(currentCtx, [UIColor blackColor].CGColor);
        CGContextSetAlpha(currentCtx, 0.5);
        
        // 画多条线， 4条件形成的矩形，可以用CGcontextAddRect直接形成一个矩形
        CGPoint points[] = {CGPointMake(MARGIN_LEFT, MARGIN_TOP),
                            CGPointMake(self.frame.size.width - MARGIN_LEFT, MARGIN_TOP),
                            CGPointMake(self.frame.size.width - MARGIN_LEFT, self.frame.size.height - MARGIN_TOP),
                            CGPointMake(MARGIN_LEFT, self.frame.size.height - MARGIN_TOP)};
        CGContextAddLines(currentCtx, points, 4);
        CGContextClosePath(currentCtx); // 不写只有3条线，最后一根线没有
        CGContextStrokePath(currentCtx);
        
        // 画多条虚线,利用for循环
        //虚线间距
        CGFloat dashedSpace = (CGFloat)(self.frame.size.height - 2*MARGIN_TOP)/Y_SECTION;

        CGFloat lengths[] = {5, 5};
        CGContextSetLineDash(currentCtx, 0, lengths, 1);
        for (int index = 1; index < Y_SECTION; index++) {
            CGContextMoveToPoint(currentCtx, MARGIN_LEFT, MARGIN_TOP + dashedSpace * index);
            CGContextAddLineToPoint(currentCtx, self.frame.size.width - MARGIN_LEFT, MARGIN_TOP + dashedSpace * index);
        }
        CGContextStrokePath(currentCtx);
        
        // 设置纵坐标
        for (int index = 0; index < 6; index++) {
            CGPoint centerPoint = CGPointMake(MARGIN_LEFT / 2, MARGIN_TOP + dashedSpace * index);
            CGRect bounds = CGRectMake(0, 0,  MARGIN_LEFT - 10, 15);
            UILabel *yNumber = [self createLabelWithCenter:centerPoint withBounds:bounds withText:[NSString stringWithFormat:@"%zd", 5 + index] withtextAlignment:2];
            [self addSubview:yNumber];
        }
        
        for (int index = 0; index < 5; index++) {
            CGPoint centerPoint = CGPointMake(MARGIN_LEFT + MARGIN_BETWEEN_X_POINT * index, self.frame.size.width - MARGIN_TOP / 2 + 5);
            CGRect bounds = CGRectMake(0, 0, MARGIN_BETWEEN_X_POINT, 15);
            UILabel *xNumber = [self createLabelWithCenter:centerPoint withBounds:bounds withText:[NSString stringWithFormat:@"%zd", index] withtextAlignment:2];
            [self addSubview:xNumber];
        }
        
        // 绘制坐标点
        NSMutableArray *coordinateArray = [NSMutableArray array];
        NSMutableArray *initCoordinateArray = [NSMutableArray array];
        
        for (int index = 0; index < 5; index ++) {
            CGFloat suiji = arc4random_uniform(5);
            NSLog(@"%f", suiji);
            CGPoint itemCoordinate = CGPointMake(MARGIN_LEFT + index * MARGIN_BETWEEN_X_POINT, self.frame.size.height - (MARGIN_TOP + suiji * dashedSpace));
            //记录坐标点
            [coordinateArray addObject:NSStringFromCGPoint(itemCoordinate)];
            //画实心圆
            CGContextAddArc(currentCtx, itemCoordinate.x, itemCoordinate.y, 4, 0, 2 * M_PI, YES);
            CGContextFillPath(currentCtx);
            //记录初始化坐标点，方便后续动画
            itemCoordinate.y = self.frame.size.height - MARGIN_TOP;
            [initCoordinateArray addObject:NSStringFromCGPoint(itemCoordinate)];
        }
        CGContextStrokePath(currentCtx);
        
        // 绘制折线
        CGContextSetLineDash(currentCtx, 0, 0, 0);
        // 绘制路线
        CGMutablePathRef path = CGPathCreateMutable();
        for (int index = 0; index < coordinateArray.count - 1; index++) {
            // 一段折现开始点
            NSString *startPointStr = [coordinateArray objectAtIndex:index];
            CGPoint starPoint = CGPointFromString(startPointStr);
            // 一段折现结束点
            NSString *endPointStr = [coordinateArray objectAtIndex:index + 1];
            CGPoint endPoint = CGPointFromString(endPointStr);
            
            //1: 使用coreGraphics直接绘制
//            CGContextMoveToPoint(currentCtx, starPoint.x, starPoint.y);
//            CGContextAddLineToPoint(currentCtx, endPoint.x, endPoint.y);
            
            //2:每一个折现都是用一个path，动画过程就变成分动动画，而且都是同时执行的。
//            CAShapeLayer *lineLayer = [CAShapeLayer layer];
//            lineLayer.lineWidth = 1;
//            lineLayer.lineCap = kCALineCapButt;//线尾的样式
//            lineLayer.strokeColor = [UIColor blueColor].CGColor;
//            lineLayer.fillColor = nil;
//            
//            CGMutablePathRef linePath = CGPathCreateMutable();
//            CGPathMoveToPoint(linePath, nil, starPoint.x, starPoint.y); //transfrom 为nil
//            CGPathAddLineToPoint(linePath, nil, endPoint.x, endPoint.y);
//            lineLayer.path = linePath;
//            
//            // 动画
//            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//            pathAnimation.duration = 2; //动画时间
//            //一个时间函数定义动画的节奏。默认为* nil表示线性踱来踱去
//            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//            pathAnimation.autoreverses = NO;
//            pathAnimation.fillMode = kCAFillModeForwards;
//            [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
//            
//            [self.layer addSublayer:lineLayer];
//            CGPathRelease(linePath);
            
            //3: 所有的绘图信息放在同一个path中，动画过程就变成连续的了
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.lineWidth = 1;
            lineLayer.lineCap = kCALineCapRound;
            lineLayer.strokeColor = [UIColor whiteColor].CGColor;
            lineLayer.fillColor = nil;
            
            // 循环之前提前声明一个path
            CGPathMoveToPoint(path, nil, starPoint.x, starPoint.y);
            CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
            lineLayer.path = path;
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 2;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            pathAnimation.fillMode = kCAFillModeForwards;
            [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            [self.layer addSublayer:lineLayer];
        }
        
        CGContextStrokePath(currentCtx);
        CGPathRelease(path);
        
    } else if (self.baseType == BaseBarChartType) {
        
        CGContextRef currentCtx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(currentCtx, [UIColor blueColor].CGColor);

        //虚线间距
        for (int i = 0; i < 5; i++) {
            CGFloat suiji = arc4random_uniform(300) + 1;
            
            CGFloat starx = MARGIN_LEFT + i * MARGIN_BETWEEN_X_POINT - 15;
            CGFloat starY = self.frame.size.height - suiji;
            CGRect itemRect = CGRectMake(starx, starY, 30, suiji);
            NSLog(@"%@", NSStringFromCGRect(itemRect));
            //1: 使用coreGraphics直接绘制
//            CGContextMoveToPoint(currentCtx, starx, starY);
//            // 下面两句可直接用 CGContextFillRect(currentCtx, itemRect);
//            CGContextAddRect(currentCtx, itemRect); //只是画矩形的边框，没有填充
//            CGContextFillPath(currentCtx); //不写就没有填充颜色

            //2: 使用动画
            CAShapeLayer *barLayer = [CAShapeLayer layer];
            barLayer.lineWidth = 1;
            barLayer.lineCap = kCALineCapButt;
            barLayer.strokeColor = [UIColor whiteColor].CGColor;
            barLayer.fillColor = nil;
            
            CGMutablePathRef barPath = CGPathCreateMutable();
            CGPathMoveToPoint(barPath, nil, itemRect.origin.x, itemRect.origin.y);
            CGPathAddRect(barPath, nil, itemRect);
            barLayer.path = barPath;
            CGMutablePathRef initBarPath = CGPathCreateMutable();
            CGPathMoveToPoint(initBarPath, nil, itemRect.origin.x, self.frame.size.height - MARGIN_TOP);
            CGPathAddRect(initBarPath, nil, CGRectMake(itemRect.origin.x, self.frame.size.height - MARGIN_TOP, itemRect.size.width, 0));
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnimation.duration = 2;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathAnimation.fromValue = (__bridge id)initBarPath;
            pathAnimation.toValue = (__bridge id)barPath;
            //是否翻转绘制
            pathAnimation.autoreverses = NO;
            pathAnimation.fillMode = kCAFillModeForwards;
            [barLayer addAnimation:pathAnimation forKey:@"path"];

            [self.layer addSublayer:barLayer];
            CGPathRelease(barPath);
            CGPathRelease(initBarPath);
            
        }
        CGContextStrokePath(currentCtx);
    } else if (self.baseType == BasePieChartType) {
        
        // 设置饼状图的半径
        __block CGFloat pieRadius = 80;
        
        //根据传进来的数据计算比例数据
        __block CGFloat totalData = 0.0;
        __block NSMutableArray *dataSource = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            //随机生成数据源
            CGFloat suiji = arc4random_uniform(10) + 1;  //1~10
            [dataSource addObject:[NSNumber numberWithFloat:suiji]];
            //统计总值
            totalData = totalData + suiji;
        }
        
        // 百分比数组
        __block NSMutableArray *percentArray = [NSMutableArray array];
        // 统计角度值数组
        __block NSMutableArray *angleArray = [NSMutableArray array];
        __block NSMutableArray *colorArray = [NSMutableArray arrayWithObjects:[UIColor redColor], [UIColor blueColor], [UIColor purpleColor], [UIColor darkGrayColor], [UIColor cyanColor], [UIColor greenColor], nil];
        for (int i = 0; i < dataSource.count; i++) {
            //统计百分比
            __block CGFloat percent = [[dataSource objectAtIndex:i] floatValue] / totalData;
            [percentArray addObject:[NSNumber numberWithFloat:percent]];
            //统计角度值
            __block CGFloat angle = Angle(percent);
            [angleArray addObject:[NSNumber numberWithFloat:angle]];
        }
        
        __block CGFloat endAngle = 0.0;
        __block CGFloat startAngle = 0.0;
        
        
        // 1. 绘制扇形 动画每一块饼都一起开始
//        // 绘制弧度大小
//        for (int i = 0; i < angleArray.count; i++) {
//            __block CGFloat duringAngle = [[angleArray objectAtIndex:i] floatValue];
//            //计算开始弧度
//            startAngle = endAngle;
//            //计算结束弧度
//            endAngle = startAngle + duringAngle;
//
//            
//            //创建一条绘图路径
//            CGMutablePathRef piePath = CGPathCreateMutable();
//            
//            CAShapeLayer *pieLayer = [CAShapeLayer layer];
//            //设置填充线的宽度
//            pieLayer.lineWidth = pieRadius * 2;
//            pieLayer.fillColor = nil;
//            //设置绘制的颜色
//#warning by shi 没有改变颜色
//            UIColor *color = [colorArray objectAtIndex:i];
//            pieLayer.strokeColor = color.CGColor;
//            [[colorArray objectAtIndex:i] setStroke];
//            
//            // CGPathAddArc 通过圆心和半径定义一个圆，然后通过两个弧度确定一个弧线 (弧度事宜当前坐标环境X轴开始的)
//            /**
//             * param1: peiPath 绘图路径
//             * param2: &CGAffineTransformIdentity 还原到进行动画之前的状态
//             * param3: self.center.x 中心点 x轴坐标
//             * param4: self.center.y 中心点 y轴坐标
//             * param5: self.pieRadius 饼状图半径
//             * param6: startAngle 开始角度
//             * param7: endAngle 结束角度
//             * param8: NO 是否是顺时针方向, NO 顺时针, YES 逆时针
//             */
//            CGPathAddArc(piePath, &CGAffineTransformIdentity, 165, 175, pieRadius, startAngle, endAngle, NO);
//            
//            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//            //设置绘制动画持续的时间
//            pathAnimation.duration = 2;
//            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//            //是否翻转绘制
//            pathAnimation.autoreverses = NO;
//            pathAnimation.fillMode = kCAFillModeForwards;
//            pieLayer.path = piePath;
//            [pieLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
//            [self.layer addSublayer:pieLayer];
//        }
        
        // 2. 绘制扇形, 一只笔直接画到尾，每一部分都是不同颜色
        
        CAShapeLayer *chartLayer = [CAShapeLayer layer];
        chartLayer.backgroundColor = [UIColor clearColor].CGColor; //没变化!!!!!
        [self.layer addSublayer:chartLayer];
        
        
        
        for (int i = 0; i < angleArray.count; i++) {
            __block CGFloat duringAngle = [[angleArray objectAtIndex:i] floatValue];
            //计算开始弧度
            startAngle = endAngle;
            //计算结束弧度
            endAngle = startAngle + duringAngle;
            
            CAShapeLayer *pathLayer = [CAShapeLayer layer];
            pathLayer.lineCap = kCALineCapButt;
            UIColor *color = [colorArray objectAtIndex:i];
            pathLayer.fillColor = color.CGColor;
//            pathLayer.strokeColor = color.CGColor;
            pathLayer.strokeColor = [UIColor clearColor].CGColor;
            pathLayer.lineWidth = pieRadius;//80
//            pathLayer.strokeStart = 0.0;
//            pathLayer.strokeEnd = 1.0;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(165, 175)];// 写这个不需要半径／2，layer的fillcolor根据数组取，strokeColor必须clear Color
            [path addArcWithCenter:CGPointMake(165, 175) radius:pieRadius startAngle:startAngle endAngle:endAngle clockwise:YES]; //no只画了2个
            pathLayer.path = path.CGPath;
            
//            CGMutablePathRef path = CGPathCreateMutable();
//            CGPathMoveToPoint(path, &CGAffineTransformIdentity, 165, 175); // 写这个不需要半径／2，layer的fillcolor根据数组取，strokeColor必须clear Color
//            CGPathAddArc(path, &CGAffineTransformIdentity, 165, 175, pieRadius, startAngle, endAngle, NO);
//            pathLayer.path = path;
            
            [chartLayer addSublayer:pathLayer];
            
#pragma mark path存储数组
//            [self.pathArray addObject:(__bridge id _Nonnull)(path)];//CGMutablePathRef
            [self.pathArray addObject:path];//UIBezierPath
            
        }
        
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
//        CGFloat maskStarAngle = -(CGFloat)(M_PI) / 2;
//        CGFloat maskEndAngle = (CGFloat)(M_PI) * 2 - (CGFloat)(M_PI) / 2;
//        [maskPath addArcWithCenter:CGPointMake(165, 175) radius:pieRadius / 2 startAngle:maskStarAngle endAngle:maskEndAngle clockwise:YES];
        [maskPath addArcWithCenter:CGPointMake(165, 175) radius:pieRadius / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.lineCap = kCALineCapButt;
        maskLayer.fillColor = [UIColor clearColor].CGColor;
        maskLayer.strokeColor = [UIColor grayColor].CGColor; //不清楚,遮盖物,除了clear,其他都会显示圆
        maskLayer.lineWidth = pieRadius + 1.0;
//        maskLayer.strokeStart = 0.0;
//        maskLayer.strokeEnd = 1.0;

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 2;
        animation.fromValue = [NSNumber numberWithFloat:1];
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.autoreverses = NO;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [maskLayer addAnimation:animation forKey:@"strokeAn"];
        maskLayer.path = maskPath.CGPath;
        [self.layer addSublayer:maskLayer];
//        self.layer.mask = maskLayer;//可以加，背景变白
        
    } else if (self.baseType == BasePathType) {
        
        CGContextRef currentTcx = UIGraphicsGetCurrentContext();
        CGMutablePathRef path = CGPathCreateMutable();
/*
 *传入CGPathMoveToPoint等过程的NULL参数代表一个既定的变换，在给定的路径绘制线条时可以使用此变换。
*/
        CGPathMoveToPoint(path, NULL, 10, 300);
        CGPathAddLineToPoint(path, NULL, 200, 300);
        CGPoint point = CGPointMake(5, 7);
        [[UIColor blueColor] setStroke];
        if (CGPathContainsPoint(path, NULL, point, NO)) {
            NSLog(@"point in path");
        }
        CGPathCloseSubpath(path);
        CGContextAddPath(currentTcx, path);//将path加到画布上
        CGContextStrokePath(currentTcx);//最终还是显示在画布上
        CGPathRelease(path);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSUInteger selectedIndex = -1;
    
    NSLog(@"pieLayers.count ==%zd", self.pathArray.count);
    [self.pathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGMutablePathRef path = (__bridge CGMutablePathRef)obj;
//        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, point, 0)) {
//            selectedIndex = idx;
//        }
        
        UIBezierPath *path = (UIBezierPath *)obj;
        if ([path containsPoint:point]) {
            selectedIndex = idx;
        }
        
    }];
    
    NSLog(@"selectedIndex --- %zd",selectedIndex);
    
}

/**
 *  @author li_yong
 *
 *  UILabel的工厂方法
 *
 *  @param centerPoint   label的中心
 *  @param bounds        label的大小
 *  @param labelText     label的内容
 *  @param textAlignment label的内容排版方式
 *
 *  @return
 */
- (UILabel *)createLabelWithCenter:(CGPoint)centerPoint
                        withBounds:(CGRect)bounds
                          withText:(NSString *)labelText
                 withtextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.center = centerPoint;
    label.bounds = bounds;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = textAlignment;
    label.text = labelText;
    return label;
}

@end
