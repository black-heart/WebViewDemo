//
//  LicenseViewController.m
//  Cycling
//
//  Created by lll on 16/8/6.
//  Copyright © 2016年 llliu. All rights reserved.
//

#import "WebPageViewController.h"

#define MsgTypeGoBack @"MsgWebPageGoBack"
@implementation JsObject

-(void)onFinish {
    [[NSNotificationCenter defaultCenter] postNotificationName:MsgTypeGoBack object:nil];
}

@end

@interface WebPageViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebPageViewController {
    
    UIActivityIndicatorView* activityIndicator;
    NSString *pageTitle;
    NSString *pageUrl;
    NSString *pageHtml;
    BOOL isNoHeader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:pageTitle];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (pageUrl && [pageUrl compare:@""] != NSOrderedSame) {
        NSURL *webUrl = [NSURL URLWithString:pageUrl];
        NSURLRequest *req = [NSURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [self.webView  loadRequest:req];
    } else {
        NSString* path        = [[NSBundle mainBundle] pathForResource:pageHtml ofType:@"html"];
        NSURL* url            = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
        [self.webView loadRequest:request];

    }
    if (isNoHeader) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:MsgTypeGoBack object:nil];
    }
}

- (void)goBack {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    if (isNoHeader) {
        //[self.navigationController.navigationBar setBarTintColor:CommonColorGreen];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self defaultNavigationBarHidden:YES];

    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (isNoHeader) {
        [self defaultNavigationBarHidden:NO];
    }
    [super viewWillDisappear:animated];
}

- (void)defaultNavigationBarHidden:(BOOL)hidden {
    self.navigationController.navigationBar.hidden = hidden;
}

- (UIWebView*)webView {
    if (_webView == nil) {
        if (isNoHeader) {
//            UIImageView * imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//            [imgHeader setBackgroundColor:CommonColorGreen];
//            [self.view addSubview:imgHeader];
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            _webView.scrollView.bounces = NO;
        } else {
            _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        }

        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

- (void)setTitleAndContent:(NSString*)title url:(NSString*)url html:(NSString*)html {
    
    pageTitle = title;
    pageUrl   = url;
    html      = html;
    
    [self setWebViewCookie:url];
}

- (void)setPageNoHeaderWithUrl:(NSString*)url {

    pageUrl    = url;
    isNoHeader = YES;
}

- (void)setWebViewCookie:(NSString*)url {
    // 从网络模块获取session  设置后可实现 WebView与Network的 session共享
    //NSString* session =  [NetworkRequest getSession];
    NSString* session =  @"example";
    [self deleteCookie:url];
    [self setCookie:url :session];
}

// 网页开始加载的时候调用
- (void )webViewDidStartLoad:(UIWebView  *)webView {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];

    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
}

// 网页加载完成的时候调用
- (void )webViewDidFinishLoad:(UIWebView  *)webView {
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    
    if (isNoHeader) {
        // 网页内可调用  javascript:JsObject.onFinish();
        
        //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
        JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //注入jsObj对象
        JsObject *jsObj=[JsObject new];
        context[@"JsObject"]=jsObj;
    }
    //获取网页中的标题  也可以通过此方法方法调用 网页中的函数
    NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title != nil && ![@"" isEqualToString:title]) {
        self.title = title;
    }
    
}

// 网页加载错误的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

//设置cookie
- (void)setCookie:(NSString*)url :(NSString*)cookieValue {
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    [cookiePropertiesUser setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
    if (cookieValue == nil) {
        cookieValue = @"";
    }
    NSURL *urlObj = [NSURL URLWithString:url];
    if (urlObj == nil) {
        return;
    }
    NSString *domain = urlObj.host;
    [cookiePropertiesUser setObject:cookieValue forKey:NSHTTPCookieValue];
    [cookiePropertiesUser setObject:domain forKey:NSHTTPCookieDomain];
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
    
    // set expiration to one month from now or any NSDate of your choosing
    // this makes the cookie sessionless and it will persist across web sessions and app launches
    /// if you want the cookie to be destroyed when your app exits, don't set this
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}

//清除cookie
- (void)deleteCookie:(NSString*)url {
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if (url == nil) {
        return;
    }
    NSURL *nUrl = [NSURL URLWithString: url];
    if (nUrl == nil) {
        return;
    }
    NSArray *cookieAry = [cookieJar cookiesForURL: nUrl];
    
    for (cookie in cookieAry) {
        
        [cookieJar deleteCookie: cookie];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
