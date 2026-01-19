## NOTES 

- When combining these Stata images with R images, note that R 4.5.0 is the first version using Ubuntu 24.04 as base image. That OS does not have the relevant system libraries (`libtinfo5` in particular) to support running Stata 18. You may need a newer version of Stata, or stick with R 4.4.2 or earlier. (based on our testing).

- Currently, these images do not have Python installed. If you need Python, the following Dockerfile snippet can be used to add it to any of the images:

```
# Adjust as necessary
FROM dataeditors/stata18-se-i:2026-01-13
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
         python3 \
         pip \
    && rm -rf /var/lib/apt/lists/* \
```

