//
//  WaterRippleView.m
//  student
//
//  Created by 汪俊 on 2018/4/27.
//

#import "WaterRippleView.h"
static CGFloat rubberBandRate(CGFloat offset) {
    
    const CGFloat constant = 0.15f;
    const CGFloat dimension = 10.0f;
    const CGFloat startRate = 0.02f;
    // 计算拖动视图translation的增量比率，起始值为startRate（此时offset为0）；随着frame超出的距离offset的增大，增量比率减小
    // fabs(offset) - 偏移量的绝对值
    CGFloat result = dimension * startRate / (dimension + constant * fabs(offset));
    return result;
}

@interface WaterRippleView ()

@property (nonatomic, strong) CAShapeLayer *waveShapeLayer;
@property (nonatomic, strong) CAShapeLayer *waveShapeLayerT;
@property (nonatomic, strong) CAShapeLayer *waveShapeLayerBoat;
@property (nonatomic, strong) CADisplayLink *waveDisplayLink;

@property (nonatomic, assign) CGFloat preWaveAmplitude;


@property (nonatomic, assign) CGFloat boatCenterX; // 小船的中心点x
@property (nonatomic, assign) CGFloat boatCenterY; // 小船的中心点y
@property (nonatomic, strong) UIImage *boatImage; // 500 * 421 宽高比

@end

@implementation WaterRippleView

#pragma mark - Life style
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUIRelated];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUIRelated];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (_waveWidth == 0) {
        _waveWidth = self.bounds.size.width - _offsetX * 2.0;
    }
    if (_waveHeight == 0) {
        _waveHeight = self.bounds.size.height / 2.0;
    }
    _boatCenterX = _waveWidth / 2.0;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    NSLog(@"boatCenterY:%f", self.boatCenterY);
    [self.boatImage drawInRect:CGRectMake(self.boatCenterX - 12.5, self.boatCenterY - 18, 25, 21)];
}

#pragma mark - private
- (void)initUIRelated {
    
    // 初始化相关参数
    [self configurationCurrentData];
    // 创建layer
    [self wave];
}

- (void)configurationCurrentData {
    _waveColor = [UIColor colorWithRed:67.0f/255.0 green:133.0f/255.0 blue:245.0f/255.0 alpha:0.5];
    _offsetX = 0.0f;
    _offsetXT = 0.0f;
    _waveSpeed = 2.0f;
    _waveHeight = 0.0f;
    _waveWidth = 0.0f;
    _waveAmplitude = 10.0f;
    
    //    交互部分 - 滑动事件 （上下拉改变波动幅度）
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(waterRippleViewDidPan:)];
    [self addGestureRecognizer:panGesture];
}


// 光标的滑动
- (void)waterRippleViewDidPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.preWaveAmplitude = self.waveAmplitude;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGestureRecognizer translationInView:self];
            CGFloat rubberBandedRate = rubberBandRate(translation.y);
            CGFloat offsetDistance = translation.y * rubberBandedRate;
            if (self.waveAmplitude - offsetDistance > 50) { // 波峰-记不清怎么算了
                self.waveAmplitude = 50;
            } else if (self.waveAmplitude - offsetDistance < 2) { // 波谷-记不清怎么算了
                self.waveAmplitude = 2;
            } else {
                self.waveAmplitude -= offsetDistance;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            // 可以分段还原 - 非常缓和
//                self.waveAmplitude = self.preWaveAmplitude;
        }
            break;
            
        default: {
        }
            break;
    }
}


- (void)wave {
    /**
    * 创建两个layer
    */
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor.CGColor;
//    self.waveShapeLayer.strokeColor = self.waveColor.CGColor;
    
    [self.layer addSublayer:self.waveShapeLayer];
    self.waveShapeLayerT = [CAShapeLayer layer];
    self.waveShapeLayerT.fillColor = self.waveColor.CGColor;
//    self.waveShapeLayerT.strokeColor = self.waveColor.CGColor;
    [self.layer addSublayer:self.waveShapeLayerT];
    
    
    self.waveShapeLayerBoat = [CAShapeLayer layer];
//    self.waveShapeLayerBoat.fillColor = self.waveColor.CGColor;
    [self.layer addSublayer:self.waveShapeLayerBoat];
    _boatImage = [UIImage imageNamed:@"boat.jpg"];
    /*
     * CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。我们在应用中创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
    */
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// CADispayLink相当于一个定时器 会一直绘制曲线波纹 看似在运动，其实是一直在绘画不同位置点的余弦函数曲线
- (void)getCurrentWave {
    //随机颜色变化
    self.boatCenterX += self.waveSpeed / 5.0;
    if (self.boatCenterX > self.waveWidth + 10) self.boatCenterX = -12.5;
    // offsetX决定x位置，如果想搞明白可以多试几次
    self.offsetX += self.waveSpeed;
    //声明第一条波曲线的路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始点
    CGPathMoveToPoint(path, nil, 0, self.waveHeight);
//    CGFloat boatCurrentX = self.boatCenterX;
    CGFloat y = 0.f;
    //第一个波纹的公式
    int intBoatCenterX = (int)self.boatCenterX;
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        y = self.waveAmplitude * sin((300 / self.waveWidth) * (x * M_PI / 180) - self.offsetX * M_PI / 270) + self.waveHeight * 1;
        if (intBoatCenterX == x) self.boatCenterY = y;
        CGPathAddLineToPoint(path, nil, x, y);
        x++;
    }
    //把绘图信息添加到路径里
    CGPathAddLineToPoint(path, nil, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    //结束绘图信息
    CGPathCloseSubpath(path);
    self.waveShapeLayer.path = path;
    //释放绘图路径
    CGPathRelease(path);
    /*
    *   第二个
    */
    self.offsetXT += self.waveSpeed;
    CGMutablePathRef pathT = CGPathCreateMutable();
    CGPathMoveToPoint(pathT, nil, 0, self.waveHeight + 100);
    CGFloat yT = 0.f;
    for (float x = 0.f; x <= self.waveWidth ; x++) {
        yT = self.waveAmplitude * 1.6 * sin((260 / self.waveWidth) * (x * M_PI / 180) - self.offsetXT * M_PI / 180) + self.waveHeight;
        CGPathAddLineToPoint(pathT, nil, x, yT-10);
    }
    
    CGPathAddLineToPoint(pathT, nil, self.waveWidth, self.frame.size.height);
    CGPathAddLineToPoint(pathT, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(pathT);
    self.waveShapeLayerT.path = pathT;
    CGPathRelease(pathT);

    
    [self setNeedsDisplay];
//    [self.boatImage drawInRect:CGRectMake(self.boatCenterX - 12.5, self.boatCenterY - 10.5, 25, 21)];
}
// 我们可以看到，两个波曲线不但初相位不同，形成一个落差，而且相位随着时间的改变速度也不同，带来两个波的流速不同的视觉差异。CADisplayLink每帧都会调用wave方法，wave不停的改变着offset的值，也就是改变着初相位，最后形成了波动动画。 


/////////////////////////////////////////////////////////////////////////////////
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
