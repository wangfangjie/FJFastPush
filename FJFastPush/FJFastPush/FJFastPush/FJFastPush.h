//
//  FJFastPush.h
//  FJFastPush
//
//  Created by wangfj on 2017/8/9.
//  Copyright © 2017年 FJFastPush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*********************push pop************************/

/**
 Using the macro definition quickly push a VC, traverse the navigation stack find current controller, use the push method of navigation controller, dictionaries can pass parameters, implementation principle is KVC dynamic assignment, and return to push the VC object (default animation)
 
 使用宏定义快速push一个VC，原理是遍历当前控制器的导航栈，使用导航控制器push方法，dict字典里面可以传参数，实现原理是KVC动态赋值，并返回push产生的VC对象（默认有动画）
 
 例如：//FJ_PUSH_VC(@"OtherVC", @{@"titleStr":@"other"});
 
 @param className VC类名
 @param dict      VC所需的参数
 @return 返回VC对象
 */
#define FJ_PUSH_VC(className, dict)               [FJFastPush pushVCWithClassName:className params:(dict) animated:YES]

#define FJ_PUSH_VC_NO_ANIMATED(className, dict)   [FJFastPush pushVCWithClassName:className params:(dict) animated:NO]


/**
 return last VC(default animation)
 返回上一个VC（默认有动画）
 */
#define FJ_POP_TO_LAST_VC               [FJFastPush popToLastVCWithAnimated:YES]

#define FJ_POP_TO_LAST_VC_NO_ANIMATED   [FJFastPush popToLastVCWithAnimated:NO]


/**
 pop to root viewcontroller(default no animation)
 返回到导航栈根视图控制器（默认无动画）
 */
#define FJ_POP_TO_ROOT_VC            [FJFastPush popToRootVCWithAnimated:NO]

#define FJ_POP_TO_ROOT_VC_ANIMATED   [FJFastPush popToRootVCWithAnimated:YES]

/**
 Navigationcontroler pop to the index of (navigationcontroler.viewcontrolers)
 
 导航控制器返回到指定VC对象的方法,通过索引位置找到导航栈内的VC对象并pop（默认无动画）
 
 @param index 导航栈VC元素索引
 */
#define FJ_POP_TO_VC_AT_INDEX(index)             [FJFastPush popToVCAtIndex:(index) animated:NO]

#define FJ_POP_TO_VC_AT_INDEX_ANIMATION(index)   [FJFastPush popToVCAtIndex:(index) animated:YES]


#define FJ_POP_TO_VC_BY_CLASSNAME(className)             [FJFastPush popToVCWithClassName:(className) animated:NO]

#define FJ_POP_TO_VC_BY_CLASSNAME_ANIMATION(className)   [FJFastPush popToVCWithClassName:(className) animated:YES]


/*********************present dismiss************************/

#define FJ_PRESENT_VC(className, dict)          [FJFastPush presentViewController:className params:(dict) animated:YES]

#define FJ_PRESENT_VC_NO_ANIMATED(className, dict)   [FJFastPush presentViewController:className params:(dict) animated:NO]

/**      dismissViewController Animated******/

#define FJ_DISMISS_VC               [FJFastPush dismissVCAnimated:YES]

#define FJ_DISMISS_VC_NO_ANIMATED   [FJFastPush dismissVCAnimated:NO]

/*********************get Navc topVC rootVC************************/

#define FJ_GET_CURRENT_NAVC   [FJFastPush getCurrentNavC]


/**
 Get the current display controller object
 获得当前显示的控制器对象
 
 @return vc object
 */
#define FJ_GET_TOP_VC   [FJFastPush topVC]


/**
 Get rootViewController
 获取APP根视图控制器
 
 @return rootViewController
 */
#define FJ_GET_ROOT_VC   [FJFastPush rootVC]

@interface FJFastPush : NSObject

/**
 创建VC并push到VC
 
 @param vcClassName 要创建VC的类名称
 @param params    传给VC的参数
 @param animated  是否动画
 @return VC对象
 */
+ (UIViewController *)pushVCWithClassName:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated;


/**
 返回上一个VC
 */
+ (void)popToLastVCWithAnimated:(BOOL)animated;

/**
 返回到导航器根视图控制器
 
 @param animated 是否动画
 */
+ (void)popToRootVCWithAnimated:(BOOL)animated;

/**
 导航栈内返回指定位置的方法
 
 @param index    导航栈元素索引
 @param animated 有无动画
 */
+ (void)popToVCAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 导航栈返回到指定输入的类名（带动画），如果一个导航栈里面有多个相同类的VC对象在里面则返回离根部最近的那个VC（导航栈里有相同类的实例对象通常不符合逻辑）
 
 @param className 类名
 @param animated  是否需要动画
 */
+(void)popToVCWithClassName:(NSString*)className animated:(BOOL)animated;


/**
 创建一个VC，并使用KVC赋值，然后弹出
 
 @param vcClassName vc类名
 @param params 赋值参数
 @param animated 是否动画
 @return 返回弹出的VC对象
 */
+(UIViewController *)presentViewController:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated;

/**
 收回弹出的VC
 */
+ (void)dismissVCAnimated:(BOOL)animated;

/**
 Get the current navigation controller by  traversing
 遍历获得当前VC的导航控制器
 
 @return 导航控制器对象
 */
+(UINavigationController *)getCurrentNavC;

/**
 Get the current PresentingViewController by  traversing
 遍历获得弹出当前VC的父VC
 
 @return 导航控制器对象
 */
+(UIViewController *)getPresentingVC;


/**
 Get the current display controller object
 获得当前显示的控制器对象
 
 @return vc object
 */
+ (UIViewController *)topVC;


/**
 Get rootViewController
 获取APP根视图控制器
 
 @return rootViewController
 */
+ (UIViewController *)rootVC;



@end
