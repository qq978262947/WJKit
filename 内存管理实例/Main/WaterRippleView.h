//
//  WaterRippleView.h
//  student
//
//  Created by 汪俊 on 2018/4/27.
//

#import <UIKit/UIKit.h>

/**
 * 水波纹 - 像水波一样的
 * 正弦型函数解析式：y=Asin（ωx+φ）+h
 * 各常数值对函数图像的影响：
 * φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
 * ω：决定周期（最小正周期T=2π/|ω|）
 * A：决定峰值（即纵向拉伸压缩的倍数）
 * h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 */
// CGFloat y = _waveHeight*sinf(2.5*M_PI*i/_waveWidth + 3*_offset*M_PI/_waveWidth + M_PI/4) + _h;
// 照着文档所给出的计算方法，出了对应控件 get新技能
@interface WaterRippleView : UIView

@property (nonatomic, strong) UIColor *waveColor;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetXT;
@property (nonatomic, assign) CGFloat waveSpeed;
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat waveWidth;
@property (nonatomic, assign) CGFloat waveAmplitude;

@end
