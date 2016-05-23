# AutoThumbnail plugin for Movable Type

This is a plugin that automatically generates thumbnail images for Movable Type.

## Requirements

* Movable Type 6.2 or later

## Installation

To install JP Address, follow these steps:

1. Download & unzip the file
2. place the `mt-static/plugins/AutoThumbnail` directory into your `/path/to/mt/mt-static` directory
3. place the `plugins/AutoThumbnail` directory into your `/path/to/mt/plugins` directory

### Notice:

After the update is necessary to re-setting of the suffix in the plug-in configuration of the system.

## AutoThumbnail Overview

* Generating a thumbnail image to upload the original image to the same directory
* You can specify the suffix in the system of the plug-in settings
* You can specify options of the thumbnail image in the blog plug-in settings

### Setting Info

In the blog plug-in settings, you can specify the five items to raise then separated by commas.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>Resize criteria</td>
    <td>String</td>
    <td><tt>Widtd</tt> or <tt>Height</tt></td>
    <td></td>
  </tr>
  <tr>
    <td>Size</td>
    <td>Number</td>
    <td>Number of pixels</td>
    <td></td>
  </tr>
  <tr>
    <td>Conversion to square</td>
    <td>Number</td>
    <td>
      <tt>1</tt> or <tt>0</tt><br>
      If necessary a square thumbnail image, please set the <tt>1</tt>.
    </td>
    <td></td>
  </tr>
  <tr>
    <td>JPEG Quality</td>
    <td>Number</td>
    <td><tt>0</tt> - <tt>100</tt></td>
    <td>If empty, and then set the <a href="https://www.movabletype.jp/documentation/appendices/config-directives/imagequalityjpeg.html" target="_blank">ImageQualityJpeg</a>.</td>
  </tr>
  <tr>
    <td>PNG Quality</td>
    <td>Number</td>
    <td><tt>0</tt> - <tt>9</tt></td>
    <td>If empty, and then set the <a href="https://www.movabletype.jp/documentation/appendices/config-directives/imagequalitypng.html" target="_blank">ImageQualityPng</a>.</td>
  </tr>
</table>

#### Setting an example

On the basis of the width to generate a thumbnail image of 400px.
The quality of the images, JPEG is 75, PNG is 6.

`Width,400,0,75,6`

## AutoThumbnail Changelog

### 0.2.0 -- 2016.05.23

* Up to five generate a thumbnail image
* Specify the quality of the thumbnail image

### 0.1.2 -- 2016.05.23

* indent charactor converted
* add README.md / LICENSE.txt

### 0.1.1 -- 2011.06.29

* Initial release

Brought to you by [Toru Kokubun](https://github.com/dreamseeker)
