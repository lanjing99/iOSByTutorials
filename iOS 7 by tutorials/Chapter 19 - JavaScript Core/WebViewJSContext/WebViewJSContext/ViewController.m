//
//  ViewController.m
//  WebViewJSContext
//
//  Created by lanjing on 15/7/14.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+TS_JavaScriptContext.h"
@import JavaScriptCore;

@interface ViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) JSContext *context;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    JSValue *function = self.context[@"startGame"];
//    [function callWithArguments:@[]];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.webView addObserver:self forKeyPath:@"ts_javaScriptContext" options:NSKeyValueObservingOptionNew context:nil];
    

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"ts_javaScriptContext"])
    {
        self.context = self.webView.ts_javaScriptContext;
        [self loadJavaScript];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadJavaScript
{
    // Do any additional setup after loading the view, typically from a nib.
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"js"];
    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
    [self.context evaluateScript:scriptString];
    
    //    __weak ViewController *weakSelf = self;
    self.context[@"print"] = ^(NSString *text){
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@\n", text]);
        
    };
}

-(JSContext *)context
{
    if(!_context)
    {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

-(UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        _webView.delegate = self;
    }
    return _webView;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.context = webView.ts_javaScriptContext;
//    [self loadJavaScript];
    [webView stringByEvaluatingJavaScriptFromString:@"print('this is me')"];
}

@end
