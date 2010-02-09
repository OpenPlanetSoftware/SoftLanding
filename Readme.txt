Note:

The instructions below are for integrating this component into your application and taken from our blog post on the subject (http://blog.openplanetsoftware.com/2010/02/providing-soft-landing-with-webkit.html). The blog post also describes the mechanics behind the component, not described here.

INSTRUCTIONS FOR INTEGRATION WITH YOUR APPLICATION:

There are 4 files which you'll need to include in your project:

	src/SoftLanding/OPSSoftLandingWindowController.h
	src/SoftLanding/OPSSoftLandingWindowController.m
	src/SoftLanding/SoftLanding.XIB
	src/SoftLanding/SoftLanding.html

Copy these files to your project and include them in the target. You also need to ensure that your project links with the Webkit framework.

You will need to modify the XIB file to change the text to match your application. There are two places where you need to do this; the title on the Window and the text on the "Show this window" checkbox.

To display the soft landing at startup add the following line at an appropriate location in your code (the applicationDidFinishLaunching: method on your app delegate is probably as good a place as any):

	[OPSSoftLandingWindowController showWithDelegate:self onlyIfRequired:YES];

This method takes two parameters. The first parameter is a delegate object which will handle any notification messages from the JavaScript. The controller expects the delegate to implement the following method:

	- (void)softLandingWindowController:(OPSSoftLandingWindowController*)softLanding didRecieveNotification:(NSString*)notification;

You may pass nil to the delegate if you only want the soft landing to display some HTML and do not have any messages which may be passed back.

If the user selects not to show the soft landing at application startup there is currently no way for them to see it again. This isn't very nice, so you will probably want to add a menu under Help to allow the user to display the welcome screen again.

	- (IBAction)showWelcome:(id)sender
	{
		[OPSSoftLandingWindowController showWithDelegate:self onlyIfRequired:NO];
	}

That's it. All that remains is your customisation of the displayed HTML. If you're unfamiliar with JavaScript you might want to have a look at the sample SoftLanding.html as a starting point. The important point is that the headers (denoted by the h1 tags) are told to call the onClickHandler JavaScript code when the user clicks on them.

	<h1 cocoaTagName="Welcome Clicked" onclick="onClickHandler(event)">Welcome to ShinyApp</h1>

This code then pulls the cocoaTagName attribute from clicked element and passes it on to your application.

The code is distributed under the FreeBSD license (do what you want with it, but don't sue us when it all goes wrong). Enjoy!
