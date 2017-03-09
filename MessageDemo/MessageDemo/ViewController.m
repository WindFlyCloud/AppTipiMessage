//
//  ViewController.m
//  MessageDemo
//
//  Created by WindXu on 17/3/7.
//  Copyright © 2017年 YJKJ-CaoXu. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@property (weak ,nonatomic) IBOutlet UITextField * phoneTextField;

@property (weak ,nonatomic) IBOutlet UITextField * messageBody;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
/** 点击发送短信按钮*/
- (IBAction)sendMessageBut:(id)sender {
    /** 如果可以发送文本消息(不在模拟器情况下*/
//    if ([MFMessageComposeViewController canSendText]) {
//        /** 创建短信界面(控制器*/
//        MFMessageComposeViewController *controller = [MFMessageComposeViewController new];
//        controller.recipients = @[self.phoneTextField.text];//短信接受者为一个NSArray数组
//        controller.body = self.messageBody.text;//短信内容
//        controller.attachments = @[];
//        controller.messageComposeDelegate = self;//设置代理,代理可不是 controller.delegate = self 哦!!!
//        /** 取消按钮的颜色(附带,可不写) */
//        controller.navigationBar.tintColor = [UIColor redColor];
//        [self presentViewController:controller animated:YES completion:nil];
//    }else{
//        NSLog(@"模拟器不支持发送短信");
//    }
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    //Get Image From URLhttp://img3.imgtn.bdimg.com/it/u=881987044,3685698069&fm=23&gp=0.jpg
    UIImage * imageFromURL = [self getImageFromURL:@"http://img3.imgtn.bdimg.com/it/u=881987044,3685698069&fm=23&gp=0.jpg"];
    
    //Save Image to Directory
    [self saveImage:imageFromURL withFileName:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
    
    //Load Image From Directory
//    UIImage * imageFromWeb = [self loadImage:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
//    [img setImage:imageFromWeb];
    
    //取得目录下所有文件名
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
    //NSLog(@"%d",[file count]);
    NSLog(@"%@",file);
    
    //如何获取下载的文件的完整路径?
    

}
#pragma mark - MFMessageComposeViewControllerDelegate
/**
 *  协议方法,在信息界面处理完信息结果时调用(比如点击发送,取消发送,发送失败)
 *
 *  @param controller 信息控制器
 *  @param result     返回的信息发送成功与否状态
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    /** 发送完信息就回到原程序*/
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"发送取消");
        default:
            break;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTextField resignFirstResponder];
    [_messageBody resignFirstResponder];
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
    NSURL * imageUrl = [NSURL fileURLWithPath:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]]];
    if ([MFMessageComposeViewController canSendAttachments]) {
        /** 创建短信界面(控制器*/
        MFMessageComposeViewController *controller = [MFMessageComposeViewController new];
        controller.recipients = @[self.phoneTextField.text];//短信接受者为一个NSArray数组
        controller.body = self.messageBody.text;//短信内容
        if ([controller addAttachmentURL:imageUrl withAlternateFilename:nil]) {
            NSLog(@"添加成功");
        }else{
            NSLog(@"失败");
        }
        controller.messageComposeDelegate = self;//设置代理,代理可不是 controller.delegate = self 哦!!!
        /** 取消按钮的颜色(附带,可不写) */
        controller.navigationBar.tintColor = [UIColor redColor];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSLog(@"模拟器不支持发送短信");
    }
}


-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
