//
//  XYPieChart.m
//  CGContent_Demo
//
//  Created by shiyaorong on 15/12/3.
//  Copyright © 2015年 shiyaorong. All rights reserved.
//

#import "XYPieChart.h"

@implementation XYPieChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pieView = [[UIView alloc] initWithFrame:self.bounds];
        [_pieView setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_pieView atIndex:0];
    }
    return self;
}

- (void)refreshData:(NSMutableArray *)angels {
    CALayer *parentLayer = [_pieView layer];
    
    double startToAngle = 0.0;
    double endToAngle = startToAngle;

    [CATransaction begin];//动画开始
    [CATransaction setAnimationDuration:2];//动画时间

    CGFloat startPieAngle = M_PI_2*3;
    
    for(int index = 0; index < angels.count; index ++) //循环5次
    {
        CAShapeLayer *layer = [CAShapeLayer layer];
        double angle = [angels[index] doubleValue]; // 取出弧度值
        endToAngle += angle;
        double startFromAngle = startPieAngle + startToAngle;
        double endFromAngle = startPieAngle + endToAngle;
        
        // 每一个layer都要加一个textLayer
        [layer setZPosition:0];
        [layer setStrokeColor:NULL];
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [[UIScreen mainScreen] scale];//防止像素化
//        CGFontRef font = nil;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//            font = CGFontCreateCopyWithVariations((__bridge CGFontRef)([UIFont boldSystemFontOfSize:0]), (__bridge CFDictionaryRef)(@{}));
//        } else {
//            font = CGFontCreateWithFontName((__bridge CFStringRef)[[UIFont boldSystemFontOfSize:0] fontName]);
//        }
//        
//        [textLayer setFont:font];
//        CFRelease(font);
        
        [textLayer setFontSize:[UIFont boldSystemFontOfSize:30].pointSize];
        [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
        [textLayer setForegroundColor:[UIColor blackColor].CGColor];
        
        //labelShadowColor
//        [textLayer setShadowColor:[UIColor blackColor].CGColor];
//        [textLayer setShadowOffset:CGSizeZero];
//        [textLayer setShadowOpacity:1.0f];
//        [textLayer setShadowRadius:2.0f];
        
//        CGSize size = [@"0" sizeWithFont:[UIFont boldSystemFontOfSize:8]]; // iOS7以前
        CGSize size = [@"10" sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:30]}];//ios 7.0以后
        
        [textLayer setFrame:CGRectMake(0, 0, size.width, size.height)];
        [textLayer setPosition:CGPointMake(150 + (140 / 2) * cos(0), 150 + (140 / 2) * sin(0))];
        [textLayer setString:[NSString stringWithFormat:@"%u", arc4random_uniform(100) + 10]];
        
        [layer addSublayer:textLayer];
        
        startFromAngle = endFromAngle = startPieAngle;
        [parentLayer addSublayer:layer]; // 循环添加layer
        
        // 随机颜色
        UIColor *color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
        [layer setFillColor:color.CGColor];
        
        NSLog(@"111----%f, %f", startFromAngle, startToAngle+startPieAngle);
        
        CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:@"startAngle"];
        NSNumber *currentAngle = [[layer presentationLayer] valueForKey:@"startAngle"];
        if(!currentAngle) currentAngle = [NSNumber numberWithDouble:startFromAngle];
        [arcAnimation setFromValue:currentAngle];
        [arcAnimation setToValue:[NSNumber numberWithDouble:startToAngle+startPieAngle]];
        [arcAnimation setDelegate:self];
        [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [layer addAnimation:arcAnimation forKey:@"startAngle"];
        [layer setValue:[NSNumber numberWithDouble:startToAngle+startPieAngle] forKey:@"startAngle"];
        
        NSLog(@"222----%f, %f", endFromAngle, endToAngle+startPieAngle);

        CABasicAnimation *arcAnimation1 = [CABasicAnimation animationWithKeyPath:@"endAngle"];
        NSNumber *currentAngle1 = [[layer presentationLayer] valueForKey:@"endAngle"];
        if(!currentAngle1) currentAngle1 = [NSNumber numberWithDouble:endFromAngle];
        [arcAnimation1 setFromValue:currentAngle];
        [arcAnimation1 setToValue:[NSNumber numberWithDouble:endToAngle+startPieAngle]];
        [arcAnimation1 setDelegate:self];
        [arcAnimation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [layer addAnimation:arcAnimation1 forKey:@"endAngle"];
        [layer setValue:[NSNumber numberWithDouble:endToAngle+startPieAngle] forKey:@"endAngle"];
        startToAngle = endToAngle;
        
        NSLog(@"333----%f, %f", startToAngle, endToAngle);
        
    }
    [CATransaction setDisableActions:YES];
    
}

