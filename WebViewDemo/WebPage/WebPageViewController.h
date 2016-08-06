//
//  LicenseViewController.h
//  Cycling
//
//  Created by lll on 16/8/6.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Common.h"
#import <JavaScriptCore/JavaScriptCore.h>
//首先创建一个实现了JSExport协议的协议
@protocol JSObjectProtocol <JSExport>

//结束
-(void)onFinish;

@end


@interface JsObject : NSObject<JSObjectProtocol>

@end



@interface WebPageViewController : UIViewController<UIWebViewDelegate>
/**
 *  设置标题和内容
 *
 *  @param title 标题
 *  @param url   地址
 *  @param html  .html文件名称，url为空时使用
 */
- (void)setTitleAndContent:(NSString*)title url:(NSString*)url html:(NSString*)html;


/**
 *  设置没有头部的webPage 页面
 *
 *  @param url 地址
 */
- (void)setPageNoHeaderWithUrl:(NSString*)url;

@end
