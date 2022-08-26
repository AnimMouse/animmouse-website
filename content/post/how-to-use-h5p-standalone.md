---
title: How to Use H5P Standalone
date: 2021-11-05T16:59:05+08:00
lastmod: 2022-08-24T22:39:00+08:00
tags:
  - tutorials
---
Created an H5P Module and you want it to host for free without using CMS?\
You can now host your H5P module on your website or host it on free static hosting like GitHub Pages or Cloudflare Pages.

## Hosting on your website
1. Download the latest release of [tunapanda/h5p-standalone](https://github.com/tunapanda/h5p-standalone/releases).
2. Extract it to your website root directory.
3. Rename the extension of your H5P module from `.h5p` file to `.zip`.
4. Extract the `.zip` file contents into your `h5p-folder` folder inside of your website root directory.
5. Add this code on the `<head>` of your website. This will load the scripts for H5P Standalone.
```
<link type="text/css" rel="stylesheet" media="all" href="./dist/styles/h5p.css" />
<script type="text/javascript" src="./dist/main.bundle.js"></script>
```
6. Place this code on where do you want to put the H5P player on the `<body>` of your website.
```
<div id="h5p-container"></div>
<script type="text/javascript">
  const {
    H5P
  } = H5PStandalone;
  new H5P(document.getElementById('h5p-container'), {
    h5pJsonPath: 'h5p-folder',
    frameJs: './dist/frame.bundle.js',
    frameCss: './dist/styles/h5p.css'
  });
</script>
```
7. The H5P Standalone will now show in the webpage you placed the code.

## Hosting standalone on free static hosting
This is an [example H5P Standalone hosted on GitHub Pages](https://github.com/AnimMouse/h5p-standalone-gh-pages-example)
You can view [here](https://h5p-standalone.44444444.xyz) the website.

1. Create a repository in GitHub.
2. Clone your repository.
3. Download the latest release of [tunapanda/h5p-standalone](https://github.com/tunapanda/h5p-standalone/releases).
4. Extract it to your repository.
5. Rename the extension of your H5P module from `.h5p` file to `.zip`.
6. Extract the `.zip` file contents into your `h5p-folder` folder inside of your repository.
7. Create an HTML file named `index.html` and add this code:
```
<!DOCTYPE html>
<html>

<head>
  <title> Your H5P Standalone Website Title </title>
  <link type="text/css" rel="stylesheet" media="all" href="./dist/styles/h5p.css" />
  <meta charset="utf-8" />
  <script type="text/javascript" src="./dist/main.bundle.js"></script>
</head>

<body>
  <div id="h5p-container"></div>
  <script type="text/javascript">
    const {
      H5P
    } = H5PStandalone;
    new H5P(document.getElementById('h5p-container'), {
      h5pJsonPath: 'h5p-folder',
      frameJs: './dist/frame.bundle.js',
      frameCss: './dist/styles/h5p.css'
    });
  </script>
</body>

</html>
```
8. Push it to your repository.
9. Enable GitHub Pages on Settings/Pages.
10. Now your H5P Standalone is now published.

If you want to publish it privately (as GitHub Actions only works on public repositories unless you pay for Pro) use Cloudflare Pages.\
Cloudflare pages works even if your repository is private.\
Or use any kind of static hosting like Netlify, Firebase, Vercel, Google Cloud Storage, Amazon S3, etc.\
Or even publish it in your home.