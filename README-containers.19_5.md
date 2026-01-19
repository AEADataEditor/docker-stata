## NOTES 

- Tag `2025-08-13` corresponds to StataNow 19 released on 2025-08-13, using Ubuntu 22.04 as base image.
- Tag `2025-08-14` corresponds to StataNow 19 released on 2025-08-13 as well, but using Ubuntu 24.04 as base image.

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

