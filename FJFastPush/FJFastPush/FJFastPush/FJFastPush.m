//
//  FJFastPush.m
//  FJFastPush
//
//  Created by wangfj on 2017/8/9.
//  Copyright © 2017年 FJFastPush. All rights reserved.
//

#define FJ_IS_KIND_OF(obj, cls) [(obj) isKindOfClass:[cls class]]

#define FJ_IS_MEMBER_OF(obj, cls) [(obj) isMemberOfClass:[cls class]]

// (is main thread)判断是否主线程
#define FJ_IS_MAIN_THREAD                [NSThread isMainThread]

// (run in main thread)使block在主线程中运行
#define FJ_RUN_MAIN_THREAD(block)    if (FJ_IS_MAIN_THREAD) {(block);} else {dispatch_async(dispatch_get_main_queue(), ^{(block);});}


#if DEBUG

#define FJ_LOG(...) NSLog(__VA_ARGS__)

#define FJ_ASSERT(obj)               assert((obj))

#define FJ_ASSERT_CLASS(obj, cls)  FJ_ASSERT((obj) && FJ_IS_KIND_OF(obj,cls))//断言实例有值和类型


#else

#define FJ_LOG(...)

#define FJ_ASSERT(obj)

#define FJ_ASSERT_CLASS(obj, cls)

#endif

#import "FJFastPush.h"
@interface FJFastPush ()

@end

@implementation FJFastPush


#pragma mark - push & pop
+(UIViewController *)pushVCWithClassName:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated
{
    //创建当前类并加入属性
    UIViewController *ret = [[self  class] createVC:vcClassName withParams:params];
    
    FJ_ASSERT(ret);
    
    FJ_LOG(@"push class is-----%s",object_getClassName(ret));
    
    if (ret) {
        [[self class] pushVC:ret animated:animated];
    }
    
    return (ret);
}

+ (UIViewController *)createVC:(NSString *)className withParams:(NSDictionary *)params;
{
    FJ_ASSERT_CLASS(className, NSString);
    
    if (!FJ_IS_KIND_OF(className, NSString)||className.length==0) {
        FJ_LOG(@"className string error!!!!!-----");
        return nil;
    }
    
    UIViewController *ret = nil;
    NSString *name = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    Class cls = NSClassFromString(name);
    
    if (cls && [cls isSubclassOfClass:[UIViewController class]]) {
        
        // create viewController
        UIViewController *vc = [[cls alloc] init];
        
        // kvc set params;
        ret = [[self class] object:vc kvc_setParams:params];
        
    } else {
        FJ_LOG(@"%@ class not Find!!!!!-----", className);
    }
    return (ret);
}


+ (id)object:(id)object kvc_setParams:(NSDictionary *)params;
{
    if (FJ_IS_KIND_OF(params, NSDictionary) && (params.count>0))
    {
        @try {
            [object setValuesForKeysWithDictionary:params];
        } @catch (NSException *exception) {
            FJ_LOG(@"KVC Set Value For Key error:%@", exception);
        } @finally {
        }
    }
    return object;
}
+ (void)pushVC:(UIViewController *)vc animated:(BOOL)animated
{
    FJ_ASSERT_CLASS(vc, UIViewController);
    
    if (FJ_IS_KIND_OF(vc, UIViewController))
    {
        //find NavigationController
        UINavigationController *navc = [[self class] getCurrentNavC];
        
        if (navc) {
            if (navc.viewControllers.count) {
                vc.hidesBottomBarWhenPushed = YES;
            }
            
            FJ_RUN_MAIN_THREAD([navc pushViewController:vc animated:animated]);
            
        }else
        {
            FJ_LOG(@"no find NavigationController,can not push!!!");
            
            return;
        }
    }
}

+ (void)popToLastVCWithAnimated:(BOOL)animated
{
    UINavigationController *navc = [[self class] getCurrentNavC];
    if (navc && navc.viewControllers.count>1)
    {
        FJ_RUN_MAIN_THREAD([navc popViewControllerAnimated:animated]);
    }
}

+ (void)popToRootVCWithAnimated:(BOOL)animated
{
    UINavigationController *navc = [[self class] getCurrentNavC];
    if (navc && navc.viewControllers.count>1)
    {
        FJ_RUN_MAIN_THREAD([navc popToRootViewControllerAnimated:animated]);
    }
}

