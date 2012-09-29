
// BSD License. <jano@jano.com.es>

#import "ARViewController.h"


@implementation ARViewController

@synthesize addressTextField, searchButton;
@synthesize filterModeControl;


/**
 * Decode the address, create the picker, add the overlay, presetModalViewController, start sensors updates.
 */
-(IBAction) search {
    trace(@"search");
    CLLocation *targetLocation = [[Geocoding singleton] geocodeAddress:self.addressTextField.text];
    
    BOOL locationIsValid = targetLocation!=nil;
    if (locationIsValid){
        if ([Hardware isAvailableAR]){
            // launch the AR view
            trace(@"launch the AR view");
            ARPickerController *arPickerController = [[ARPickerController alloc] init];
            arPickerController.targetLocation = targetLocation;
            
            switch (filterModeControl.selectedSegmentIndex) {
                case 0:
                    arPickerController.lowPassFilterMode = kNoFilter;                    
                    break;
                case 1:
                    arPickerController.lowPassFilterMode = kFilter;
                    break;
                case 2:
                    arPickerController.lowPassFilterMode = kAdaptiveFilter;
                    break;
                default:
                    warn(@"shouldn't happen");
                    break;
            }

            arPickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentModalViewController:arPickerController animated:NO];
        } else {
            // device is not AR capable, show a hud warning
            warn(@"device is not AR capable");
        }
    }
}



#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [self.addressTextField release];
    [self.searchButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    trace(@"Waiting for an address...");
    [self performSelector:@selector(search) withObject:nil afterDelay:1];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
