//
//  RegisterViewController.m
//  caijing
//
//  Created by Cina on 8/21/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "RegisterViewController.h"
#import "Tools.h"
#import "DataPostURL.h"
#import "ASIRequestHttpController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize mBackgroundImage;
@synthesize mTableView;
@synthesize mMovingView;
@synthesize mNavigationBar;

-(void)goPreviousController:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) animationFinished
{
    //进入主视图时的水波纹动画
    //    CATransition *animation=[CATransition animation];
    //    animation.delegate=self;
    //    animation.duration=3.0f;
    //    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    //    animation.type=@"rippleEffect";
    //    [[self.view layer] addAnimation:animation forKey:@"animation"];
}

-(void) MoveViewTopWhenEditing:(id) sender
{
    CGRect rect = mMovingView.frame;
    rect.origin.y = 20- 100;
    [UIView beginAnimations:@"WhenEditing" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    // start display with animation
    mMovingView.frame = rect;
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void) MoveViewBottonWhenFinishEditing:(id) sender
{
    CGRect rect = mMovingView.frame;
    rect.origin.y = 20;
    [UIView beginAnimations:@"FinishEditing" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    // start display with animation
    mMovingView.frame = rect;
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}


-(void)goRegister:(id)sender
{
    UITableViewCell *cellEmail = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cellUserName = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cellPassword = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITableViewCell *cellPasswordConfirm = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    UITextField *email = (UITextField*)[cellEmail.contentView viewWithTag:111];
    UITextField *userName = (UITextField*)[cellUserName.contentView viewWithTag:111];
    UITextField *password = (UITextField*)[cellPassword.contentView viewWithTag:111];
    UITextField *passwordConfirm = (UITextField*)[cellPasswordConfirm.contentView viewWithTag:111];
    
    [email resignFirstResponder];
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [passwordConfirm resignFirstResponder];
    [self MoveViewBottonWhenFinishEditing:nil];
    
    NSString *userNameText = [userName.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!userNameText || [userNameText isEqualToString:@""] || !email.text || [email.text isEqualToString:@""] || !password.text || [password.text isEqualToString:@""]||  !passwordConfirm.text || [passwordConfirm.text isEqualToString:@""]) {
        [Tools showAlert:@"您输入的信息有误"];
    }else
    {
        if (![passwordConfirm.text isEqualToString:password.text]) {
            [Tools showAlert:@"密码输入不一致"];
            return;
        }

        NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:userNameText,@"username",password.text,@"password",email.text,@"email",[[NSDate date]description],@"date",[NSString stringWithFormat:@"%d", arc4random()%2],@"sex",nil];
        [ASIRequestHttpController postMethodPath:KFunctionRegister parameters:dictionry success:^(id responseObj) {
            [self goPreviousController:nil];
        } failure:^(id responseObject) {
            if ([responseObject valueForKey:@"result"]) {
                [Tools showAlert:[[responseObject valueForKey:@"result"] valueForKey:@"message"]];
            }else
                [Tools showAlert:@"注册失败"];
        }];
        
        //        NSString *finalPassword = [Tools urlencode:[Tools stringWithMD5Hash:password.text]];
//        finalPassword = [finalPassword stringByAppendingString:@"%0A"];
//
//        NSString *keywords = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",Get_Keywords(@"user_type",@"c"), Get_Keywords(KAccount,userNameText),Get_Keywords(KPassword,finalPassword),Get_Keywords(@"nike",userNameText),Get_Keywords(@"email",email.text),Get_Keywords(@"phone",@"13800000000"),Get_Keywords(@"userid",@"1111111111")];
        
//        DataPostURL *getData = [[[DataPostURL alloc]initWithPost:keywords :@"user_regist"] autorelease];
//        getData.delegate = self;
//        getData.Selector = @selector(whenFinished:);
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cellPassword = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    [self MoveViewTopWhenEditing:nil];
    if ([textField isDescendantOfView:cellPassword.contentView]) {
        [textField setReturnKeyType:UIReturnKeyGo];
    }else
        [textField setReturnKeyType:UIReturnKeyNext];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cellPassword = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if([string isEqualToString:@"\n"] && ([textField isDescendantOfView:cellPassword.contentView])) {
        [textField resignFirstResponder];
        [self MoveViewBottonWhenFinishEditing:nil];
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    mBackgroundImage = nil;
    mTableView = nil;
    mMovingView = nil;
    mNavigationBar = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [mBackgroundImage release];
    [mTableView release];
    [mMovingView release];
    [mNavigationBar release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    }
    
    UITextField *textfield;
    if (![cell.contentView viewWithTag:111]) {
        textfield = [[[UITextField alloc]initWithFrame:CGRectMake(5, 10, 200, 30)] autorelease];
        [textfield setAutocorrectionType:UITextAutocorrectionTypeNo];
        textfield.borderStyle = UITextBorderStyleNone;
        textfield.tag = 111;
        textfield.delegate = self;
        [cell.contentView addSubview:textfield];
    }
    textfield = (UITextField *)[cell.contentView viewWithTag:111];
    
    switch (indexPath.row) {
        case 0:
            textfield.placeholder = @"邮箱";
            break;
        case 1:
            textfield.placeholder = @"用户名";
            break;
        case 2:
            textfield.placeholder = @"密码";
            [textfield setSecureTextEntry:YES];
            break;
        case 3:
            textfield.placeholder = @"再次输入密码";
            [textfield setSecureTextEntry:YES];
            break;
            
        default:
            break;
    }
	return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
