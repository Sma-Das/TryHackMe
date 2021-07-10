# Introduction to regex

While I have had experience with regex, it has mainly been through practice and usage here and there. This is a full room explaining the function of characters and examples of how to use them.

~~~
[  ] - charsets used to represent a range of valuee
[a-z] - letters from a to z
[a-cp-z] - letters from a to c or p to z
~~~

Negation also applies

~~~
[^a] - everything except a
[^a-p] - everything except letters between a to p
~~~

~~~
The . will match anything except a newline (\n)
The ? will match it optionally. eg hats? will match both hat and hats
~~~

Easier charset grouping

~~~
\d - matches a SINGLE digit eg. 9
\D - matches everything EXCEPT a digit eg. A or @
\w - matches an alphanumeric character like a or 3 (or _)
\W - matches non-alphanumeric characters like # or !
\s - matches whitespace characters like tabs or newlines
\S - matches everything except whitespaces
~~~

Repetition

~~~
* - 0 or more of the preceding character
+ - 1 or more of the preceding character
{n} - match the preceding character n times
{a,b} - match the preceding character between a to b (inc a,b)
{n,} - match the preceding character n or more times
~~~

Starts or end with

~~~
$ - matches at the end of the sentence eg. xyz$ matches abcxyz
^ - matches at the start of the sentense eg. ^abc matches abcxyz
    - This applies when ^ is not in [  ]
~~~

Groups

~~~
(  ) - either or pattern of patterns with maintained order eg. (Day|Night) will match either Day or Night but not any permutation of either
~~~

Regex although tricky, is something I really enjoy! There's something alluring about its simple complexity.

I haven't added any questions from the room but I will put some of the solutions I feel will have a lot of application when enumerating systems.

`^\$\d\$\S+` -> SHA-512 hashes
`(\d{1,3}\.){3}\d{1,3}` -> IPv4 Addresses
`(\w+)@(\w+)\.com` -> email addresses

There are plenty of pre-builts on the internet too!
