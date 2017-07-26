//
//  CMRamotionBallLayer.m
//  CMRefresh
//
// *********************************************
// *                                           *
// *         ▄▄▄▄▄▄ ▄▄▄  ▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄   *
// *       ████████████ ▐████████▄ ▐████████   *
// *      █████▌   ▀▀▀▀  ▐███▀████▄███▐████    *
// *     ▐█████          ▐███ ███████ ▐████    *
// *      █████▌   ████  ▐███  █████  ▐████    *
// *       ▀██████████   █████  ███  ▐██████   *
// *          ▀▀▀▀▀      ▀▀▀▀    ▀    ▀▀▀▀▀▀   *
// *                                           *
// *********************************************
//
//  GitHub  : https://github.com/chucklab
//  Homepage: http://blog.chucklab.com
//
//
//  Created by Chuck MA on 07/10/2017.
//  Copyright © 2017 Chuck Lab. All rights reserved.
//

#import "CMRamotionBallLayer.h"
#import "CMCommon.h"

static CFTimeInterval UpDuration = 0.5;

@interface CMRamotionBallLayer ()

@end

@implementation CMRamotionBallLayer

- (instancetype)initWithFrame:(CGRect) frame duration:(CFTimeInterval) duration moveUpDist:(CGFloat) moveUpDist color:(UIColor *) color {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    UpDuration = duration;
    self.frame = frame;
    self.circleLayer = [[CMCircleLayer alloc] initWithMoveUpDist: moveUpDist
                                                           frame: CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                           color: color];
    [self addSublayer: self.circleLayer];
    
    return self;
}

- (void)dealloc {
    MLog(@"[CMRamotionBallLayer] --> dealloc");
    [self endAnimation: NO complition: nil];
}

#pragma mark - Getters & Setters
- (void)setFrame:(CGRect)frame {
    [super setFrame: frame];

    self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)startAnimation {
    [self.circleLayer startAnimation];
}

- (void)endAnimation:(BOOL) animated complition:(CMCompletion) complition {
    [self.circleLayer endAnimation: animated complition: complition];
}

@end

@interface CMCircleLayer () <CAAnimationDelegate>

@property (nonatomic, strong) CMSpinerLayer *spiner;
@property (nonatomic, copy) CMCompletion didEndAnimation;

@end

@implementation CMCircleLayer

- (instancetype)initWithMoveUpDist:(CGFloat) moveUpDist frame:(CGRect) frame color:(UIColor *) color {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    MLog(@"[CMCircleLayer] --> initWithSize: %@", @(size));
    
#if 1
    CGFloat circleWidth = MIN(frame.size.width, frame.size.height);
    self.moveUpDist = moveUpDist;
    self.spiner = [[CMSpinerLayer alloc] initWithFrame: /*CGRectMake(0, 0, frame.size.height, frame.size.height)*/frame
                                                 color: color];
    
    [self addSublayer:self.spiner];
    
    CGFloat radius = circleWidth * 0.5;
    self.frame = frame;
    CGPoint center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    CGFloat startAngle = 0 - M_PI_2;
    CGFloat endAngle = M_PI * 2 - M_PI_2;
    BOOL clockwise = YES;
    self.path = [UIBezierPath bezierPathWithArcCenter: center
                                               radius: radius
                                           startAngle: startAngle
                                             endAngle: endAngle
                                            clockwise: clockwise].CGPath;

    self.fillColor = [color colorWithAlphaComponent:1].CGColor;
    self.strokeColor = self.fillColor;
    self.lineWidth = 0;
    self.strokeEnd = 1;
    self.hidden = YES;
#endif
    
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer: layer];
    if (self == nil) {
        return nil;
    }
    
    MLog(@"[CMCircleLayer] --> initWithLayer");
    
    return self;
}

- (void)dealloc {
    MLog(@"[CMCircleLayer] --> (%@) --> dealloc", self);
    [self endAnimation: NO complition: nil];
}

#pragma mark - Getters & Setters
- (void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    
    self.spiner.frame = frame;
    
    CGFloat circleWidth = MIN(frame.size.width, frame.size.height);
    CGFloat radius = circleWidth * 0.5;
    CGPoint center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    CGFloat startAngle = 0 - M_PI_2;
    CGFloat endAngle = M_PI * 2 - M_PI_2;
    BOOL clockwise = YES;
    self.path = [UIBezierPath bezierPathWithArcCenter:center
                                               radius:radius
                                           startAngle:startAngle
                                             endAngle:endAngle
                                            clockwise:clockwise].CGPath;
}

- (void)startAnimation {
#if 1
    self.hidden = NO;
    [self moveUp: self.moveUpDist];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(UpDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.spiner) {
            [self.spiner animation];
        }
    });
#endif
}

