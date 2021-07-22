# Biohazard CTF [TryHackMe](https://tryhackme.com/room/biohazard)

---

![](https://tryhackme-images.s3.amazonaws.com/room-icons/72aca9d285c3156a05b34b7f6cc67ae6.png)

---

The sheer length of this room has made me decide to avoid giving an in-depth exploration of it but I will give a few pointers in regards to i.

* Be familiar and efficient with your decoders like [decode.fr](https://www.dcode.fr/en) and its awesome cipher identifier
* You will need to make good and organised notes throughout this CTF. Keep a track of the emblems you get through the rooms and record which ones
* Always check the source code of the page, there are lots of clues on how to solve the problem.

---

* For the image files, use the three main ways of embedding informatin in them. `steghide`, `exiftool`, and `binwalk`

---

Something critical, which I'll repeat, is to make sure you _know_ your tools and _when_ to use them.
Broad-scale tools like `nmap` and `gobuster` are not super needed (`gobuster` is irrelevant here).

Keep track of what directories you have solved after grabbing the flag and which remain - at some point you have to traverse all of them! (except images, js, and css).

- Keep following the steps
- Make sure you understand what can and has been done in each room

---

Going onto the box, PrivEsc was not needed: the user revealed towards the end as the betrayer has full sudo perms.
Always remember to run `sudo -l` kids!

---

## Final Thoughts

A different style of room than the typical boot2root box; following and managing a storyline.
It definitely has focus on decoding various ciphers and is great practice for that.

I typically don't leave my password hashes and other holds that I used to for the box - but I feel that it is not needed for this room.

Thanks!

![](https://i.pinimg.com/originals/63/68/e8/6368e80d5cae84bd87c967fe47400a71.png)
