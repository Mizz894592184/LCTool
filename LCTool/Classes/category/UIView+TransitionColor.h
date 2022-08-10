//
//  UIView+TransitionColor.h
//  Pods-LCTool_Example
//
//  Created by Joff on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TransitionColor)

//左右渐变
- (void)addTransitionLeftColor:(UIColor *)startColor endRightColor:(UIColor *)endColor;

//上下渐变
- (void)addTransitionTopColor:(UIColor *)startColor endBottomColor:(UIColor *)endColor;

//斜渐变
- (void)addTransitionColorLeftToRight:(UIColor *)startColor endColor:(UIColor *)endColor;

//自定义位置
- (void)addTransitionColor:(UIColor *)startColor
                  endColor:(UIColor *)endColor
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