- (void)endAnimation:(BOOL) animated complition:(CMCompletion) complition {
#if 1
    if (self.spiner) {
        [self.spiner stopAnimation];
    }
    
    if (animated) {
        [self moveDown:self.moveUpDist];
        self.didEndAnimation = complition;
    } else {
        if (complition) {
            complition();
        }
    }
    
#endif
}

- (void)moveUp:(CGFloat) distance {
#if 1
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    
    move.fromValue = [NSValue valueWithCGPoint:self.position];
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - distance)];
    
    move.duration = UpDuration;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self addAnimation: move forKey: move.keyPath];
#endif
}

- (void)moveDown:(CGFloat) distance {
#if 1
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    
    move.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - distance)];
    move.toValue = [NSValue valueWithCGPoint:self.position];
    
    move.duration = UpDuration;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    move.delegate = self;
    [self addAnimation: move forKey: move.keyPath];
#endif
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
#if 1
    //ULog(@"[CMCircleLayer] --> animationDidStop");
    if (flag) {
        if (self.didEndAnimation) {
            self.didEndAnimation();
        }
    }
#endif
}

@end

@interface CMSpinerLayer () <CAAnimationDelegate>
@end

@implementation CMSpinerLayer

- (instancetype)initWithFrame:(CGRect) frame color:(UIColor *) color {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    MLog(@"[CMSpinerLayer] --> initWithFrame: %@", NSStringFromCGRect(frame));
    
    self.frame = frame;
    CGFloat circleWidth = MIN(frame.size.width, frame.size.height);
    CGFloat radius = (circleWidth * 0.5) * 1.2;
    CGPoint center = CGPointMake(frame.size.width * 0.5, frame.origin.y + frame.size.height * 0.5);
    CGFloat startAngle = 0 - M_PI_2;
    CGFloat endAngle = M_PI * 2 - M_PI_2 + M_PI * 0.125;
    BOOL clockwise = YES;
    self.path = [UIBezierPath bezierPathWithArcCenter: center
                                               radius: radius
                                           startAngle: startAngle
                                             endAngle: endAngle
                                            clockwise: clockwise].CGPath;
    
    self.fillColor = nil;
    self.strokeColor = color.CGColor;
    self.lineWidth = 2;
    self.lineCap = kCALineCapRound;
    
    self.strokeStart = 0;
    self.strokeEnd = 0;
    self.hidden = YES;
    
    return self;
}

- (void)dealloc {
    MLog(@"[CMSpinerLayer] --> dealloc");
    [self stopAnimation];
}

#pragma mark - Getters & Setters
- (void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    
    CGFloat circleWidth = MIN(frame.size.width, frame.size.height);
    CGFloat radius = (circleWidth * 0.5) * 1.2;
    CGPoint center = CGPointMake(frame.size.width * 0.5, frame.origin.y + frame.size.height * 0.5);
    CGFloat startAngle = 0 - M_PI_2;
    CGFloat endAngle = M_PI * 2 - M_PI_2 + M_PI * 0.125;
    BOOL clockwise = YES;
    self.path = [UIBezierPath bezierPathWithArcCenter: center
                                               radius: radius
                                           startAngle: startAngle
                                             endAngle: endAngle
                                            clockwise: clockwise].CGPath;
}

- (void)animation {
    self.hidden = NO;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @0;
    rotate.toValue = @(M_PI * 2);
    rotate.duration = 1;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount = HUGE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = NO;
    [self addAnimation:rotate forKey:rotate.keyPath];
    
    [self strokeEndAnimation];
}

- (void)strokeEndAnimation {
    CABasicAnimation *endPoint = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endPoint.fromValue = @0;
    endPoint.toValue = @1;
    endPoint.duration = 1.8;
    endPoint.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    endPoint.repeatCount = HUGE;
    endPoint.fillMode = kCAFillModeForwards;
    endPoint.removedOnCompletion = NO;
    endPoint.delegate = self;
    [self addAnimation:endPoint forKey:endPoint.keyPath];
}

- (void)strokeStartAnimation {
    CABasicAnimation *startPoint = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startPoint.fromValue = @0;
    startPoint.toValue = @1;
    startPoint.duration = 0.8;
    startPoint.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    startPoint.repeatCount = HUGE;
    startPoint.delegate = self;
    [self addAnimation:startPoint forKey:startPoint.keyPath];
 
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.isHidden) {
        return;
    }
    
    CABasicAnimation *a = (CABasicAnimation *)anim;
    if ([a.keyPath isEqualToString:@"strokeStart"]) {
        [self strokeEndAnimation];
    } else if ([a.keyPath isEqualToString:@"strokeEnd"]) {
        [self strokeStartAnimation];
    }
}

- (void)stopAnimation {
    self.hidden = YES;
    [self removeAllAnimations];
}

@end
