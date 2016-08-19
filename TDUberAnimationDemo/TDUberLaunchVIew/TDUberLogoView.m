//
//  TDUberLogoView.m
//  TDUberAnimationDemo
//
//  Created by jojo on 16/8/11.
//  Copyright © 2016年 jojo. All rights reserved.
//

#import "TDUberLogoView.h"
#import "TDGlobal.h"

#define kCircleRadius   (self.frame.size.width/2)
#define kSquareLength   (kCircleRadius / 2)
const CGFloat startTimeOffset = 0.7 * kAnimationDuration;
const CGFloat lineWidth = 5.0;;


@interface TDUberLogoView ()

@property (nonatomic, strong) CAShapeLayer   *circleLayer;
@property (nonatomic, strong) CAShapeLayer   *squareLayer;
@property (nonatomic, strong) CAShapeLayer   *lineLayer;
@property (nonatomic, strong) CAShapeLayer   *maskLayer;


@end

@implementation TDUberLogoView{
    CAMediaTimingFunction *_strokeEndTimingFunction;
    CAMediaTimingFunction *_squareLayerTimingFunction;
    CAMediaTimingFunction *_circleLayerTimingFunction;
    CAMediaTimingFunction *_fadeInSquareTimingFunction;
    NSTimeInterval         _beginTime;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPrivateProperty];
        [self.layer addSublayer:self.circleLayer];
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.squareLayer];
        self.layer.mask = self.maskLayer;
    }
    return self;
}

#pragma mark - public method
- (void)startAnimation{
    _beginTime = CACurrentMediaTime();
    self.layer.anchorPoint = CGPointZero;
    
    [self startCircleLayerAnimation];
    [self startLineLayerAnimation];
    [self startSquareLayerAnimation];
    [self startMaskLayerAnimation];
}

#pragma mark - set up method
- (void)setPrivateProperty{
    _strokeEndTimingFunction = [CAMediaTimingFunction functionWithControlPoints:1.0 :0.0 :0.42 :1.0];
    _circleLayerTimingFunction = [CAMediaTimingFunction functionWithControlPoints:.25 :0.0 :0.2 :1.0];
    _squareLayerTimingFunction = [CAMediaTimingFunction functionWithControlPoints:.25 :0.0 :0.45 :1.0];
    _fadeInSquareTimingFunction = [CAMediaTimingFunction functionWithControlPoints:.12 :0.00 :0.75 :1.00];
}
#pragma mark - animation
- (void)startCircleLayerAnimation{
    //stroke end animation
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.timingFunction = _strokeEndTimingFunction;
    strokeEndAnimation.duration = kAnimationDuration - kAnimationDurationDelay;
    strokeEndAnimation.values = @[@0.,@1.];
    strokeEndAnimation.keyTimes = @[@0.0,@1.0];
    
    //transform animation
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunction = _strokeEndTimingFunction;
    transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay;
    //rotation with Z
    CATransform3D startingTransform = CATransform3DMakeRotation( -M_PI_4, 0, 0, 1);
    //scale
    startingTransform = CATransform3DScale(startingTransform, 0.25, 0.25, 1);
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:startingTransform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeEndAnimation, transformAnimation];
    animationGroup.repeatCount = INFINITY;
    animationGroup.duration = kAnimationDuration;
    animationGroup.beginTime = _beginTime;
    animationGroup.timeOffset = startTimeOffset;
    
    [self.circleLayer addAnimation:animationGroup forKey:@"looping"];
    
}

