# WebOSINT [TryHackMe](https://tryhackme.com/room/webosint)

--------------------------------------------------------------------------------

![](./assets/logo.jpeg)

--------------------------------------------------------------------------------

## Index

--------------------------------------------------------------------------------

### Whois Registration

I initially looked at the browser based ones - but I felt really restricted with their usage - so I swapped over to the command line option.

```bash
whois "RepublicOfKoffee.com" | tee whois_lookup.log
```

[Log file](./domain_recon.log)

Now we can `grep` for elements we want to search for:

Registration Company: `NameCheap Inc`

Phone No.: `6613102107`

First nameserver: `DNS1.REGISTRAR-SERVERS.COM`

Registrant name: `Redacted for Privacy`

Registrant Country: `Panama`

--------------------------------------------------------------------------------

### Ghost of Websites Past

There, admittedly was not a huge amount of information available about the website. So, why don't we travel back in time?

[WayBackMachine Archive for RepublicOfKoffee.com](https://web.archive.org/web/20160410050253/http://www.republicofkoffee.com/)

Now we can go through the blog posts and try retrace the author's footsteps.

What is the first name of the author: `Steve`

What city and country are they writing from: `Gwangju, South Korea`

The temple name inside the National Park Steve frequents: `Jeungsimisa` (This one took a while!)

--------------------------------------------------------------------------------

### Digging into DNS

Now that we have some general insight into what the website was - it is time to dig into the technical aspects of it.

Using [ViewDNS.info](https://viewdns.info)'s historical IP lookup we can determine RoC's IP address in October of 2016 to be: `173.248.188.152`

Therefore based on the other domains on the IP address - what kind of hosting service can we assume the target uses: `shared`

How many times has the IP address changed in the history of the domain: `4`

--------------------------------------------------------------------------------

### Taking off the Training Wheels

What is the second nameserver: `NS2.HEAT.NET`

What was the IP address of the domain in December 2011: `72.52.192.240`

Based on the domains that share the same IP, what type of hosting service is the owner using: `shared`

What is the oldest capture WayBackMachine has of the domain: `06/01/97`

What is the first sentence of the first body paragraph from the final capture of 2001: `After years of great online gaming, it’s time to say good-bye.`

Using your Google-Fu, what was the original company responsible for the website: `SegaSoft`

What does the first header on the last capture of 2010 say: `heat.net - heating and cooling`

--------------------------------------------------------------------------------

### Taking A Peek Under the Hood of a Website

Useful search operands (more on the page):

Term   | Explaination                                           | External Resources
:----- | :----------------------------------------------------- | :-----------------------------------------------------------------------------------------------------
`<!--` | HTML Comments, visible in source code but not rendered |
`@`    | Email Addresses                                        | [Pivoting from an Email Address](https://nixintel.info/osint/12-osint-resources-for-e-mail-addresses/)
`.ext` | Extentions on a website

How many internal links are there on this website: `5` (I used curl with a regex pattern for the website but you can view the source code and manually view it)

How many external links are there in the text of the article: `1`

What is it: `purchase.org`

Find the Google Analytics code linked to the site: `UA-251372-24` (`ctrl/cmd-f` and search for Google or analytics)

Is the the Google Analytics code in use on another website? Yay or nay `nay` (Google for a UA lookup and plug it in, some websites don't refine based on the ending `-24` in our case - so `ctrl/cmd-f` for it!)

Does this website have any affiliate codes: `nay` (Again search for Google in the source code)

--------------------------------------------------------------------------------

### Final Exam: Connect the Dots

```
Experienced OSINT researchers will tell you that chasing rabbit holes all day and night without being able to make some solid connections is not OSINT.
```

Fire up a history analysis of both domains using [ViewDNS.info](https://ViewDNS.info) side-by-side an look for patterns. You'll notice that they have had an IP address owner common between them `Liquid Web` was the name at the time of writing but the _full_ answer is `Liquid Web L.L.C` almost like you had to do another history lookup ;)

--------------------------------------------------------------------------------

### Final Thoughts

Really enjoyed this - not the usual, reverse the image, find something but a more technical and relative analysis of the targets

--------------------------------------------------------------------------------

### Extra Resources

- [12 OSINT Resources for email address](https://nixintel.info/osint/12-osint-resources-for-e-mail-addresses/)

- [Unveiling Hidden Connections with Google Analytics IDs](https://www.bellingcat.com/resources/how-tos/2015/07/23/unveiling-hidden-connections-with-Google-analytics-ids/)

- [SEO Best Practice](https://ahrefs.com/blog/seo-best-practices/)

--------------------------------------------------------------------------------

![](./assets/complete.png)
