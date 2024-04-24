# Docker image basic Stata image

## Purpose

This Docker image is meant to isolate and stabilize that environment, and should be portable across
multiple operating system, as long as [Docker](https://docker.com) is available.

> To learn more about the use of containers for research reproducibility, see [Carpentries' docker-introduction](https://carpentries-incubator.github.io/docker-introduction/index.html). For commercial services running containers, see [codeocean.com](https://codeocean.com), [gigantum](https://gigantum.com/), or any of the cloud service providers. For an academic project using containers, see [Whole Tale](https://wholetale.org/).

> NOTE: The image created by these instructions contains binary code that is &copy; Stata. Permission was granted by Stata to Lars Vilhuber to post these images, without the license. A valid license is necessary to build and use these images. 

## Requirements

You need a Stata license to run the image. If rebuilding, may need Stata license to build the image.

### Where should you put the Stata license

In the documentation below, we will use a (bash) environment variable to abstract from the actual location of the Stata license. This has been tested on MacOS and Linux, and it *should* work using Git Bash on Windows. Comments welcome.

## Dockerfile

The [Dockerfile](Dockerfile) contains the build instructions. A few things of note:



## Build

### Set up a few things

Set the `TAG` and `IMAGEID` accordingly. `VERSION` should be the Stata version.

```
VERSION=18
TAG=$(date +%F)
MYHUBID=dataeditors
MYIMG=stata${VERSION}
```


### Build the image

Basic image building is easy:

```
DOCKER_BUILDKIT=1 docker build  . \
  -t $MYHUBID/${MYIMG}:$TAG
```


This will generate a lot of output, and may take a while:

```
[+] Building 4.7s (17/17) FINISHED                                              
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 37B                                        0.0s
...
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:2dc159dee0413040c99b02f885eb7a6559b647cd6e86a  0.0s
 => => naming to docker.io/dataeditors/stata17:2022-02-09                  0.0s
```

List your images:

```
docker images 
```
output:
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              52e8f83a14f8        25 seconds ago      665MB
<none>              <none>              fb095c3f9ade        31 minutes ago      670MB
<none>              <none>              a919483dbe22        34 minutes ago      107MB
```

## Publish the image 

The resulting docker image can be uploaded to [Docker Hub](https://hub.docker.com/), if desired, or any other of the container registries. 


```
docker push $MYHUBID/${MYIMG}:$TAG
```

We can browse the provided images at [https://hub.docker.com/u/dataeditors](https://hub.docker.com/u/dataeditors):

![Screenshot of repository for dataeditors](assets/docker-hub-dataeditors.png)


## Using the image

### Directory structure

In the following, we are going to assume that your project has the following directory structure, and simplify the directory mounts:

```
project/
   data/
   code/
      01_preparedata.do
      02_runanalysis.do
   results/
   main.do
   setup.do
```

`setup.do` installs all required Stata ado packages via the necessary commands (`ssc install`, `net install pkg, from(url)`). `main.do` is the main controller script, which here resides in the root directory of the project. Other options are possible. We will run all commands with the working directory set to `/path/to/project`. When NOT using Docker, you can achieve the same goal by double-clicking `main.do`, which will automatically set the working directory to where `main.do` resides.

### Using pre-built images

Using a pre-built image on [Docker Hub](https://hub.docker.com/u/dataeditors) to run a program. 

> NOTE: because Stata is proprietary software, we need to mount a license file. 

> NOTE: We are using a working directory of "/project" here - check the [Dockerfile](Dockerfile) for the precise location.


For all the subsequent `docker run` commands, we will use similar environment variables:

```
VERSION=18
TAG=2024-02-14
MYHUBID=dataeditors
MYIMG=stata${VERSION}
```

and either

``` 
STATALIC="$(pwd)/stata.lic.${VERSION}"
```

or

```
STATALIC="$(find $HOME/Dropbox/ -name stata.lic.$VERSION | tail -1)"
```

where again, the various forms of `STATALIC` are meant to capture the location of the `stata.lic` file (in my case, it is called `stata.lic.18`, but in your case, it might be simply `stata.lic`). 

### To enter interactive stata

```
docker run -it --rm \
  -v "${STATALIC}":/usr/local/stata/stata.lic \
  -v "$(pwd)":/project \
  $MYHUBID/${MYIMG}:${TAG}
```

### Aside: Using other container management software

The above builds and runs the container using Docker. While there is a free Community Edition of Docker, others may prefer to use one of the other container management software, such as [Podman](https://podman.io/) or [Singularity](https://sylabs.io/guides/latest/user-guide/). For instance, in Singularity, the following works:

```
singularity run  \
  -B ${STATALIC}:/usr/local/stata/stata.lic \
  -B $(pwd):/project \
  -H $(pwd) \
  docker://$MYHUBID/${MYIMG}:${TAG}
```

We have also converted the Docker image to a Singularity Image File (SIF), 

```
sudo singularity build stata${VERSION}.sif docker-daemon://${MYHUBID}/${MYIMG}:${TAG}
```

and uploaded the resultant SIF file to the Sylabs.io servers ([library/vilhuberlars/dataeditors/stata17](https://cloud.sylabs.io/library/vilhuberlars/dataeditors/stata17)), so it can be used directly in a way similar to DockerHub:

```
SYLABSID=vilhuberlars
singularity run  \
  -B ${STATALIC}:/usr/local/stata/stata.lic \
  -B $(pwd):/project \
  -H $(pwd) \
  library://$SYLABSID/$MYHUBID/${MYIMG}:${TAG}
```

without the need to first convert it.


### Running a program

The docker image has a `ENTRYPOINT` defined, which means it will act as if you were running Stata:

```bash
cd /path/to/project
docker run -it --rm \
  -v ${STATALIC}/stata.lic.${VERSION}:/usr/local/stata/stata.lic \
  -v $(pwd):/project \
  -w /project \
  $MYHUBID/${MYIMG}:${TAG} -b program.do
```
Your program, of course, should reference the `/data` and `/results` directories, ideally in a location-agnostic manner:

```
// we start in the rootdir
// Note: we could double-check that we are in the right directory:
// confirm file "main.do"
global rootdir : pwd
global data "${rootdir}data"
global results "${rootdir}results"
// all subsequent use references the globals
use "${data}/mydata.dta"
graph export "${results}/figure1.png"
```


### Using the container to build a project-specific docker image

- Adjust the `setup.do` file - list all packages you want installed permanently. 
- Remember to have the `stata.lic.17` file available
- Start your Dockerfile with (adjust the tag)

```
# syntax=docker/dockerfile:1.2
FROM dataeditors/stata18:2024-02-14
# this runs your setup code 
COPY code/setup.do setup.do
RUN --mount=type=secret,id=statalic,dst=/usr/local/stata/stata.lic /usr/local/stata/stata-mp do /setup.do

USER statauser:stata
VOLUME /project
WORKDIR /project
# run the master file
ENTRYPOINT ["stata-mp","/code/master.do"]
```

build, and then run this Docker image with

```
docker run \
  -v ${STATALIC}/stata.lic.${VERSION}:/usr/local/stata/stata.lic \
  -v $(pwd):/project \
  larsvilhuber/greatpaper:2021-06-08 -b main.do
```
and the results of running the code (in `code`) on the data (in `data`) will show up in the `results` folder which is local to your workstation, with no need to install any additional Stata packages.
