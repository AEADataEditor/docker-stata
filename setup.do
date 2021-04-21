/* setup.do */
sysdir

/* add packages to the macro */

* *** Add required packages from SSC to this list ***
    local ssc_packages "estout"

    // local ssc_packages "estout boottest"
    
    if !missing("`ssc_packages'") {
        foreach pkg in `ssc_packages' {
            dis "Installing `pkg'"
            ssc install `pkg', replace
        }
    }

    * Install packages using net
    *  net install yaml, from("https://raw.githubusercontent.com/gslab-econ/stata-misc/master/")
    
/* other commands */

/* after installing all packages, it may be necessary to issue the mata mlib index command */
	mata: mata mlib index


set more off, perm


