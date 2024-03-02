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
VERSION=17
TAG=$(date +%F)
MYHUBID=dataeditors
MYIMG=stata${VERSION}
STATALIC="$(pwd)/stata.lic.${VERSION}"
```

where the Stata license file has been copied to the local directory and called `stata.lic.17` for version 17.

### Build the image

The Dockerfile relies on BuildKit syntax, for passing the license information.

> You may need to first authenticate to Docker to run this: `docker login`

Use the following if you just want to rebuild the Docker image (will re-use key cached information):

```
DOCKER_BUILDKIT=1 docker build  . \
  --secret id=statalic,src="$STATALIC" \
  -t $MYHUBID/${MYIMG}:$TAG
```

or, if updating Stata, use the following, which will force an update through Stata:

```
DOCKER_BUILDKIT=1 docker build  . \
  --secret id=statalic,src=stata.lic.${VERSION} \
  --build-arg CACHEBUST=$(date +%s) \
  -t $MYHUBID/${MYIMG}:$TAG
```
> NOTE: Updating Stata actually doesn't work.

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

Using a pre-built image on [Docker Hub](https://hub.docker.com/u/dataeditors) to run a program. 

> NOTE: because Stata is proprietary software, we need to mount a license file. 

> NOTE: We are using a working directory of "/code" here - check the [Dockerfile](Dockerfile) for the precise location.


For all the subsequent `docker run` commands, we will use similar environment variables:

```
VERSION=17
TAG=2024-02-13
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

where again, the various forms of `STATALIC` are meant to capture the location of the `stata.lic` file (in my case, it is called `stata.lic.17`, but in your case, it might be simply `stata.lic`). 

### To enter interactive stata

```
docker run -it --rm \
  -v "${STATALIC}":/usr/local/stata/stata.lic \
  -v "$(pwd)/code":/code \
  -v "$(pwd)/data":/data \
  -v "$(pwd)/results":/results \
  $MYHUBID/${MYIMG}:${TAG}
```

### Aside: Using other container management software

The above builds and runs the container using Docker. While there is a free Community Edition of Docker, others may prefer to use one of the other container management software, such as [Podman](https://podman.io/) or [Singularity](https://sylabs.io/guides/latest/user-guide/). For instance, in Singularity, the following works:

```
singularity run  \
  -B ${STATALIC}:/usr/local/stata/stata.lic \
  -B $(pwd)/code:/code \
  -B $(pwd)/data:/data \
  -B $(pwd)/results:/results \
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
  -B $(pwd)/code:/code \
  -B $(pwd)/data:/data \
  -B $(pwd)/results:/results \
  -H $(pwd) \
  library://$SYLABSID/$MYHUBID/${MYIMG}:${TAG}
```

without the need to first convert it.

### Running a program

The docker image has a `ENTRYPOINT` defined, which means it will act as if you were running Stata:


```
docker run -it --rm \
  -v ${STATALIC}/stata.lic.${VERSION}:/usr/local/stata/stata.lic \
  -v $(pwd)/code:/code \
  -v $(pwd)/data:/data \
  -v $(pwd)/results:/results \
  $MYHUBID/${MYIMG}:${TAG} -b program.do
```
Your program, of course, should reference the `/data` and `/results` directories:

```
global basedir "/"
global data "${basedir}data"
global results "${basedir}results"
// use "${data}/mydata.dta"
// graph export "${results}/figure1.png"
```

### Using the container to build a project-specific docker image

- Adjust the `setup.do` file - list all packages you want installed permanently. 
- Remember to have the `stata.lic.17` file available
- Start your Dockerfile with (adjust the tag)

```
# syntax=docker/dockerfile:1.2
FROM dataeditors/stata17:2024-02-13
# this runs your code 
COPY code/* /code/
COPY data/* /data/
RUN --mount=type=secret,id=statalic,dst=/usr/local/stata/stata.lic /usr/local/stata/stata-mp do /code/setup.do

USER statauser:stata
# run the master file
ENTRYPOINT ["stata-mp","/code/master.do"]
```

build, and then run this Docker image with

```
docker run --secret id=statalic,src=stata.lic.${VERSION} \
  -v $(pwd)/results:/results  \
  larsvilhuber/greatpaper:2021-06-08
```
and the results of running the code (in `code`) on the data (in `data`) will show up in the `results` folder which is local to your workstation.

