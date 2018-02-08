

# Pure Exporter usage instructions

Note: the application can be used to perform bulk modifications on Pure data. This is a rather complicated workflow that is not ideal. The functionality is included because I needed it and as a means to show what Pure itself is missing. Please refer to the  [advanced readme](https://github.com/CopyCat73/Pure-Dev/blob/master/ADVANCEDUSAGE.md) for detailed information. 


Essentially the application allows the user to collect publications by searching for them at the top of the interface, via one or more related organisations on the first tab, or from persons on the second tab. The third tab shows the outcome of these searches. Let's go over each tab:

![tab_1](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_1.png)

The organisation tab is initially empty. Click "refresh list" and you should see an organisation tree appearing.

![tab_1-1](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_1-1.png)

Nodes can be expanded and collapsed. Select organisations using the checkbox. Clicking on a collapsed organisation will select all subnodes. When you have a large number of organisations in your Pure installation, it is posible to search by UUID. The relevant node will be shown for selection. 

![tab_1-2](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_1-2.png)

Clicking "Get publications" will start metadata retrieval from the api. This can take a while, the activity indicator at the top right will show a running bar while the task is in progress.   

![activity_1](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/activity_1.png)

On the "people" tab, authors can be searched. Use "get publications" to retrieve related publications. 

![tab_2](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_2.png)

The publications tab will contain the results from searches. Whenever you perform a search and there are already publications in the result list, the app will ask you if you want to merge them or overwrite the result list. Results can be filtered by type. By entering an export set name and clicking "export selected", an xml file containing the selected records will be downloaded. This file is ready to be imported by the Pure bulk import option, so it can be used to move metadata to other systems or even the same system (see the [advanced readme](https://github.com/CopyCat73/Pure-Dev/blob/master/ADVANCEDUSAGE.md)). 

![tab_3](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_3.png)

Clicking "Test conversion for selected record" takes you to the record conversion tab. The upper text box shows the record as it is coming out of the Pure api, the lower box shows the converted record that is ready for imprt using the bulk loader. The "save import to file" button saves this single record as an import file. Using the "export selected" button on the publications tab also exports the metadata, but it delivers two files: one in the export format, and one in the import format. 

![tab_4](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_4.png)

The verify definitions tab compares the publication.xsd (the publications definition from Elsevier) to the PureApiToImport.xslt file to see if any fields in the xslt are still missing (they show up in red). This is an extra check when using [advanced options](https://github.com/CopyCat73/Pure-Dev/blob/master/ADVANCEDUSAGE.md) of the exporter. 

![tab_5](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_5.png)

The settings tab has mostly been covered in the install readme. There are also two options for debugging: requests and responses can be debugged and shown on the debug tab. On the bottom there is an option to download files with each export. Please consult the [advanced readme](https://github.com/CopyCat73/Pure-Dev/blob/master/ADVANCEDUSAGE.md) for the use of this option.

![tab_6](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_6.png)

If debugging is enabled on the settings tab, the debug tab will whos output for requests and/or responses. This is a nice way to learn about the api.

![tab_7](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_7.png)

Finally there is the "about" tab. It contains some information and functions as my area of silent protest.

![tab_8](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/tab_8.png)



