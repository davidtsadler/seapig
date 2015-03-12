# [SEAPIG.NET](http://seapig.net)

Welcome to the **S**partan **E**Bay **A**pplication **P**rogramming **I**nterface **G**uide. Navigate and read the eBay API documentation on your mobile device with ease. 

## So why Seapig?

I've always found the official [documentation](https://go.developer.ebay.com/developers/ebay/documentation-tools/) a great resource for developers wishing to make use of the eBay API. For an API that is as complex as eBay's, this is an important tool that you should familiarize yourself with.

As helpful as I find the documentation, there are times when I just want something that is not quite as detailed so that I can quickly lookup the information that I need. Ideally something that is easy to navigate and that presents the vast amount of information in a consistent way.

This is why I've created Seapig. It aims to be a site that is a simplified, or *spartan*, version of the eBay API documentation. A site that I can use as a quick reference guide.

## What the site is
  - **Open to everyone**
  - Feel free to browse the site and use it as much as you want. Hosting costs permitting, I aim to keep the site running indefinitely.
  - **Updated regularly**
  - The site will be kept up to date with the official documents by regularly parsing the WSDLs that eBay provide.
  - **A work in progress**
  - The site will be improved by fixing issues and adding new features.
  - **Mobile friendly**
  - I wanted this site to be usable on a mobile device.
  - **Available on GitHub**
  - You can get the code from the GitHub [repository](https://github.com/davidtsadler/seapig) if you wish to generate a local copy of this site.

## What the site isn't 
  - **Endorsed by eBay**
  - This is my personal project. eBay in no way own or operate this site.
  - **Comprehensive**
  - By its very nature as being a quick reference it will never be as comprehensive as the official documentation. This is why you won't find things such as example code and detailed explanations.
  - **A replacement**
  - A huge amount of time and effort would have gone into creating the official documentation and there is no way that this site can ever be considered a replacement. Think of this site as an additional tool that I hope you find useful.

# PROJECT DETAILS  

This project uses the official eBay API WSDLs to generate a website. The resulting site is a reference guide to most of the services and methods available for the eBay API. The site has also been designed for ease of use on a mobile device. Essentially a series of Grunt tasks performs the following. 

  - Download the official WSDLs from eBay.
  - Transform the WSDLS into HTML with XSLT.
  - Combine the HTML with other files, e.g CSS, to produce a full website.

## Dependencies 

This project requires node and npm to be installed on your system. You can follow these [instructions](http://davidtsadler.com/archives/2012/05/06/installing-node-js-on-ubuntu/) if this isn't the case.

The transforming of the eBay WSDLs is done with the `saxonb-xslt` command line tool which must be present on your system.

## Quick Start

Open up your command line terminal and follow the steps below.

1. Clone the repository with `git clone https://github.com/davidtsadler/seapig.git`.
1. Use `cd seapig` to enter the project directory.
1. Run `npm install` to install the node dependencies.
1. Generate a local copy of the site with `make build localhost`.
1. Fire up the local web server with `make serve`.
1. Open your browser and navigate to [http://localhost:8080](http://localhost:8080).

## Workflow

The workflow below may be used when making changes to the code.

1. Start the node web server with `make serve`. Note that you will need to keep your console open to ensure the server remains running.
1. Run `make download`. This task downloads the latest version of the official eBay WSDLs into a temporary directory. The downloaded files can be kept while making changes to the code. You will only need to run this task again if you delete the WSDLs or if you require the latest versions. 
1. Run `make transform localhost`. This task will transform the WSDLs into HTML that is then combined with other files, e.g CSS, to produce the full site. It will also prepare the code so it can be served up by the node web server. The XSL files used for the transforming can be found in the `xsl` directory. Files that are not generated from the WSDLs, such as the 'About' page, can be found in the `app` directory.
1. See the local version of the site by opening your browser at [http://localhost:8080](http://localhost:8080).
1. Edit the code and make any changes that you require.
1. Run `make transform localhost` again.
1. Test your changes in the browser.
1. Repeat steps 5-7 until you are ready to commit your changes.

## Copyright & License

Copyright (c) 2014 David T. Sadler - Released under the MIT License.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
