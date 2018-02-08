# Advanced usage : bulk editing Pure publications

## The use case

The main reason to construct this application was an issue we had with author affiliation. During the Pure implementation project, we mislabeled a number of organisations that in the previous CRIS were meant as placeholders for external publications. These placeholders were loaded in Pure as internal organisations, resulting in a large number of publications being affiliated to the university where they should not. Goal was to move these affiliations to a placeholder external organisation. This required a complex script to do the modifications, and while I have confidence in Elsevier staff for creating these kinds of scripts, I wanted to be in control (and save some euro's as well). 

## Bulk editing

Since Pure does not offer advanced bulk editing, theres is only one route do to complete manipulation of records in Pure:

- Export them via the (new) api. 
- Import them back via the bulk import. 

So the first task was to create a conversion from the API XML output to the XML format that the bulk loader uses. This is what the PureApiToImport.xslt essentially does. An XSLT file is basically a conversion or translation file between two different xml structures. 
Honestly I wish the bulk importer could just read the api export format (Elsevier you are welcome yo use my XSLT for that). 

So then we have an importable file that can be read back into Pure. This means you could do some (bulk) editing in the file by hand and load it back into the bulk importer. The bulk importer even has an option to update existing records! But in practice this option isn't usable because any record that has been touched by a user cannot be updated anymore; you can never be sure to have updated all records. 

The PureImportModifications.xslt file is what I used to modify the export file on the fly, also using XSLT. It applies general changes to all records and allows for some complex bulk editing logic. This XSLT can be modified to suit your own needs, and tested using the "apply modifications" option on the record conversion tab. 

## Working with files

The conversion from export to import should cover all the fields in the record metadata, including links such as DOI's. The full text files however is where it gets complicated. When you export an xml file with metadata, the file will mention all full text files to their current location in Pure. So whatever you do, DO NOT DELETE the records right away after exporting the xml. If you export a set of records, and then import it right away from the bulk importer, the importer will notice the file references in the xml and essentially copy the records in Pure along with the copied metadata. After the bulk importer has finished loading, the file copy is also complete and at that time you could delete the originals (at your own risk). This requires you to be able to filter the old versions versus the new ones in the Pure interface. 

Also worth to note here is that if you have the full text cover option enabled, the bulk importer will load the pdf from pure, generate a cover, save the new pdf with cover, and then a pdf will be shown from pure with duplicate covers (one hardcoded one generated), which is not what we want. So when copying records, make sure to turn off the cover function. 

It is also possible to turn on downloading of full text files along with the saved metadata xml (on the settings tab). Alongside the import- and export files there will be a folder containing all the full text files. Optionally you can specify a location for these files that will be stored in the metadata. This can be used to export a set of metadata plus full text from Pure, where the metadata references a temporary location, e.g. "http://mystorageserver.com/pdf/document1.pdf".

![filesettings_1](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/filesettings_1.png)

Switch the option on and type your required url in the box. The exportsetname is coming from the publications tab:

![filesettings_2](https://raw.githubusercontent.com/CopyCat73/CopyCat73.github.io/master/filesettings_2.png)

In the example above, the metadata export will point to the files at "http://yourserver.com/my_export_set_/nameofthepdf.pdf
The exported pdf's can then be placed at that web location. This way a complete set can be moved from one site to another for instance. Also make sure to disable cover functionality when exporting full text. 










