# dilbertbot
Fetch new dilbert cartoons and post them on gnusocial

What you need: A PC capable of running 24/7. A Rasperry PI is a good choice.
Perl. You might have to install additional modules/librarys.
An account at a social network running the gnusocial API.
If your PC is running some linux flavor, all you have to do is to edit your crontab so that the perl script is run once a day.
Mine reads:
30 7 * * * /home/pi/bin/dilbert/dilbert.pl
meaning that each day at 7.30 AM the script will be run.
