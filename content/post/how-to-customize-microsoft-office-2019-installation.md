---
title: "How to Customize Microsoft Office 2019 Installation"
description: "Exclude Office apps that you don't need to install"
date: 2020-08-02T00:39:41+08:00
lastmod: 2021-09-08T21:29:00+08:00
tags:
  - Microsoft Office
  - Windows
  - tutorials
---
Because Microsoft Office 2019 does not provide MSI installation, only Click-to-Run (C2R), it requires Office Deployment Tool (ODT) in order for you to customize the installation.

1. Download Office Deployment Tool [here](https://www.microsoft.com/en-us/download/details.aspx?id=49117).
2. Run the file to extract the contents.
3. Go to [Office Customization Tool XML generator](https://config.office.com/) to generate your own config file.
4. Answer the following questions.

If you need to use Professional Plus 2019 Retail, follow this steps because the Office Customization Tool XML generator does not allow to use Professional Plus 2019 Retail, only volume version.

1. Open your generated XML file.
2. Change the product ID to ProPlus2019Retail like this `<Product ID="ProPlus2019Retail" PIDKEY="NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP">`
3. Change the update channel to Monthly (If you need stabilization) or Current (If you need latest bleeding edge) like this `Channel="Monthly"`. For more information, see [Overview of update channels](https://docs.microsoft.com/en-us/deployoffice/overview-update-channels).

In order to install Microsoft Office 2019 using your configuration file.

1. Put your configuration file on the folder where you extracted the deployment tool.
2. Run command prompt on the folder where you extracted the deployment tool.
3. Type `setup /configure config.xml` when config.xml is the filename of the configuration file.

### My Example Config:
This is my configuration for my Microsoft Office 2019\
This installs the fil-ph language of Office.\
This excludes Access, Groove, Lync, OneDrive, OneNote, and Outlook.

```
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