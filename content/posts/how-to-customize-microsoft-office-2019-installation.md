---
title: "How to Customize Microsoft Office 2019 Installation"
date: 2020-08-02T00:39:41+08:00
comments: false
images:
---
Because Microsoft Office 2019 does not provide MSI installation, only Click-to-Run (C2R), it requires Office Deployment Tool (ODT) in order for you to customize it.

1. Download Office Deployment Tool [here](https://www.microsoft.com/en-us/download/details.aspx?id=49117).
2. Run the file to extract the contents.
3. Go to [Office Customization Tool XML generator](https://config.office.com/) to generate your own config file.
4. Answer the following questions.

If you are following my [crack guide](../how-to-crack-microsoft-office), you need to follow this steps because the XML generator does not acknowledge Professional Plus 2019 Retail, only volume version.

1. Open your generated XML file.
2. Change the product ID to ProPlus2019Retail like this `<Product ID="ProPlus2019Retail" PIDKEY="NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP">`
3. Change the update channel to Monthly (If you need stabilization) or Current (If you need latest bleeding edge) like this `Channel="Monthly"`. For more information, see [Overview of update channels](https://docs.microsoft.com/en-us/deployoffice/overview-update-channels).

In order to install Microsoft Office 2019 using your configuration file.

1. Put your configuration file on the folder where you extracted the deployment tool.
2. Run command prompt on the folder where you extracted the deployment tool.
3. Type `setup /configure config.xml` when config.xml is the filename of the configuration file.