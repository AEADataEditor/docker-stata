## NOTES 

- When combining these Stata images with R images, note that R 4.5.0 is the first version using Ubuntu 24.04 as base image. That OS does not have the relevant system libraries (`libtinfo5` in particular) to support running Stata 18. You may need a newer version of Stata, or stick with R 4.4.2 or earlier. (based on our testing).

