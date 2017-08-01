//
//  CMRamotionBallLayer.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CMCommon.h"
#import "CMRamotionCircleLayer.h"
#import "CMRamotionSpinerLayer.h"

@class CMRamotionCircleLayer;

@interface CMRamotionBallLayer : CALayer

@property (nonatomic, weak) UIScrollView *scroll;
@property (nonatomic, assign) CFTimeInterval upDuration;
@property (nonatomic, assign) CGFloat moveUpDist;
@property (nonatomic, strong) UIColor *ballColor;

@property (nonatomic, strong) CMRamotionCircleLayer *circleLayer;

- (void)startAnimation;
- (void)endAnimation:(BOOL) animated complition:(CMCompletion) complition;

@end

