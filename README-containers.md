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
| `2024-04-30` | 18 | 30 Apr 2024 | **Last update of Stata 18 here!** |
| `2024-06-25` | 18.5 | 25 Jun 2024 | First version of StataNow 18.5  |
| `2024-08-07` | 18.5 | 07 Aug 2024 | |
| `2024-09-04` | 18.5 | 04 Sep 2024 | |
| `2024-10-16` | 18.5 | 16 Oct 2024 | |
| `2024-12-18` | 18.5 | 18 Dec 2024 | |

The latest (and last, see below) Stata 18 (not NOW) is 

| Tag | Stata version | `born_date` | Note |
| --- | --- | --- | --- |
| `2025-02-26` | 18 | February 26, 2025 | |


## Splitting images for better manageability


Going forward, I will be using the `split` Docker images. For Stata 18, this means that there will be multiple images, optimized for the intended use. See <https://hub.docker.com/r/dataeditors/stata18-base> for more information. An equivalent set of splits is available for Stata 18 Now (`18_5`).
  


## Legacy version

- Stata 18 can be found at <https://hub.docker.com/r/dataeditors/stata18>
- StataNow 18.5 can be found at <https://hub.docker.com/r/dataeditors/stata18now>

Versions incorrectly tagged as `stata18` may disappear in the future, please update your pulls if you are using StataNow 18!


## For more information

See <https://github.com/AEADataEditor/docker-stata> on how to run this, who builds this, and other information.