- (void)startLineLayerAnimation{
    //config
    NSArray *timingFunctions = @[_strokeEndTimingFunction, _circleLayerTimingFunction];
    NSArray *keyTimes = @[@0.0, @(1.0-kAnimationDurationDelay/kAnimationDuration),@1.0];

    //line width animation
    CAKeyframeAnimation *lineWidthAnimation = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.values = @[@0.0,@(lineWidth),@0.0];
    lineWidthAnimation.timingFunctions = timingFunctions;
    lineWidthAnimation.duration = kAnimationDuration;
    lineWidthAnimation.keyTimes = keyTimes;
    
    //transform animation
    CATransform3D transform = CATransform3DMakeRotation( -M_PI_4, 0, 0, 1);
    transform = CATransform3DScale(transform, 0.25, 0.25, 1.0);

    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.duration = kAnimationDuration;
    transformAnimation.keyTimes = keyTimes;
    transformAnimation.timingFunctions = timingFunctions;
    transformAnimation.values = @[[NSValue valueWithCATransform3D:transform],
                                  [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(.10, .10, 1.0)]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[lineWidthAnimation, transformAnimation];
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = false;
    animationGroup.duration = kAnimationDuration;
    animationGroup.beginTime = _beginTime;
    animationGroup.timeOffset = startTimeOffset;
    
    [self.lineLayer addAnimation:animationGroup forKey:@"looping"];

}

- (void)startSquareLayerAnimation{
    //config
    NSArray *keyTimes = @[@0.0, @(1.0-kAnimationDurationDelay/kAnimationDuration),@1.0];
    NSArray *timingFunctions = @[_fadeInSquareTimingFunction,_squareLayerTimingFunction];
    CGFloat tempLength = kSquareLength *2/3;
    
    //bounds animation
    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.timingFunctions = timingFunctions;
    boundsAnimation.keyTimes = keyTimes;
    boundsAnimation.duration = kAnimationDuration;
    boundsAnimation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, tempLength, tempLength)],
                               [NSValue valueWithCGRect:CGRectMake(0, 0, kSquareLength, kSquareLength)],
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)]
                               ];
    
    //color animation
    CABasicAnimation *bgColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bgColorAnimation.fromValue = (__bridge id)[UIColor whiteColor].CGColor;
    bgColorAnimation.toValue = (__bridge id)defaultColor.CGColor;
    bgColorAnimation.timingFunction = _squareLayerTimingFunction;
    bgColorAnimation.fillMode = kCAFillModeBoth;
    bgColorAnimation.beginTime = kAnimationDurationDelay * 2 / kAnimationDuration;
    bgColorAnimation.duration = kAnimationDuration / (kAnimationDuration - kAnimationDurationDelay);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[boundsAnimation,bgColorAnimation];
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = false;
    animationGroup.duration = kAnimationDuration;
    animationGroup.beginTime = _beginTime;
    animationGroup.timeOffset = startTimeOffset;
    
    [self.squareLayer addAnimation:animationGroup forKey:@"looping"];
}

- (void)startMaskLayerAnimation{
    //config
    CGFloat tempLength = kSquareLength *2/3;

    //bounds animation
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.duration = kAnimationDurationDelay;
    boundsAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay;
    boundsAnimation.timingFunction = _circleLayerTimingFunction;
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*kCircleRadius, 2*kCircleRadius)];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, tempLength, tempLength)];
    
    //corner radius animation
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadiusAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay;
    cornerRadiusAnimation.duration = kAnimationDurationDelay;
    cornerRadiusAnimation.fromValue = @(kCircleRadius);
    cornerRadiusAnimation.toValue = @0;
    cornerRadiusAnimation.timingFunction = _circleLayerTimingFunction;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[boundsAnimation,cornerRadiusAnimation];
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = false;
    animationGroup.fillMode = kCAFillModeBoth;
    animationGroup.duration = kAnimationDuration;
    animationGroup.beginTime = _beginTime;
    animationGroup.timeOffset = startTimeOffset;
    
    [self.maskLayer addAnimation:animationGroup forKey:@"looping"];
}

#pragma mark - getter

- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.lineWidth = kCircleRadius;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:kCircleRadius/2 startAngle:-M_PI endAngle: M_PI clockwise:YES].CGPath;
    }
    return _circleLayer;
}

- (CAShapeLayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.position = CGPointZero;
        _lineLayer.frame = CGRectZero;
        _lineLayer.allowsGroupOpacity = YES;
        _lineLayer.lineWidth = lineWidth;
        _lineLayer.strokeColor = defaultColor.CGColor;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointZero];
        [bezierPath addLineToPoint:CGPointMake(-kCircleRadius, 0)];
        _lineLayer.path = bezierPath.CGPath;
        
    }
    return _lineLayer;
}

- (CAShapeLayer *)squareLayer{
    if (!_squareLayer) {
        _squareLayer = [CAShapeLayer layer];
        _squareLayer.position = CGPointZero;
        _squareLayer.frame = CGRectMake(- kSquareLength / 2, - kSquareLength / 2, kSquareLength, kSquareLength);
        _squareLayer.cornerRadius = 1.5;
        _squareLayer.allowsGroupOpacity = YES;
        _squareLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _squareLayer;
}

- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = CGRectMake(-kCircleRadius, -kCircleRadius, kCircleRadius*2, kCircleRadius*2);
        _maskLayer.allowsGroupOpacity = YES;
        _maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _maskLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
