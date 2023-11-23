# Docker image basic Stata image

For complete information, see [https://github.com/AEADataEditor/docker-stata](https://github.com/AEADataEditor/docker-stata).

## Stata in Docker

This Docker image is meant to serve as a basis for reproducible and automatable work using Stata. 

> NOTE: The image created by these instructions contains binary code that is &copy; Stata. Permission was granted by Stata to Lars Vilhuber to post these images, without the license. A valid license is necessary to use these images. 

## Requirements

You need a Stata license to run the image.
See [https://github.com/AEADataEditor/docker-stata](https://github.com/AEADataEditor/docker-stata) for full instructions.

## Structure

The images are split into several components. The list below shows relative sizes.

### Base image

The base image serves all other images, but is not useful on its own - it does not contain any of the various Stata binaries. 

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
dataeditors/stata18-base  test  90364eb9a9d9  9 minutes ago   795MB
```

### Minimal command line images

These images have only the relevant command line binaries. They are fully functional, but contain no documentation or help files, and are meant to be used for automation. A license appropriate for each version is necessary: Basic Edition (`be`), Standard Edition (`se`), and MP-Parallel Edition (`mp`). 

> NOTE: these images were built with the 32-core edition. They have not been tested with lower-core-count licenses. Please provide feedback if they do not work.


```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
dataeditors/stata18-mp    test  4c1580c00abd  9 minutes ago   1.18GB
dataeditors/stata18-se    test  662e2d09026e  9 minutes ago   1.12GB
dataeditors/stata18-be    test  5f87e594ddbf  9 minutes ago   1.12GB
```

### Command line images for interactive development

These images have help files, and are suitable for interactive development, for instance by inclusion in JupyterLab or in on-demand cloud instances.  They use the non-`i` versions (above) as the basis, and simply add a layer with the help files.


```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
dataeditors/stata18-mp-i  test  642e4a006672  9 minutes ago   1.41GB
dataeditors/stata18-se-i  test  76786bda8680  9 minutes ago   1.32GB
dataeditors/stata18-be-i  test  f5600d1fe84d  9 minutes ago   1.32GB
```

### Interactive with GUI

The GUI (`X`) variants start with the `-i` variant, and add the `x` binaries. They are complete, but the container is NOT COMPLETE and will not work without additional installation of X11 libraries. If you do not know what I'm talking about do not use them AT ALL. If you do, then use these images in the `FROM` statement of a Dockerfile or Singularity image, then add all the necessary libraries.


```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
dataeditors/stata18-mp-x  test  2fbc841cba25  9 minutes ago   1.92GB
dataeditors/stata18-se-x  test  dedf75051503  9 minutes ago   1.76GB
dataeditors/stata18-be-x  test  07b1b687e984  9 minutes ago   1.76GB
```

## Accessing the images

You can browse all provided images at [https://hub.docker.com/u/dataeditors](https://hub.docker.com/u/dataeditors).



