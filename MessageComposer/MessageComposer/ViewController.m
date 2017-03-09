//
//  ViewController.m
//  MessageComposer
//
//  Created by WindXu on 17/3/8.
//  Copyright © 2017年 YJKJ-CaoXu. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()<
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate
>
// UILabel for displaying the result of the sending the message.
@property (nonatomic, weak) IBOutlet UILabel *feedbackMsg;
@end

@implementation ViewController

#pragma mark - Rotation

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
// -------------------------------------------------------------------------------
//	shouldAutorotateToInterfaceOrientation:
//  Disable rotation on iOS 5.x and earlier.  Note, for iOS 6.0 and later all you
//  need is "UISupportedInterfaceOrientations" defined in your Info.plist
// -------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

#pragma mark - Actions

// -------------------------------------------------------------------------------
//	showMailPicker:
//  IBAction for the Compose Mail button.
// -------------------------------------------------------------------------------
- (IBAction)showMailPicker:(id)sender
{
    // You must check that the current device can send email messages before you
    // attempt to create an instance of MFMailComposeViewController.  If the
    // device can not send email messages,
    // [[MFMailComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }
    else
        // The device can not send email.
    {
        self.feedbackMsg.hidden = NO;
        self.feedbackMsg.text = @"Device not configured to send mail.";
    }
}

// -------------------------------------------------------------------------------
//	showSMSPicker:
//  IBAction for the Compose SMS button.
// -------------------------------------------------------------------------------
- (IBAction)showSMSPicker:(id)sender
{
    // You must check that the current device can send SMS messages before you
    // attempt to create an instance of MFMessageComposeViewController.  If the
    // device can not send SMS messages,
    // [[MFMessageComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMessageComposeViewController canSendText])
        // The device can send email.
    {
        [self displaySMSComposerSheet];
    }
    else
        // The device can not send email.
    {
        self.feedbackMsg.hidden = NO;
        self.feedbackMsg.text = @"Device not configured to send SMS.";
    }
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Hello from California!"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
    
    // Fill out the email body text
    NSString *emailBody = @"It is raining in sunny California!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an SMS composition interface inside the application.
// -------------------------------------------------------------------------------
- (void)displaySMSComposerSheet
{
    if ([MFMessageComposeViewController canSendAttachments]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        
        // You can specify one or more preconfigured recipients.  The user has
        // the option to remove or add recipients from the message composer view
        // controller.
        /* picker.recipients = @[@"Phone number here"]; */
        
        // You can specify the initial message text that will appear in the message
        // composer view controller.
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
        if ([picker addAttachmentURL:[NSURL fileURLWithPath:path] withAlternateFilename:nil]) {
            NSLog(@"添加成功");
            NSArray * array = picker.attachments;
            NSLog(@"array--%@",array);
        }else{
            NSLog(@"失败");
        }
        
        //http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg
        //        if ([picker addAttachmentURL:[NSURL fileURLWithPath:path] withAlternateFilename:nil]) {
        //            NSLog(@"添加成功");
        //            NSArray * array = picker.attachments;
        //            NSLog(@"array--%@",array);
        //        }else{
        //            NSLog(@"失败");
        //        }
        //- (BOOL)addAttachmentData:(NSData *)attachmentData typeIdentifier:(NSString *)uti filename:(NSString *)filename
//        UIImage * image = [UIImage imageNamed:@"rainy.jpg"];
//        NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
//        if ([picker addAttachmentData:imageData typeIdentifier:@"jpg" filename:@"rainy.jpg"]) {
//            NSLog(@"添加成功");
//        }else {
//            NSLog(@"添加失败");
//        }
        picker.body = @"Hello from California!";
        NSArray * array = picker.attachments;
        NSLog(@"array--%@",array);
        [self presentViewController:picker animated:YES completion:NULL];

    }else{
        NSLog(@"不支持添加附件");
    }
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.feedbackMsg.text = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            self.feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            self.feedbackMsg.text = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            self.feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            self.feedbackMsg.text = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            self.feedbackMsg.text = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            self.feedbackMsg.text = @"Result: SMS sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: SMS not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
