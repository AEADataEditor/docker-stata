# Docker image basic Stata image

## Purpose

This Docker image is meant to isolate and stabilize a STATA environment, and should be portable across
multiple operating system

> NOTE: The image created by these instructions contains binary code that is &copy; Stata. Permission was granted by Stata to Lars Vilhuber to post these images, without the license. A valid license is necessary to build and use these images. 

## Requirements

You need a Stata license to run the image. If rebuilding, may need Stata license to build the image.

## Versions

Version 18 exists in two versions:

- Regular `STATA 18`
- Continuously updated `STATANOW 18.5`

Unfortunately, it wasn't immediately clear which version was being updated. The images here are currently commingled, for historical reasons and not to break things:

| Tag | Stata version | `born_date` | Note |
| --- | --- | --- | --- |
| `2024-04-04` | 18 | 04 Apr 2024 | |
| `2024-04-30` | 18 | 30 Apr 2024 | Last update of Stata 18 here! |
| `2024-06-25` | 18.5 | 25 Jun 2024 | First version of StataNow 18.5  |
| `2024-08-07` | 18.5 | 07 Aug 2024 | |
| `2024-09-04` | 18.5 | 04 Sep 2024 | |
| `2024-10-16` | 18.5 | 16 Oct 2024 | |



I will shortly restart the versioning of Stata 18 versions as well.


## For more information

See <https://github.com/AEADataEditor/docker-stata> on how to run this, who builds this, and other information.
