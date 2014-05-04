//
//  LoginViewController.m
//  caijing
//
//  Created by Cina on 8/21/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ASIRequestHttpController.h"

#define TagIndicater_999 999
#define TagBlankView_999 995

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize mBackgroundImage;
@synthesize mTableView;
@synthesize mMovingView;
@synthesize mNavigationBar;

-(void)goRegisterController:(id)sender
{
    RegisterViewController *registerController = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil] autorelease];
    [self presentViewController:registerController animated:YES completion:NULL];
}

-(void)goPreviousController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    rect.origin.y = 100- 100;
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
    rect.origin.y = 100;
    [UIView beginAnimations:@"FinishEditing" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    // start display with animation
    mMovingView.frame = rect;
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)goLoginController:(id)sender
{
    UITableViewCell *cellUserName = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cellPassword = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    UITextField *userName = (UITextField*)[cellUserName.contentView viewWithTag:111];
    UITextField *password = (UITextField*)[cellPassword.contentView viewWithTag:111];
    
    [userName resignFirstResponder];
    [password resignFirstResponder];

    [self MoveViewBottonWhenFinishEditing:nil];
    
    NSString *userNameText = [userName.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if (!userNameText || [userNameText isEqualToString:@""]) {
        [Tools showAlert:@"您输入的用户名有误"];
    }else
    {
     
        //            NSString *finalPassword = [Tools urlencode:[Tools stringWithMD5Hash:password.text]];

//        NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:@"cina1",@"username",@"cina1",@"password",nil];
        NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:userNameText,@"username",password.text,@"password",nil];

        [ASIRequestHttpController postMethodPath:KFunctionLogin parameters:dictionry success:^(id responseObj) {
            
            [UserInfo setSharedUserInfo:[responseObj valueForKey:@"result"]];
            [self goPreviousController:nil];
        } failure:^(id responseObject) {
            if ([responseObject valueForKey:@"result"]) {
                [Tools showAlert:[responseObject valueForKey:@"result"]];
            }else
                [Tools showAlert:responseObject];
        }];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cellPassword = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    if([string isEqualToString:@"\n"] && ([textField isDescendantOfView:cellPassword.contentView])) {
        [textField resignFirstResponder];
        [self goLoginController:nil];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cellUserName = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cellPassword = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [self MoveViewTopWhenEditing:nil];

    if ([textField isDescendantOfView:cellUserName.contentView]) {
        [textField setReturnKeyType:UIReturnKeyNext];
    }else if ([textField isDescendantOfView:cellPassword.contentView])
    {
        [textField setReturnKeyType:UIReturnKeyGo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cell";

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
            textfield.placeholder = @"用户名";
            break;
        case 1:
            textfield.placeholder = @"密码";
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
