---
date: 2026-07-09
---

# Microsoft365DSC Docker Images: How to Use Them

<img src="../../../images/FabienTschanz.jpg" style="width:75px;border-radius:50%;border:3px solid black;float:left;" />
<div style="position:inherit;padding-top:15px;"><span style="float:left;padding-left:15px;"><b>by <a href="https://www.linkedin.com/in/fabien-tschanz">Fabien Tschanz</a><br />
July 9th, 2026</b></span></div>

<br/>
<br/>

## Table of contents

1. [Introduction](#introduction)
2. [Quick prerequisite checklist](#quick-prerequisite-checklist)
3. [Where to find the images](#where-to-find-the-images)
4. [Understanding tags and variants](#understanding-tags-and-variants)
5. [Pull and run examples](#pull-and-run-examples)
6. [General usage guidance](#general-usage-guidance)
7. [Issues, help, and support](#issues-help-and-support)
8. [Wrapping up](#wrapping-up)

## Introduction

Starting with the release `1.26.708.1`, we now publish Microsoft365DSC container images so you can run the tooling in a consistent, repeatable runtime without maintaining a full local PowerShell setup for every machine.

In this post, I will walk through the prerequisites, where the images are published, how tags are built, and how to get support if anything does not work as expected.

## Quick prerequisite checklist

Before using the images, validate the following:

- Docker Engine or Docker Desktop is installed and running.
- You can pull images from Docker Hub (network/proxy/firewall allows access).
- You know which container mode you need:
  - Linux containers for `*-linux` and `*-linux.dev-nightly` tags.
  - Windows containers for `*-windows` and `*-windows.dev-nightly` tags.
- If you use Windows images, your host supports Windows containers (changeable in Docker Desktop).
- You have Microsoft 365 credentials or app-based authentication material available for your scenario.
- You have a local folder ready to mount into the container for exported configuration files and logs.

## Where to find the images

Images are published to Docker Hub under:

`https://hub.docker.com/r/fabientschanz/microsoft365dsc`

You can browse tags here:

`https://hub.docker.com/r/fabientschanz/microsoft365dsc/tags`

We're providing two different flavors of images for each platform:

- Stable images: `*-linux` and `*-windows` tags, which are built from the latest stable release of Microsoft365DSC.
- Development images: `*-linux.dev-nightly` and `*-windows.dev-nightly` tags, which are built from the latest Dev branch of Microsoft365DSC.

## Understanding tags and variants

Each image tag includes:

- The Microsoft365DSC module version.
- The Dockerfile variant suffix.

The format is:

`<moduleVersion>-<variant>`

Examples:

- `1.26.708.1-linux`
- `1.26.708.1-windows`
- `linux.dev-nightly`
- `windows.dev-nightly`

Variants map directly to the four Dockerfiles in the repository:

- `Dockerfile.linux` -> `linux`
- `Dockerfile.linux.dev` -> `linux.dev-nightly`
- `Dockerfile.windows` -> `windows`
- `Dockerfile.windows.dev` -> `windows.dev-nightly`

## Pull and run examples

Replace placeholders in the following examples:

- `<moduleVersion>` with the module version you want to use.

Pull a Linux image:

```bash
docker pull fabientschanz/microsoft365dsc:<moduleVersion>-linux
```

Run PowerShell interactively in Linux container:

```bash
docker run --rm -it \
  -v "$(pwd):/workspace" \
  fabientschanz/microsoft365dsc:<moduleVersion>-linux \
  pwsh
```

Run PowerShell interactively in Windows container:

```powershell
docker run --rm -it `
  -v "${PWD}:C:\workspace" `
  fabientschanz/microsoft365dsc:<moduleVersion>-windows `
  pwsh
```

Example command once inside the container:

```powershell
Get-Module Microsoft365DSC -ListAvailable
```

## General usage guidance

- Pin exact tags in automation (`1.26.708.1-linux`) to ensure reproducibility.
- Avoid `latest` style assumptions for production pipelines, even though it refers to the latest stable Windows build.
- Keep authentication secrets outside the image and pass them at runtime.
- Use volume mounts for artifacts (exports, logs, generated files) so data persists after container exit.
- Match container OS to your host/container mode.
- Use the `.dev` variants when you need the development-focused image flavor.

## Issues, help, and support

If you hit a bug or unexpected behavior:

- Open an issue: `https://github.com/Microsoft365DSC/Microsoft365DSC/issues`
- Include:
  - The full image tag you used.
  - Host OS and Docker version.
  - Whether you ran Linux or Windows containers.
  - Repro steps and complete error output.

For general project documentation and guidance:

- `https://microsoft365dsc.com`

## Wrapping up

These images make it easier to run Microsoft365DSC in a consistent environment across workstations and pipelines. If you pin your tags and choose the right variant for your platform, you get predictable and repeatable results with minimal setup effort.