+ (void)popToVCAtIndex:(NSInteger)index animated:(BOOL)animated
{
    FJ_ASSERT(index>=0);
    
    UINavigationController *navc = [[self class] getCurrentNavC];
    //导航栈内一定要超过1个vc，否则不能pop
    if (navc && index>=0 && navc.viewControllers.count>1 && navc.viewControllers.count>index)
    {
        //从导航栈顶跳到栈顶不成立，所以返回
        if (navc.viewControllers.count-1==index) {
            FJ_LOG(@"NavigationController.viewcontrollers.cout==1,can not pop!!!");
            return;
        }
        
        UIViewController *obj = [navc.viewControllers objectAtIndex:index];
        
        FJ_ASSERT_CLASS(obj, UIViewController);
        
        if (obj) {
            
            FJ_LOG(@"pop to class is-----%s",object_getClassName(obj));
            
            FJ_RUN_MAIN_THREAD([navc popToViewController:obj animated:animated]);
        }
        else
        {
            FJ_LOG(@"not find vc object,can not pop!!!");
        }
    }
    else
    {
        FJ_LOG(@"can not pop!!!");
    }
}

+ (void)popToVCWithClassName:(NSString *)className animated:(BOOL)animated
{
    FJ_ASSERT_CLASS(className, NSString);
    
    if (!FJ_IS_KIND_OF(className, NSString)||className.length==0) {
        FJ_LOG(@"className string error!!!!!-----");
        return;
    }
    NSString *name = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    Class cls = NSClassFromString(name);
    
    if (!cls || ![cls isSubclassOfClass:[UIViewController class]])
    {
        FJ_LOG(@"%@ class not Find!!!!!-----", className);
        return;
    }
    
    UINavigationController *navc = [[self class] getCurrentNavC];
    
    //导航栈内一定要超过1个vc，否则不能pop
    if (navc && navc.viewControllers.count>1)
    {
        NSArray *vcArr = navc.viewControllers;
        
        for (UIViewController *vcobj in vcArr) {
            
            FJ_ASSERT_CLASS(vcobj , UIViewController);
            
            if (FJ_IS_MEMBER_OF(vcobj, cls)) {
                
                FJ_LOG(@"pop to class is-----%@",className);
                
                FJ_RUN_MAIN_THREAD([navc popToViewController:vcobj animated:animated]);
                return;
            }
        }
    }
}

#pragma mark - present & dismiss

+(UIViewController *)presentViewController:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated
{
    //创建当前类并加入属性
    UIViewController *ret = [[self  class] createVC:vcClassName withParams:params];
    
    UIViewController *topVC = [[self class] topVC];
    
    FJ_ASSERT(ret);
    
    FJ_LOG(@"present class is-----%s",object_getClassName(ret));
    
    if (ret && topVC) {
        FJ_RUN_MAIN_THREAD([topVC presentViewController:ret animated:animated completion:nil]);
    }
    
    return  ret;
}

+ (void)dismissVCAnimated:(BOOL)animated
{
    UIViewController *vc = [[self class] getPresentingVC];
    if (vc)
    {
        FJ_RUN_MAIN_THREAD([vc dismissViewControllerAnimated:animated completion:nil]);
    }
}


+(UIViewController *)getPresentingVC
{
    UIViewController *ret = nil;
    UIViewController *topVC = [[self class] topVC];
    if (topVC.presentingViewController) {
        ret = topVC.presentingViewController;
    }
    
    if (!ret) {
        
        if (topVC.navigationController) {
            UIViewController *tempVC  =  topVC.navigationController.presentingViewController;
            
            if (tempVC) {
                ret = tempVC;
            }
        }
    }
    
    FJ_ASSERT_CLASS(ret, UIViewController);
    
    return ret;
}

#pragma mark - get NavC
+(UINavigationController *)getCurrentNavC
{
    UINavigationController *navc = [[self class] topVC].navigationController;
    
    FJ_ASSERT_CLASS(navc, UINavigationController);
    
    return (FJ_IS_KIND_OF(navc, UINavigationController) ? navc : nil);
}

+ (UIViewController *)topVC
{
    UIViewController *ret = nil;
    UIViewController *vc = [[self class] rootVC];
    while (vc) {
        ret = vc;
        if (FJ_IS_KIND_OF(ret, UINavigationController))
        {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if (FJ_IS_KIND_OF(ret, UITabBarController))
        {
            vc = [(UITabBarController *)vc selectedViewController];
        } else
        {
            vc = [vc presentedViewController];
        }
    }
    
    FJ_ASSERT_CLASS(ret, UIViewController);
    
    return (FJ_IS_KIND_OF(ret, UIViewController) ? ret : nil);
}

+ (UIViewController *)rootVC
{
    UIViewController  *vc = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    if (!vc) {
        
        NSArray *arr = [[UIApplication sharedApplication] windows];
        
        if (arr && arr.count) {
            UIWindow *window = [arr objectAtIndex:0];
            if (window.rootViewController) {
                vc = window.rootViewController;
            }
        }
    }
    
    FJ_ASSERT(vc);
    
    return (vc);
}

@end
