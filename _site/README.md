# The Constitution of South Africa

We're making a readable, public-domain, print- and mobile-optimised version of the South African Constitution.

## About this project

Twenty years ago, many South Africans will remember, you could pick up a pocket-sized printed copy of the new constitution in every official language. It was an exciting time. But over the years, those little editions became harder and harder to find. 

> in the 2013/14 financial year, for the 54 million people living in South Africa, merely 30 000 constitutions were printed. Despite the fact that less than 10 percent of South Africans are first language English speakers, all of these constitutions were in English.
>
> This year, to date, only 11 000 constitutions have been printed. To the department’s credit, these were produced in each of South Africa’s national languages and in Braille.—[The Star, 10 Dec 2014](http://www.iol.co.za/the-star/cherish-our-constitution-1793582)

Today, to read the constitution, you have to find it online.

That's pretty straightforward if you can read English, and have a good Internet connection. You can read it on [gov.za](http://www.gov.za/documents/constitution-republic-south-africa-1996), on the [Department of Justice site](http://www.justice.gov.za/legislation/constitution/index.html), [Acts Online](http://www.acts.co.za/constitution-of-the-republic-of-south-africa-act-1996/) and on the [Constitutional Court website](http://www.constitutionalcourt.org.za/site/constitution/english-web/index.html). Those editions are up to date, too, in that they include all the amendments made to the constitution (about one each year) since it was first made law in 1996.

However, there are problems from there:

* If you don't read English, you have to download a PDF version. There are no plain-HTML versions of the constitution in all official languages. The official PDF versions are [on the DOJ's site](http://www.justice.gov.za/legislation/constitution/pdf.html). Thing is, if you're using a basic phone on a slow, expensive data connection, a PDF is not going to work for you. Not only is it slow to download, it's hard to read a PDF on a small screen, if your phone opens PDFs at all.
* PDFs are also unsuitable for accessibility: many people who're visually impaired (or disabled in other ways) use software that reads text to them. PDFs are often difficult for this software to read properly. For instance, they often don't include PDF bookmarks for navigation (as is the case with the official DOJ PDFs).
* And what are your options if you're illiterate? Should there be audio versions of the constitution in all languages? 
* Several versions available on the Internet are copyrighted. That means it's illegal to reuse them without permission. Versions published by government departments are not copyrighted (they can't be in terms of the South African Copyright Act 12:8a), but amended editions assembled by private people and companies are copyrighted. This makes it tricky to quickly reuse the text of the constitution in a new project. 
 
If we really want all South Africans to know their constitution – which includes our wonderful Bill of Rights – we have to do better. This project is a contribution to that effort.

We are creating a better version.

*	Our version is in the public domain. Anyone can use it for anything.
*	Online, the site is fast and simple. It uses only static HTML (e.g. no Javascript). This makes it cheap and easy to browse on any computer or phone; accessible to screen readers and magnifiers; and easy to reuse in other projects.
*	We include a printable PDF on a standard A5 page size, which is easy to print (e.g. almost any printer can print two pages on an A4 sheet, and one folded to A5, it's easy to carry around).
*	In print, we’ve retained readability without wasting space. And we’ve used open-licensed fonts that are easy to read and work well in many languages.
*	The project is open-source ([on GitHub](https://github.com/electricbookworks/constitution)), so that others can copy and contribute.
*	We are working with partners to include read-aloud audio versions of the constitution in all languages. We want any South African to be able to listen to any part of the constitution being read aloud in their own language, on their mobile phone.

If you have suggestions for ways to make it even better, [email info@myconstitution.co.za](mailto:info@myconstitution.co.za).

## Licence

[![CC0](http://i.creativecommons.org/p/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/)
To the extent possible under law, all contributors to this project waive all copyright and related or neighboring rights to the markdown and HTML versions of the text of the South African Constitution published here.

## Project roadmap

While this open-source project will always be a work in progress (for instance, content will need updating when the constitution is amended from time to time), the initial setup will happen in four parts. These project parts may happen simultaneously.

1. **Set up the website with the English version of the constitution.** This site is staged at [github.com/electricbookworks/constitution](https://github.com/electricbookworks/constitution). This site is built with the [Electric Book Workflow](https://github.com/electricbookworks/electric-book-workflow), an open framework for using markdown and Jekyll to publish long-form content in multiple formats. When ready, the static HTML is moved to a production site at [myconstitution.co.za](http://myconstitution.co.za).
2. **Create and add the text of the remaining 10 official languages.** This is done by converting the offical (DOJ) PDF versions of the constitution into markdown files for each part of the constitution in each language (following the structure established in the English edition).
3. **Quality assurance on the conversion to markdown.** Professional proofreaders cross-check our versions of the text in each language against the official DOJ versions.
4. **Add embedded audio files.** The CSIR's Meraka Institute is creating text-to-speech audio of each section of the constitution generated from our text. These audio files will be hosted on a free, cloud-based audio service and embedded as streaming audio at appropriate places in the text.

## Contributors

This project developed out of discussions between [Arthur Attwell](http://arthurattwell.com) at [Electric Book Works](http://electricbookworks.com) and Maureen Isaacson at the [Foundation for Human Rights](http://fhr.org.za/). Electric Book Works built the prototype and hosts the open-source project, which is managed by Arthur Attwell. Other contributors include:

* [The CSIR Meraka Institute](http://www.csir.co.za/meraka/): text-to-speech and accessibility
* [Fire and Lion](http://fireandlion.com)
* Barbara Attwell: markdown
* [Bangula Language Services](http://www.blc.co.za/): language consulting

If you'd like to help, [email info@myconstitution.co.za](mailto:info@myconstitution.co.za). You can also [log issues on GitHub](https://github.com/electricbookworks/constitution/issues).
