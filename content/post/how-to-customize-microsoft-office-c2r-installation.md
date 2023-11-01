---
title: How to Customize Microsoft Office C2R Installation
description: Exclude Office apps that you don't need to install
date: 2020-08-02T00:39:41+08:00
lastmod: 2022-05-04T22:35:00+08:00
tags:
  - Microsoft Office
  - Windows
  - tutorials
---
Microsoft Office 2019 and up (including 2021) does not provide MSI installation, only Click-to-Run (C2R), it requires Office Deployment Tool (ODT) in order for you to customize the installation.

## Office Deployment Tool setup
1. Download Office Deployment Tool [here](https://www.microsoft.com/en-us/download/details.aspx?id=49117).
2. Run the file to extract the contents.
3. Go to [Office Customization Tool XML generator](https://config.office.com) to generate your own configuration file.
4. Answer the following questions on the Office Customization Tool XML generator.

If you are using Retail IMG, you need to convert the generated XML file to Retail, as the Office Customization Tool XML generator does not allow you to select Retail version, only volume version.

## Volume to Retail
1. Open your generated XML file.
2. Change the Product tag's ID and PIDKEY attribute.
   1. For Microsoft Office 2021, change the Product tag to `<Product ID="ProPlus2021Retail" PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">`.
   2. For Microsoft Office 2019, change the Product tag to `<Product ID="ProPlus2019Retail" PIDKEY="NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP">`.
3. Change the Channel attribute to Monthly or Current. (PerpetualVL channel does not work on Retail.)
   1. For Monthly for stability, change the Channel attribute to `Channel="Monthly"`.
   2. For Current for the latest features, change the Channel attribute to `Channel="Current"`.

In order to install Microsoft Office using your configuration file.

## Microsoft Office installation
1. Put your configuration file on the folder where you extracted the deployment tool.
2. Run command prompt on the folder where you extracted the deployment tool.
3. Type `setup /configure config.xml` where config.xml is the filename of the configuration file.

## My example configuration
My configuration file installs the fil-ph language of Office, excludes Access, Groove, Lync, OneDrive, OneNote, and Outlook (as I don't need them) and uses the `E:\` path for the installer, as I mounted the IMG file on Windows.

### Microsoft Office 2021
```xml
<Configuration ID="6201bc15-4b3b-44e0-8bb7-0283ecf3e589">
  <Info Description="Install Office 2021" />
  <Add OfficeClientEdition="64" Channel="Monthly" SourcePath="E:\" AllowCdnFallback="TRUE">
    <Product ID="ProPlus2021Retail" PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">
      <Language ID="en-us" />
      <Language ID="fil-ph" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="PinIconsToTaskbar" Value="FALSE" />
  <Property Name="FORCEAPPSHUTDOWN" Value="FALSE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Property Name="AUTOACTIVATE" Value="0" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <Display Level="Full" AcceptEULA="TRUE" />
  <Logging Level="Off" />
</Configuration>
```

### Microsoft Office 2019
```xml
<Configuration ID="bd799f92-6cef-4fbe-955c-b7e82ede914a">
  <Info Description="Install Office 2019" />
  <Add OfficeClientEdition="64" Channel="Monthly" SourcePath="E:\" AllowCdnFallback="TRUE">
    <Product ID="ProPlus2019Retail" PIDKEY="NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP">
      <Language ID="en-us" />
      <Language ID="fil-ph" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="PinIconsToTaskbar" Value="FALSE" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Property Name="AUTOACTIVATE" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="FALSE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <Display Level="Full" AcceptEULA="TRUE" />
  <Logging Level="Off" />
</Configuration>
```