#pragma mark - Animation Delegate + Run Loop Timer

- (void)updateTimerFired:(NSTimer *)timer;
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    NSLog(@"＝＝＝%zd", pieLayers.count);
    
    [pieLayers enumerateObjectsUsingBlock:^(CAShapeLayer * obj, NSUInteger idx, BOOL *stop) {
        
        NSNumber *presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
        CGFloat interpolatedStartAngle = [presentationLayerStartAngle doubleValue];
        
        NSNumber *presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
        CGFloat interpolatedEndAngle = [presentationLayerEndAngle doubleValue];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 150, 150); // 先move到中心点，半径不需要除 2
        CGPathAddArc(path, NULL, 150, 150, 140, interpolatedStartAngle, interpolatedEndAngle, 0);
        CGPathCloseSubpath(path);

        [obj setPath:path];
        CFRelease(path);
        
        CALayer *labelLayer = [[obj sublayers] objectAtIndex:0];
        CGFloat interpolatedMidAngle = (interpolatedEndAngle + interpolatedStartAngle) / 2;
        [CATransaction setDisableActions:YES];
        [labelLayer setPosition:CGPointMake((150 + (140 / 2) * cos(interpolatedMidAngle)), (150 + (140 / 2) * sin(interpolatedMidAngle)))];
        [CATransaction setDisableActions:NO];
        
    }];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (_animationTimer == nil) {
        static float timeInterval = 1.0/60.0;
        _animationTimer= [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
    
    [_animations addObject:anim];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)animationCompleted
{
    [_animations removeObject:anim];
    
    if ([_animations count] == 0) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

//一根或多根手指开始触摸view,系统会自动调用view下面的方法:
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

//一根或者多根手指在view上移动，系统会自动调用view下面的方法（随着手指的移动，会持续调用该方法）:
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:_pieView];
}

//一根或者多根手指离开view，系统会自动调用view下面的方法：
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    returnSelectedIndex = [self getCurrentSelectedOnTouch:point];
    NSLog(@"selectedIndex : %zd", returnSelectedIndex);
    
//    self.returnBlock(returnSelectedIndex);
    
    
    // 🎸3.点击传值
//    self.returnBlock(returnSelectedIndex);
    
    
    ReturnSectedBlock(returnSelectedIndex);
}

//触摸结束前，某个系统事件（例如电话呼入）会打断触摸过程，系统会自动调用view下面的方法
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (NSUInteger)getCurrentSelectedOnTouch:(CGPoint)point {
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    NSArray *pieLayers = [[_pieView layer] sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *pieLayer = (CAShapeLayer *)obj;
        CGPathRef path = [pieLayer path]; //获取layer中的path
        if (CGPathContainsPoint(path, &transform, point, 0)) {
            selectedIndex = idx;
            
            //改变当前path的样式
            pieLayer.lineWidth = 3;
            pieLayer.strokeColor = [UIColor whiteColor].CGColor;
            pieLayer.lineJoin = kCALineJoinBevel;
            pieLayer.zPosition = MAXFLOAT; //固定层级
        } else {
            //将其他的path还原
            pieLayer.zPosition = 100;//MAXFLOAT，暂时没发现区别
            pieLayer.lineWidth = 0;
        }
    }];
    return selectedIndex;
}

//- (void)returnSelected:(ReturnSectedBlock)block {
//    self.returnBlock = block;
//}

- (void)returnSelected:(void (^)(NSUInteger))block {
    ReturnSectedBlock = block;
}

@end
